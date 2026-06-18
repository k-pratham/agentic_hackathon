import sys
import os
import pandas as pd
from elasticsearch import Elasticsearch

# Ensure src is in path to import ingestion.config
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from ingestion.config.settings import get_settings

def get_es_client() -> Elasticsearch:
    settings = get_settings()
    host = settings.elasticsearch.host
    port = settings.elasticsearch.port
    user = settings.elasticsearch.user
    password = settings.elasticsearch.password
    
    if user and password:
        return Elasticsearch(f"{host}:{port}", basic_auth=(user, password))
    return Elasticsearch(f"{host}:{port}")

def index_schemas():
    settings = get_settings()
    es = get_es_client()
    index_name = settings.agent.schema_index
    
    print(f"Creating index: {index_name}")
    if not es.indices.exists(index=index_name):
        es.indices.create(
            index=index_name,
            body={
                "mappings": {
                    "properties": {
                        "dataset_id": {"type": "keyword"},
                        "dataset_name": {"type": "text"},
                        "description": {"type": "text"},
                        "dimensions": {"type": "text"},
                        "sector": {"type": "keyword"}
                    }
                }
            }
        )
    
    # Path to the Excel file
    excel_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../data/RBI_DBIE_Master_Database.xlsx'))
    print(f"Reading Excel: {excel_path}")
    
    try:
        df = pd.read_excel(excel_path)
        
        # We index each row as a dataset schema
        count = 0
        for _, row in df.iterrows():
            doc = {
                "dataset_id": str(row.get("Dataset ID", "")),
                "dataset_name": str(row.get("Dataset Name", "")),
                "description": str(row.get("Description", "")),
                "dimensions": str(row.get("Dimensions", "")),
                "sector": str(row.get("Sector", ""))
            }
            
            es.index(index=index_name, body=doc)
            count += 1
            
        print(f"Successfully indexed {count} schema documents into {index_name}.")
    except Exception as e:
        print(f"Failed to read/index Excel schema: {str(e)}")

if __name__ == "__main__":
    index_schemas()
