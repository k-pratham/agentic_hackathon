"""
FastAPI application setup — Admin API for master data management.

Configures the FastAPI app with:
  - Lifespan management (DB pool init/close)
  - CORS middleware
  - Route registration for departments, persons, inspections
"""

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from ingestion.config.settings import get_settings
from ingestion.db.connection import OracleConnectionPool
from ingestion.db.repository import IngestionRepository
from ingestion.utils.logging import setup_logging_from_settings
from ingestion.api.routes import departments, persons, inspections

logger = logging.getLogger(__name__)

# Module-level references for cleanup
_pool: OracleConnectionPool | None = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan manager.

    Initializes the Oracle connection pool and repository on startup,
    and closes the pool on shutdown.
    """
    global _pool

    settings = get_settings()
    setup_logging_from_settings(settings)

    logger.info("Starting Admin API — environment: %s", settings.env)

    # Initialize Oracle connection pool
    _pool = OracleConnectionPool(settings.oracle)
    _pool.initialize()

    # Create repository and inject into route modules
    repo = IngestionRepository(_pool)
    departments.set_repository(repo)
    persons.set_repository(repo)
    inspections.set_repository(repo)

    logger.info("Admin API ready — Oracle pool initialized")

    yield

    # Shutdown
    if _pool is not None:
        _pool.close()
    logger.info("Admin API shutdown complete")


def create_app() -> FastAPI:
    """
    Create and configure the FastAPI application.

    Returns:
        Configured FastAPI instance with all routes registered.
    """
    app = FastAPI(
        title="Ingestion Pipeline Admin API",
        description=(
            "Admin API for managing master data (departments, persons, "
            "inspections) used by the document ingestion pipeline."
        ),
        version="1.0.0",
        lifespan=lifespan,
    )

    # CORS middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Register routes
    app.include_router(departments.router)
    app.include_router(persons.router)
    app.include_router(inspections.router)

    # Health check
    @app.get("/health", tags=["Health"])
    def health_check():
        """Basic health check endpoint."""
        return {"status": "healthy", "service": "ingestion-admin-api"}

    return app
