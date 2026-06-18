# Secure Section-Wise Document Ingestion Pipeline

A production-grade pipeline for processing regulatory documents into structured, searchable data with multi-tenant security isolation.

## Features

- **PDF Processing**: PyMuPDF → NuMarkdown VLM (Aphrodite API) → Structured Markdown
- **Section-Wise Chunking**: Regex-based splitting preserving document hierarchy
- **Vector Embeddings**: Configurable ONNX local or remote API embedding generation
- **Elasticsearch Indexing**: Dense vector + text hybrid search with department-level filtering
- **Excel KRI Ingestion**: Configurable column mapping for Key Risk Indicator data
- **Oracle Database**: Job tracking, document metadata, KRI storage with VPD security
- **Admin APIs**: FastAPI CRUD for departments, persons, and inspections
- **Multi-Environment**: `.env` secrets + `.properties` per environment (dev/sit/prod)

## Project Structure

```
├── .env                        # Secrets (not committed)
├── .env.example                # Secrets template
├── config/
│   ├── dev.properties          # Dev environment config
│   ├── sit.properties          # SIT environment config
│   └── prod.properties         # Production config
├── src/
│   └── ingestion/
│       ├── config/             # Settings loader (.env + .properties → Pydantic)
│       ├── clients/            # Aphrodite LLM, Elasticsearch, Embedding providers
│       ├── db/                 # Oracle connection pool + repository
│       ├── pipeline/           # PDF, Markdown, Splitter, Metadata, Excel, Orchestrator
│       ├── api/                # FastAPI admin API + routes
│       ├── utils/              # Logging configuration
│       └── cli.py              # CLI entry point
├── requirements.txt
└── architecture.md
```

## Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
# Copy and edit the secrets file
cp .env.example .env
# Edit .env with your Oracle password, Aphrodite API key, ES password

# Set the active environment
set APP_ENV=dev     # Windows
export APP_ENV=dev  # Linux/Mac
```

### 3. Review Environment Config

Edit `config/dev.properties` (or `sit.properties`/`prod.properties`) to match your infrastructure:

- Oracle DB connection details
- Elasticsearch host/port
- Aphrodite API base URL and model names
- Embedding provider settings
- Pipeline concurrency settings
- KRI Excel column mapping

## Usage

### Run the Admin API (Master Data Management)

```bash
cd src
python -m ingestion serve
```

The API will be available at `http://localhost:8000` with Swagger docs at `/docs`.

**Create master data before ingestion:**

```bash
# Create a department
curl -X POST http://localhost:8000/api/departments \
  -H "Content-Type: application/json" \
  -d '{"dept_name": "Risk Management"}'

# Create an inspection
curl -X POST http://localhost:8000/api/inspections \
  -H "Content-Type: application/json" \
  -d '{
    "insp_reference_code": "INS-2025-001",
    "dept_id": 1,
    "entity_name": "Acme Bank",
    "evaluation_year": 2025,
    "evaluation_date": "2025-03-15"
  }'
```

### Run the Ingestion Pipeline

```bash
cd src

# Process a single inspection folder
python -m ingestion ingest --input /path/to/data/INS-2025-001/

# Process all inspection folders in a parent directory
python -m ingestion ingest --input /path/to/data/
```

**Expected directory structure:**

```
/data/
  INS-2025-001/           # Folder name = insp_reference_code
    annual_report.pdf      # PDF → NuMarkdown → Embed → Elasticsearch
    kri_data.xlsx          # Excel → Parse → Oracle kri_data table
  INS-2025-002/
    inspection_report.pdf
```

### Pipeline Flow

**PDF Documents:**
1. PyMuPDF renders pages to high-resolution images
2. NuMarkdown VLM (via Aphrodite) converts images to Markdown
3. LLM extracts metadata (entity_name, evaluation_year) from first page
4. Regex splitter divides markdown into sections
5. Embedding provider generates vectors per section
6. Sections bulk-indexed into Elasticsearch with security metadata

**Excel Documents:**
1. openpyxl parses the file using configurable column mapping
2. KRI records batch-inserted into Oracle `kri_data` table

## Configuration Reference

### .env (Secrets)

| Variable | Description |
|---|---|
| `APP_ENV` | Active environment: `dev`, `sit`, `prod` |
| `ORACLE_PASSWORD` | Oracle database password |
| `APHRODITE_API_KEY` | Aphrodite API key (blank if no auth) |
| `ES_PASSWORD` | Elasticsearch password |

### Properties Files

See `config/dev.properties` for all available settings with descriptions.

## API Endpoints

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `POST` | `/api/departments` | Create department |
| `GET` | `/api/departments` | List departments |
| `GET` | `/api/departments/{id}` | Get department |
| `PUT` | `/api/departments/{id}` | Update department |
| `DELETE` | `/api/departments/{id}` | Delete department |
| `POST` | `/api/persons` | Create person |
| `GET` | `/api/persons` | List persons |
| `GET` | `/api/persons/{id}` | Get person |
| `PUT` | `/api/persons/{id}` | Update person |
| `DELETE` | `/api/persons/{id}` | Delete person |
| `POST` | `/api/inspections` | Create inspection |
| `GET` | `/api/inspections` | List inspections |
| `GET` | `/api/inspections/{id}` | Get inspection |
| `PUT` | `/api/inspections/{id}` | Update inspection |
| `DELETE` | `/api/inspections/{id}` | Delete inspection |
