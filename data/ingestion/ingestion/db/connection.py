"""
Oracle Database connection pool manager.

Uses python-oracledb in thin mode (no Oracle Client installation required).
Provides a context manager for safely acquiring and releasing connections.
"""

import logging
from contextlib import contextmanager
from typing import Generator

import oracledb

from ingestion.config.settings import OracleSettings

logger = logging.getLogger(__name__)


class OracleConnectionPool:
    """
    Manages an Oracle connection pool using oracledb thin mode.

    Usage:
        pool = OracleConnectionPool(settings)
        pool.initialize()

        with pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1 FROM DUAL")

        pool.close()
    """

    def __init__(self, settings: OracleSettings):
        self._settings = settings
        self._pool: oracledb.ConnectionPool | None = None

    def initialize(self) -> None:
        """Create the connection pool. Must be called before using connections."""
        if self._pool is not None:
            logger.warning("Connection pool already initialized")
            return

        dsn = oracledb.makedsn(
            host=self._settings.host,
            port=self._settings.port,
            service_name=self._settings.service_name,
        )

        self._pool = oracledb.create_pool(
            user=self._settings.user,
            password=self._settings.password,
            dsn=dsn,
            min=self._settings.pool_min,
            max=self._settings.pool_max,
            increment=1,
        )

        logger.info(
            "Oracle connection pool initialized — host=%s, service=%s, "
            "pool_min=%d, pool_max=%d",
            self._settings.host,
            self._settings.service_name,
            self._settings.pool_min,
            self._settings.pool_max,
        )

    @contextmanager
    def connection(self) -> Generator[oracledb.Connection, None, None]:
        """
        Acquire a connection from the pool as a context manager.

        The connection is automatically returned to the pool when the
        context exits. Commits on success, rolls back on exception.
        """
        if self._pool is None:
            raise RuntimeError(
                "Connection pool not initialized. Call initialize() first."
            )

        conn = self._pool.acquire()
        try:
            yield conn
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            self._pool.release(conn)

    def close(self) -> None:
        """Close the connection pool and release all resources."""
        if self._pool is not None:
            self._pool.close(force=True)
            self._pool = None
            logger.info("Oracle connection pool closed")

    @property
    def is_initialized(self) -> bool:
        """Check if the connection pool has been initialized."""
        return self._pool is not None
