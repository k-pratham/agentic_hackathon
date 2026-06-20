"""
Section-wise document splitter — splits Markdown into structural units.

Uses regex patterns to identify section boundaries (headings, numbered sections)
and splits the document accordingly. Cleans page number artifacts.
"""

import re
import logging

logger = logging.getLogger(__name__)

# Pattern to match page number artifacts (e.g., "Page 3 of 15")
PAGE_NUMBER_PATTERN = re.compile(r"(?i)page\s+\d+\s+of\s+\d+")

# Pattern to split on section boundaries:
#   - Markdown headings (# through ######)
#   - Numbered sections with capitalized text (e.g., "1.2 Risk Assessment")
SECTION_SPLIT_PATTERN = re.compile(r"(?=\n(?:#{1,6}\s+|\d+\.\d+\s+[A-Z]))")


def split_into_sections(full_markdown: str) -> list[str]:
    """
    Split a full Markdown document into structural sections.

    Splits on heading patterns and numbered section markers. Removes
    page number artifacts and filters out empty chunks.

    Args:
        full_markdown: Complete Markdown text of the document.

    Returns:
        List of non-empty section strings.
    """
    # Clean page number artifacts
    cleaned = PAGE_NUMBER_PATTERN.sub("", full_markdown)

    # Split on section boundaries
    chunks = SECTION_SPLIT_PATTERN.split(cleaned)

    # Filter and strip
    sections = [chunk.strip() for chunk in chunks if chunk.strip()]

    logger.info(
        "Document split into %d sections (from %d chars)",
        len(sections),
        len(full_markdown),
    )

    for idx, section in enumerate(sections):
        # Log first line of each section for traceability
        first_line = section.split("\n", 1)[0][:80]
        logger.debug("Section %d: %s", idx, first_line)

    return sections
