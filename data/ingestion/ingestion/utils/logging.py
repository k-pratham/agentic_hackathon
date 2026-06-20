"""
Logging configuration — sets up Python logging with rotating file handlers.

Configures structured logging to both console and rotating .log files
based on settings from the application configuration.
"""

import os
import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path

_INITIALIZED = False

# Standard log format for all handlers
LOG_FORMAT = "%(asctime)s | %(levelname)-8s | %(name)s | %(message)s"
DATE_FORMAT = "%Y-%m-%d %H:%M:%S"


def setup_logging(
    log_dir: str = "logs",
    level: str = "INFO",
    max_bytes: int = 10_485_760,
    backup_count: int = 5,
) -> None:
    """
    Configure application-wide logging with console and file output.

    Creates the log directory if it does not exist. Sets up a
    RotatingFileHandler that rolls over at max_bytes.

    Args:
        log_dir: Directory path for log files.
        level: Logging level string (DEBUG, INFO, WARNING, ERROR, CRITICAL).
        max_bytes: Maximum bytes per log file before rotation.
        backup_count: Number of rotated backup files to keep.
    """
    global _INITIALIZED
    if _INITIALIZED:
        return

    # Resolve log directory relative to project root
    log_path = Path(log_dir)
    if not log_path.is_absolute():
        # Resolve relative to project root (3 levels up from this file)
        project_root = Path(__file__).resolve().parent.parent.parent.parent
        log_path = project_root / log_path

    os.makedirs(log_path, exist_ok=True)

    log_level = getattr(logging, level.upper(), logging.INFO)

    # Root logger configuration
    root_logger = logging.getLogger()
    root_logger.setLevel(log_level)

    # Clear any existing handlers to prevent duplicates
    root_logger.handlers.clear()

    formatter = logging.Formatter(LOG_FORMAT, datefmt=DATE_FORMAT)

    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(log_level)
    console_handler.setFormatter(formatter)
    root_logger.addHandler(console_handler)

    # Rotating file handler
    log_file = log_path / "ingestion.log"
    file_handler = RotatingFileHandler(
        filename=str(log_file),
        maxBytes=max_bytes,
        backupCount=backup_count,
        encoding="utf-8",
    )
    file_handler.setLevel(log_level)
    file_handler.setFormatter(formatter)
    root_logger.addHandler(file_handler)

    # Suppress noisy third-party loggers
    logging.getLogger("httpx").setLevel(logging.WARNING)
    logging.getLogger("httpcore").setLevel(logging.WARNING)
    logging.getLogger("urllib3").setLevel(logging.WARNING)

    _INITIALIZED = True
    logging.info("Logging initialized — level=%s, file=%s", level, log_file)


def setup_logging_from_settings(settings) -> None:
    """
    Configure logging using LoggingSettings from the app configuration.

    Args:
        settings: AppSettings instance with a .logging attribute.
    """
    log_cfg = settings.logging
    setup_logging(
        log_dir=log_cfg.dir,
        level=log_cfg.level,
        max_bytes=log_cfg.max_bytes,
        backup_count=log_cfg.backup_count,
    )
