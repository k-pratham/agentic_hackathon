import os
os.environ["ELASTIC_CLIENT_APIVERSIONING"] = "1"
import re
from typing import List, Dict, Any
from elasticsearch import Elasticsearch
import oracledb
from langchain_core.tools import tool
import sys
import os

# Ensure src is in path to import ingestion.config
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from ingestion.config.settings import get_settings

# --- Elasticsearch Helper ---
def get_es_client() -> Elasticsearch:
    settings = get_settings()
    host = settings.elasticsearch.host
    port = settings.elasticsearch.port
    user = settings.elasticsearch.user
    password = settings.elasticsearch.password
    
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    
    if user and password:
        return Elasticsearch(f"{host}:{port}", basic_auth=(user, password), verify_certs=False, headers=headers)
    return Elasticsearch(f"{host}:{port}", verify_certs=False, headers=headers)

# --- Oracle DB Helper ---
def get_oracle_connection():
    settings = get_settings()
    host = settings.dbie_oracle.host
    port = settings.dbie_oracle.port
    service_name = settings.dbie_oracle.service_name
    user = settings.dbie_oracle.user
    password = settings.dbie_oracle.password
    
    dsn = oracledb.makedsn(host, port, service_name=service_name)
    return oracledb.connect(user=user, password=password, dsn=dsn)

def get_app_oracle_connection():
    settings = get_settings()
    host = settings.app_oracle.host
    port = settings.app_oracle.port
    service_name = settings.app_oracle.service_name
    user = settings.app_oracle.user
    password = settings.app_oracle.password
    
    dsn = oracledb.makedsn(host, port, service_name=service_name)
    return oracledb.connect(user=user, password=password, dsn=dsn)

# ==========================================
# AGENT TOOLS
# ==========================================

@tool
def check_knowledge_scope(query: str) -> str:
    """
    Check the internal policy guidelines to see if a query is allowed.
    """
    settings = get_settings()
    return f"Scope Policy: {settings.agent.scope_policy}"

@tool
def data_discovery_tool(entity_name: str, department_id: int) -> str:
    """
    Search if a specific entity (like a bank name) exists in the database.
    Use this to verify an entity's existence before routing.
    """
    settings = get_settings()
    es = get_es_client()
    index_name = settings.elasticsearch.index
    try:
        response = es.search(
            index=index_name,
            query={
                "multi_match": {
                    "query": entity_name,
                    "fields": ["entity_name^3", "text_content"],
                    "fuzziness": "AUTO"
                }
            },
            size=10
        )
        if response["hits"]["total"]["value"] > 0:
            for hit in response["hits"]["hits"]:
                if str(hit["_source"].get("dept_id", "")) == str(department_id):
                    return f"Entity '{entity_name}' FOUND in this department."
            return f"Entity '{entity_name}' FOUND, but it is restricted to a different department (RBAC)."
        return f"Entity '{entity_name}' NOT FOUND."
    except Exception as e:
        return f"Error searching entity: {str(e)}"

@tool
def search_schema_index(query: str) -> str:
    """
    Search the structured data schema to find relevant tables or datasets.
    Use this tool BEFORE writing a SQL query to understand the available data.
    """
    settings = get_settings()
    es = get_es_client()
    try:
        response = es.search(
            index=settings.agent.schema_index,
            query={
                "multi_match": {
                    "query": query,
                    "fields": ["table_name^2", "table_description", "keywords", "text_content"]
                }
            },
            size=5
        )
        
        results = []
        for hit in response["hits"]["hits"]:
            src = hit["_source"]
            results.append(
                f"- Table: {src.get('table_name')}\n"
                f"  Desc: {src.get('table_description')}\n"
                f"  Keywords: {src.get('keywords')}\n"
                f"  Example Queries: {src.get('suggested_queries')}"
            )
            
        return "Found Schema Matches:\n" + "\n".join(results) if results else "No schema found for query."
    except Exception as e:
        return f"Error searching schema index: {str(e)}"

