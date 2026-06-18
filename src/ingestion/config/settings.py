"""
Application settings — Pydantic models loaded from .env + .properties files.

Configuration hierarchy:
  1. .env file → secrets (passwords, API keys)
  2. config/{APP_ENV}.properties → environment-specific settings
  3. Environment variables → override any setting

Usage:
    from ingestion.config.settings import get_settings
    settings = get_settings()
"""

import os
import logging
from functools import lru_cache
from pathlib import Path

from pydantic import BaseModel, Field
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

from ingestion.config.properties import load_properties

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Resolve project root (two levels up from this file: src/ingestion/config/)
# ---------------------------------------------------------------------------
_CONFIG_DIR = Path(__file__).resolve().parent
_SRC_DIR = _CONFIG_DIR.parent.parent
_PROJECT_ROOT = _SRC_DIR.parent


# ---------------------------------------------------------------------------
# Sub-setting models (plain Pydantic models, not BaseSettings)
# ---------------------------------------------------------------------------

class OracleSettings(BaseModel):
    """Oracle Database connection configuration."""

    host: str = "localhost"
    port: int = 1521
    service_name: str = "XEPDB1"
    user: str = "ingestion_user"
    password: str = ""
    pool_min: int = 1
    pool_max: int = 3


class ElasticsearchSettings(BaseModel):
    """Elasticsearch connection configuration."""

    host: str = "http://localhost"
    port: int = 9200
    index: str = "regulatory_documents_index"
    user: str = "elastic"
    password: str = ""
    use_ssl: bool = False


class AphroditeModelConfig(BaseModel):
    """Configuration for a single Aphrodite model endpoint."""

    model: str = ""
    max_tokens: int = 4096
    temperature: float = 0.1


class AphroditeSettings(BaseModel):
    """Aphrodite LLM API configuration."""

    base_url: str = "http://localhost:2242/v1"
    api_key: str = ""
    numarkdown: AphroditeModelConfig = Field(default_factory=AphroditeModelConfig)
    metadata: AphroditeModelConfig = Field(default_factory=AphroditeModelConfig)
    reasoning: AphroditeModelConfig = Field(default_factory=AphroditeModelConfig)
    sql_coder: AphroditeModelConfig = Field(default_factory=AphroditeModelConfig)

class AgentSettings(BaseModel):
    """Configuration for the Agentic Backend LangGraph."""
    schema_index: str = "oracle_schema_index"
    scope_policy: str = "Allowed topics: Banking..."


class EmbeddingSettings(BaseModel):
    """Embedding generation configuration (ONNX local or remote API)."""

    provider: str = "onnx"  # "onnx" or "api"
    model_id: str = "nomic-ai/nomic-embed-text-v1.5"
    dimension: int = 384
    max_length: int = 8192
    api_url: str = ""
    api_model: str = ""


class PipelineSettings(BaseModel):
    """Pipeline execution configuration."""

    max_workers: int = 2
    http_timeout: int = 180
    http_connect_timeout: int = 10
    dpi_scale: float = 2.0


class KriColumnMapping(BaseModel):
    """Configurable column mapping for Excel → kri_data table."""

    indicator_code: str = "Indicator Code"
    indicator_name: str = "Indicator Name"
    actual_value: str = "Actual Value"
    threshold_limit: str = "Threshold Limit"
    report_date: str = "Report Date"


class LoggingSettings(BaseModel):
    """Logging configuration."""

    dir: str = "logs"
    level: str = "INFO"
    max_bytes: int = 10_485_760  # 10 MB
    backup_count: int = 5


class ApiSettings(BaseModel):
    """Admin API server configuration."""

    host: str = "0.0.0.0"
    port: int = 8000


# ---------------------------------------------------------------------------
# Top-level secrets loaded from .env via pydantic-settings
# ---------------------------------------------------------------------------

class SecretsSettings(BaseSettings):
    """Secrets loaded from .env file and environment variables."""

    app_env: str = Field(default="dev", alias="APP_ENV")
    oracle_password: str = Field(default="", alias="ORACLE_PASSWORD")
    aphrodite_api_key: str = Field(default="", alias="APHRODITE_API_KEY")
    es_password: str = Field(default="", alias="ES_PASSWORD")

    class Config:
        env_file = str(_PROJECT_ROOT / ".env")
        env_file_encoding = "utf-8"
        extra = "ignore"


# ---------------------------------------------------------------------------
# Aggregated application settings
# ---------------------------------------------------------------------------

class AppSettings(BaseModel):
    """
    Top-level application settings container.

    Aggregates all sub-settings from .env secrets and .properties config.
    """

    env: str = "dev"
    oracle: OracleSettings = Field(default_factory=OracleSettings)
    elasticsearch: ElasticsearchSettings = Field(default_factory=ElasticsearchSettings)
    aphrodite: AphroditeSettings = Field(default_factory=AphroditeSettings)
    embedding: EmbeddingSettings = Field(default_factory=EmbeddingSettings)
    pipeline: PipelineSettings = Field(default_factory=PipelineSettings)
    kri_columns: KriColumnMapping = Field(default_factory=KriColumnMapping)
    logging: LoggingSettings = Field(default_factory=LoggingSettings)
    api: ApiSettings = Field(default_factory=ApiSettings)
    agent: AgentSettings = Field(default_factory=AgentSettings)


# ---------------------------------------------------------------------------
# Settings loader
# ---------------------------------------------------------------------------

