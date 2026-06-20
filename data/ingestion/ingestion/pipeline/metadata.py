"""
LLM-based metadata extraction — extracts document metadata from first page content.

Uses the Aphrodite client to send the first page's Markdown to the LLM
with a structured extraction prompt, expecting JSON with entity_name,
evaluation_year, entity_type, and inspection_ref.
"""

import re
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
            - entity_type (str | None)
            - inspection_ref (str | None)
    """
    logger.info(
        "Extracting metadata from first page (%d chars)",
        len(first_page_markdown),
    )

    metadata = aphrodite_client.extract_metadata(first_page_markdown)

    # Validate and coerce types
    entity_name = metadata.get("entity_name")
    evaluation_year = metadata.get("evaluation_year")
    entity_type = metadata.get("entity_type")
    inspection_ref = metadata.get("inspection_ref")

    if evaluation_year is not None:
        try:
            evaluation_year = int(evaluation_year)
        except (ValueError, TypeError):
            logger.warning(
                "Invalid evaluation_year from LLM: %s", evaluation_year
            )
            evaluation_year = None

    # Fallback: regex extraction from first 500 chars if LLM returns None
    if not entity_name:
        entity_name = _regex_extract_entity_name(first_page_markdown)
    if not entity_type:
        entity_type = _regex_extract_entity_type(first_page_markdown)
    if not inspection_ref:
        inspection_ref = _regex_extract_inspection_ref(first_page_markdown)

    result = {
        "entity_name": entity_name,
        "evaluation_year": evaluation_year,
        "entity_type": entity_type,
        "inspection_ref": inspection_ref,
    }

    logger.info("Metadata extraction result: %s", result)
    return result


def _regex_extract_entity_name(text: str) -> str | None:
    """Fallback: extract entity name from known patterns in RBI reports."""
    patterns = [
        r'IT\s+Examination\s+of\s+(.+?)(?:\n|$)',
        r'Report\s+on\s+IT\s+Examination\s+(?:of\s+)?(.+?)(?:\n|$)',
        r'^\s*(.+?)(?:\s+Limited|\s+Bank\b)',
    ]
    for pat in patterns:
        m = re.search(pat, text, re.MULTILINE)
        if m:
            candidate = m.group(1).strip()
            if candidate and len(candidate) > 5:
                return candidate
    return None


def _regex_extract_entity_type(text: str) -> str | None:
    """Fallback: extract entity type from the document header."""
    patterns = [
        r'(Payments Bank[^,\n]*)',
        r'(Primary\s*\(\s*Urban\s*\)\s*Co-operative\s*Bank[^,\n]*)',
        r'(Co-operative\s+Bank[^,\n]*)',
        r'(Small\s+Finance\s+Bank[^,\n]*)',
    ]
    for pat in patterns:
        m = re.search(pat, text, re.IGNORECASE)
        if m:
            return m.group(1).strip()
    return None


def _regex_extract_inspection_ref(text: str) -> str | None:
    """Fallback: extract RBI inspection reference number."""
    pat = r'(DoS\.\S+/\d{4}-\d{2})'
    m = re.search(pat, text)
    if m:
        return m.group(1)
    return None
