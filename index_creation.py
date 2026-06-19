import json
import httpx

# Elasticsearch connection settings (change host/port if necessary)
ES_HOST = "https://192.168.61.93"
ES_PORT = 9200
INDEX_NAME = "hackathon-samaritans-regulatory_documents_index"

# Optional: Add authentication tuple if security is enabled
# AUTH = ("elastic", "your_password") 
AUTH = ("samaritans", "F5k%Lk5viBB#bYdLVRft")

# The complete production index mappings
INDEX_MAPPING = {
    "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "index.refresh_interval": "30s"
    },
    "mappings": {
        "properties": {
            "doc_id": {"type": "keyword"},
            "insp_id": {"type": "integer"},
            "dept_id": {"type": "integer"},
            "document_type": {"type": "keyword"},
            "document_category": {"type": "keyword"},
            "file_extension": {"type": "keyword"},
            "entity_name": {"type": "keyword"},
            "report_year": {"type": "integer"},
            "section_index": {"type": "integer"},
            "text_content": {
                "type": "text",
                "analyzer": "standard"
            },
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
            
        print("Creating index with KNN and HNSW vector configurations...")
        response = client.put(url, json=INDEX_MAPPING)
        if response.status_code in (200, 201):
            print("Successfully created the index!")
        else:
            print(f"Failed to create index: {response.status_code} - {response.text}")

if __name__ == "__main__":
    create_index()