@tool
def execute_oracle_sql(sql_query: str) -> str:
    """
    Execute a read-only SQL query against the Oracle Database.
    Will reject any query that attempts to modify data.
    """
    dangerous_keywords = ['INSERT', 'UPDATE', 'DELETE', 'DROP', 'TRUNCATE', 'ALTER', 'GRANT', 'REVOKE', 'MERGE']
    upper_query = sql_query.upper()
    for word in dangerous_keywords:
        if re.search(rf'\b{word}\b', upper_query):
            return f"ERROR: Execution denied. Query contains forbidden modification keyword: {word}."
            
    try:
        with get_oracle_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(sql_query)
                columns = [col[0] for col in cursor.description]
                rows = cursor.fetchall()
                
                if not rows:
                    return "Query executed successfully but returned 0 rows."
                
                import tabulate
                limit = 50
                output = tabulate.tabulate(rows[:limit], headers=columns, tablefmt="pipe")
                if len(rows) > limit:
                    output += f"\n\n...(Output truncated, {len(rows) - limit} more rows available)"
                return output
    except Exception as e:
        return f"Oracle Execution Error: {str(e)}"

from ingestion.clients.embedding import create_embedding_provider

@tool
def search_regulatory_vectors(query: str, department_id: int) -> str:
    """
    Perform a hybrid search (keyword + semantic cosine similarity) across unstructured regulatory document text.
    Strictly filters results to the specified department_id.
    """
    settings = get_settings()
    es = get_es_client()
    
    try:
        # Generate the query vector
        embedder = create_embedding_provider(settings.embedding)
        query_vector = embedder.generate(query)
        embedder.close()
        
        response = es.search(
            index=settings.elasticsearch.index,
            query={
                "script_score": {
                    "query": {
                        "bool": {
                            "should": [
                                {"match": {"text_content": query}},
                                {"match": {"entity_name": query}}
                            ],
                            "minimum_should_match": 0,
                            "filter": [{"term": {"dept_id": department_id}}]
                        }
                    },
                    "script": {
                        "source": "cosineSimilarity(params.query_vector, 'content_vector') + 1.0",
                        "params": {"query_vector": query_vector}
                    }
                }
            },
            size=3
        )
        results = []
        for hit in response["hits"]["hits"]:
            src = hit["_source"]
            score = hit.get("_score", 0.0)
            results.append(f"- Entity: {src.get('entity_name')} (Report Year: {src.get('report_year')})\n  Section: {src.get('section_index')} (Score: {score:.2f})\n  Content: {src.get('text_content')}")
        return "Found Unstructured Findings (Hybrid Search):\n" + "\n\n".join(results) if results else "No text findings found for your department."
    except Exception as e:
        return f"Error searching vector index: {str(e)}"

@tool
def python_data_tool(python_code: str, data_string: str) -> str:
    """
    Executes a pandas python script to analyze tabular data. 
    The 'python_code' must expect a pandas dataframe named 'df'.
    """
    import pandas as pd
    from io import StringIO
    import contextlib
    
    try:
        df = pd.read_csv(StringIO(data_string), sep='|', skipinitialspace=True).dropna(axis=1, how='all')
        df.columns = df.columns.str.strip()
        
        stdout = StringIO()
        with contextlib.redirect_stdout(stdout):
            local_vars = {'df': df, 'pd': pd}
            exec(python_code, globals(), local_vars)
            
        return stdout.getvalue() or "Code executed successfully but printed nothing."
    except Exception as e:
        return f"Python Execution Error: {str(e)}"

@tool
def chart_config_tool(chart_type: str, x_axis: str, y_axis: str, title: str) -> str:
    """
    Outputs a structured JSON configuration for the Streamlit UI to render a chart.
    """
    import json
    config = {
        "action": "RENDER_CHART",
        "chart_type": chart_type,
        "x_axis": x_axis,
        "y_axis": y_axis,
        "title": title
    }
    return json.dumps(config)
