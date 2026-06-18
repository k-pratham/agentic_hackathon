"""
LLM-based metadata extraction — extracts document metadata from first page content.

Uses the Aphrodite client to send the first page's Markdown to the LLM
with a structured extraction prompt, expecting JSON with entity_name
and evaluation_year.
"""

import logging

from ingestion.clients.aphrodite import AphroditeClient

logger = logging.getLogger(__name__)


def extract_document_metadata(
    first_page_markdown: str, aphrodite_client: AphroditeClient
) -> dict:
    """
    Extract structured metadata from the first page of a document.

    Delegates to the Aphrodite client's metadata extraction method.

    Args:
        first_page_markdown: Markdown content of the document's first page.
        aphrodite_client: Configured Aphrodite client instance.

    Returns:
        Dictionary with extracted fields:
            - entity_name (str | None)
            - evaluation_year (int | None)
    """
    logger.info(
        "Extracting metadata from first page (%d chars)",
        len(first_page_markdown),
    )

    metadata = aphrodite_client.extract_metadata(first_page_markdown)

    # Validate and coerce types
    entity_name = metadata.get("entity_name")
    evaluation_year = metadata.get("evaluation_year")

    if evaluation_year is not None:
        try:
            evaluation_year = int(evaluation_year)
        except (ValueError, TypeError):
            logger.warning(
                "Invalid evaluation_year from LLM: %s", evaluation_year
            )
            evaluation_year = None

    result = {
        "entity_name": entity_name,
        "evaluation_year": evaluation_year,
    }

    logger.info("Metadata extraction result: %s", result)
    return result
