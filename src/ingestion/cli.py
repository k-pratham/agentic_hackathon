"""
CLI entry point — command-line interface for the ingestion pipeline.

Commands:
  ingest  — Run the document ingestion pipeline on a directory
  serve   — Start the FastAPI admin API server

Usage:
  python -m ingestion.cli ingest --input /data/INS-2025-001/
  python -m ingestion.cli ingest --input /data/
  python -m ingestion.cli serve
"""

import argparse
import sys
import logging

from ingestion.config.settings import get_settings
from ingestion.utils.logging import setup_logging_from_settings

logger = logging.getLogger(__name__)


def _cmd_ingest(args: argparse.Namespace) -> None:
    """Execute the ingestion pipeline on the specified input directory."""
    from ingestion.pipeline.orchestrator import IngestionOrchestrator

    settings = get_settings()
    setup_logging_from_settings(settings)

    logger.info("=" * 60)
    logger.info("INGESTION PIPELINE — Environment: %s", settings.env)
    logger.info("Input path: %s", args.input)
    logger.info("=" * 60)

    orchestrator = IngestionOrchestrator(settings)

    try:
        orchestrator.initialize()
        summary = orchestrator.process_directory(args.input)

        logger.info("=" * 60)
        logger.info("PIPELINE COMPLETE")
        logger.info("  Total files:   %d", summary["total"])
        logger.info("  Succeeded:     %d", summary["success"])
        logger.info("  Failed:        %d", summary["failed"])
        logger.info("  Skipped:       %d", summary["skipped"])
        logger.info("=" * 60)

        if summary["failed"] > 0:
            sys.exit(1)

    except Exception:
        logger.critical("Pipeline failed with fatal error", exc_info=True)
        sys.exit(2)
    finally:
        orchestrator.close()


def _cmd_serve(args: argparse.Namespace) -> None:
    """Start the FastAPI admin API server."""
    import uvicorn
    from ingestion.api.app import create_app

    settings = get_settings()
    setup_logging_from_settings(settings)

    logger.info("Starting Admin API server...")

    app = create_app()

    uvicorn.run(
        app,
        host=settings.api.host,
        port=settings.api.port,
        log_level=settings.logging.level.lower(),
    )


def main() -> None:
    """Parse CLI arguments and dispatch to the appropriate command."""
    parser = argparse.ArgumentParser(
        prog="ingestion",
        description="Secure Section-Wise Document Ingestion Pipeline",
    )
    subparsers = parser.add_subparsers(
        dest="command",
        required=True,
        help="Available commands",
    )

    # --- ingest command ---
    ingest_parser = subparsers.add_parser(
        "ingest",
        help="Run the document ingestion pipeline",
    )
    ingest_parser.add_argument(
        "--input",
        required=True,
        help=(
            "Path to an inspection folder (e.g., /data/INS-2025-001/) "
            "or a parent directory containing multiple inspection folders."
        ),
    )
    ingest_parser.set_defaults(func=_cmd_ingest)

    # --- serve command ---
    serve_parser = subparsers.add_parser(
        "serve",
        help="Start the FastAPI admin API server",
    )
    serve_parser.set_defaults(func=_cmd_serve)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