def _build_settings() -> AppSettings:
    """
    Build AppSettings by merging .env secrets with .properties config.

    Resolution order:
        1. Load secrets from .env
        2. Determine APP_ENV (dev/sit/prod)
        3. Load config/{APP_ENV}.properties
        4. Merge into typed Pydantic models
    """
    # Load .env file
    env_path = _PROJECT_ROOT / ".env"
    if env_path.is_file():
        load_dotenv(env_path)

    # Load secrets
    secrets = SecretsSettings()
    app_env = secrets.app_env

    # Load environment-specific properties
    props_path = _PROJECT_ROOT / "config" / f"{app_env}.properties"
    if not props_path.is_file():
        raise FileNotFoundError(
            f"Configuration file not found for environment '{app_env}': {props_path}"
        )

    props = load_properties(str(props_path))

    # Build sub-settings from properties + secrets
    oracle = OracleSettings(
        host=props.get("oracle.host", "localhost"),
        port=int(props.get("oracle.port", "1521")),
        service_name=props.get("oracle.service_name", "XEPDB1"),
        user=props.get("oracle.user", "ingestion_user"),
        password=secrets.oracle_password,
        pool_min=int(props.get("oracle.pool.min", "1")),
        pool_max=int(props.get("oracle.pool.max", "3")),
    )

    elasticsearch = ElasticsearchSettings(
        host=props.get("es.host", "http://localhost"),
        port=int(props.get("es.port", "9200")),
        index=props.get("es.index", "regulatory_documents_index"),
        user=props.get("es.user", "elastic"),
        password=secrets.es_password,
        use_ssl=props.get("es.use_ssl", "false").lower() == "true",
    )

    aphrodite = AphroditeSettings(
        base_url=props.get("aphrodite.base_url", "http://localhost:2242/v1"),
        api_key=secrets.aphrodite_api_key,
        numarkdown=AphroditeModelConfig(
            model=props.get("aphrodite.numarkdown.model", ""),
            max_tokens=int(props.get("aphrodite.numarkdown.max_tokens", "4096")),
            temperature=float(props.get("aphrodite.numarkdown.temperature", "0.1")),
        ),
        metadata=AphroditeModelConfig(
            model=props.get("aphrodite.metadata.model", ""),
            max_tokens=int(props.get("aphrodite.metadata.max_tokens", "1024")),
            temperature=float(props.get("aphrodite.metadata.temperature", "0.0")),
        ),
        reasoning=AphroditeModelConfig(
            model=props.get("aphrodite.reasoning.model", "nemotron-30b"),
            max_tokens=int(props.get("aphrodite.reasoning.max_tokens", "4096")),
            temperature=float(props.get("aphrodite.reasoning.temperature", "0.1")),
        ),
        sql_coder=AphroditeModelConfig(
            model=props.get("aphrodite.sql_coder.model", "qwen-coder"),
            max_tokens=int(props.get("aphrodite.sql_coder.max_tokens", "2048")),
            temperature=float(props.get("aphrodite.sql_coder.temperature", "0.0")),
        ),
    )

    embedding = EmbeddingSettings(
        provider=props.get("embedding.provider", "onnx"),
        model_id=props.get("embedding.model_id", "nomic-ai/nomic-embed-text-v1.5"),
        dimension=int(props.get("embedding.dimension", "384")),
        max_length=int(props.get("embedding.max_length", "8192")),
        api_url=props.get("embedding.api_url", ""),
        api_model=props.get("embedding.api_model", ""),
    )

    pipeline = PipelineSettings(
        max_workers=int(props.get("pipeline.max_workers", "2")),
        http_timeout=int(props.get("pipeline.http_timeout", "180")),
        http_connect_timeout=int(props.get("pipeline.http_connect_timeout", "10")),
        dpi_scale=float(props.get("pipeline.dpi_scale", "2.0")),
    )

    kri_columns = KriColumnMapping(
        indicator_code=props.get("kri.column.indicator_code", "Indicator Code"),
        indicator_name=props.get("kri.column.indicator_name", "Indicator Name"),
        actual_value=props.get("kri.column.actual_value", "Actual Value"),
        threshold_limit=props.get("kri.column.threshold_limit", "Threshold Limit"),
        report_date=props.get("kri.column.report_date", "Report Date"),
    )

    logging_cfg = LoggingSettings(
        dir=props.get("logging.dir", "logs"),
        level=props.get("logging.level", "INFO"),
        max_bytes=int(props.get("logging.max_bytes", "10485760")),
        backup_count=int(props.get("logging.backup_count", "5")),
    )

    api = ApiSettings(
        host=props.get("api.host", "0.0.0.0"),
        port=int(props.get("api.port", "8000")),
    )

    agent = AgentSettings(
        schema_index=props.get("agent.index.schema", "oracle_schema_index"),
        scope_policy=props.get("agent.scope.policy", "Allowed topics: Banking, Inspections, KRIs, Action Points, Regulatory Compliance, Cyber Security in Banks. Disallowed: Writing code, general web search, weather, non-banking topics."),
    )

    return AppSettings(
        env=app_env,
        oracle=oracle,
        elasticsearch=elasticsearch,
        aphrodite=aphrodite,
        embedding=embedding,
        pipeline=pipeline,
        kri_columns=kri_columns,
        logging=logging_cfg,
        api=api,
        agent=agent,
    )


@lru_cache(maxsize=1)
def get_settings() -> AppSettings:
    """
    Get the application settings singleton.

    Settings are built once and cached for the lifetime of the process.
    """
    settings = _build_settings()
    logger.info("Settings loaded for environment: %s", settings.env)
    return settings
