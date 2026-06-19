import json
import httpx

# Elasticsearch connection settings
ES_HOST = "https://192.168.61.93"
ES_PORT = 9200
INDEX_NAME = "oracle_schema_index"

# Authentication tuple
AUTH = ("samaritans", "F5k%Lk5viBB#bYdLVRft")

# The DBIE Schema mapping based on the metadata requirements you shared
INDEX_MAPPING = {
    "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "index.refresh_interval": "30s"
    },
    "mappings": {
        "properties": {
            "table_name": {"type": "keyword"},
            "table_description": {
                "type": "text",
                "analyzer": "standard"
            },
            "data_purpose": {
                "type": "text",
                "analyzer": "standard"
            },
            "keywords": {
                "type": "text",
                "analyzer": "standard"
            },
            "time_columns": {"type": "text"},
            "measure_columns": {"type": "text"},
            "dimension_columns": {"type": "text"},
            "suggested_queries": {
                "type": "text",
                "analyzer": "standard"
            },
            "rbi_topic": {"type": "keyword"},
            
            # A consolidated string combining the fields above.
            # Your embedding model will generate vectors based on this text.
            "text_content": {
                "type": "text",
                "analyzer": "standard"
            },
            
            # The semantic vector for RAG lookup by the Routing Agent
            "content_vector": {
                "type": "dense_vector",
                "dims": 384,
                "index": True,
                "similarity": "cosine",
                "index_options": {
                    "type": "int8_hnsw",
                    "m": 16,
                    "ef_construction": 100
                }
            }
        }
    }
}

def create_index():
    base_url = f"{ES_HOST}:{ES_PORT}"
    url = f"{base_url}/{INDEX_NAME}"
    
    print(f"Checking if index '{INDEX_NAME}' exists...")
    with httpx.Client(auth=AUTH, verify=False) as client:
        # Check if exists
        response = client.head(url)
        if response.status_code == 200:
            print(f"Index '{INDEX_NAME}' already exists!")
            return
            
        print("Creating DBIE schema index...")
        response = client.put(url, json=INDEX_MAPPING)
        if response.status_code in (200, 201):
            print("Successfully created the index!")
        else:
            print(f"Failed to create index: {response.status_code} - {response.text}")

import pandas as pd
from ingestion.config.settings import get_settings
from ingestion.clients.embedding import create_embedding_provider

def insert_actual_data():
    """
    Reads the actual table metadata from the Excel file, generates vectors
    using the application's configured embedding model, and inserts into Elasticsearch.
    """
    base_url = f"{ES_HOST}:{ES_PORT}"
    
    # 1. Initialize the embedding model from our app settings
    print("Loading embedding provider...")
    settings = get_settings()
    embedder = create_embedding_provider(settings.embedding)
    
    # 2. Read the Excel data
    print("Reading Excel file...")
    excel_path = "data/final_dbie_2_agent_index.xlsx"
    df = pd.read_excel(excel_path, sheet_name="Agent_Table_Index")
    df = df.fillna("") # Replace NaNs with empty strings
    
    print(f"Found {len(df)} tables to index.")
    
    # 3. Process and insert each row
    with httpx.Client(auth=AUTH, verify=False, timeout=60.0) as client:
        for index, row in df.iterrows():
            table_name = str(row.get("Oracle Table Name", ""))
            if not table_name:
                continue
                
            table_description = str(row.get("Explanation of Table", ""))
            data_purpose = str(row.get("Data Purpose", ""))
            keywords = str(row.get("Keywords", ""))
            suggested_queries = str(row.get("Suggested User Query Patterns", ""))
            
            # Construct rich text content for semantic matching
            text_content = f"Table {table_name}. {table_description}. Purpose: {data_purpose}. Keywords: {keywords}. Example queries: {suggested_queries}"
            
            print(f"Generating embeddings for {table_name}...")
            vector = embedder.generate(text_content)
            
            doc = {
                "table_name": table_name,
                "table_description": table_description,
                "data_purpose": data_purpose,
                "keywords": keywords,
                "time_columns": str(row.get("Primary Time Columns", "")),
                "measure_columns": str(row.get("Key Measure Columns", "")),
                "dimension_columns": str(row.get("Key Dimension Columns", "")),
                "suggested_queries": suggested_queries,
                "rbi_topic": str(row.get("Related RBI Popular Data Topics", "")),
                "text_content": text_content,
                "content_vector": vector
            }
            
            url = f"{base_url}/{INDEX_NAME}/_doc"
            response = client.post(url, json=doc)
            
            if response.status_code in (200, 201):
                print(f"Successfully inserted {table_name}")
            else:
                print(f"Failed to insert {table_name}: {response.text}")
                
    embedder.close()

if __name__ == "__main__":
    create_index()
    # Execute the actual data ingestion
    insert_actual_data()
