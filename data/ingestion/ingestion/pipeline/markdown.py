"""
NuMarkdown conversion — orchestrates parallel image-to-Markdown conversion.

Uses ThreadPoolExecutor to process multiple PDF pages concurrently
through the Aphrodite NuMarkdown VLM endpoint.
"""

import logging
from concurrent.futures import ThreadPoolExecutor, as_completed

from ingestion.clients.aphrodite import AphroditeClient

logger = logging.getLogger(__name__)


def convert_pages_to_markdown(
    base64_images: list[str],
    aphrodite_client: AphroditeClient,
    max_workers: int = 2,
) -> str:
    """
    Convert a list of page images to aggregated Markdown text.

    Processes pages in parallel using a thread pool. Results are
    assembled in page order regardless of completion order.

    Args:
        base64_images: List of base64-encoded PNG images (one per page).
        aphrodite_client: Configured Aphrodite client for NuMarkdown calls.
        max_workers: Maximum number of concurrent conversion threads.

    Returns:
        Aggregated Markdown string with all pages joined by double newlines.
    """
    total_pages = len(base64_images)
    logger.info(
        "Converting %d pages to Markdown (max_workers=%d)",
        total_pages,
        max_workers,
    )

    # Pre-allocate results list to maintain page order
    results: list[str | None] = [None] * total_pages

    def _convert_page(page_index: int, b64_image: str) -> tuple[int, str]:
        """Convert a single page and return (index, markdown)."""
        logger.debug("Converting page %d/%d", page_index + 1, total_pages)
        markdown = aphrodite_client.convert_image_to_markdown(b64_image)
        logger.debug(
            "Page %d converted — %d chars", page_index + 1, len(markdown)
        )
        return page_index, markdown

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(_convert_page, idx, img): idx
            for idx, img in enumerate(base64_images)
        }

        for future in as_completed(futures):
            page_idx = futures[future]
            try:
                idx, markdown = future.result()
                results[idx] = markdown
            except Exception as e:
                logger.error(
                    "Failed to convert page %d", page_idx + 1, exc_info=True
                )
                raise e

    # Aggregate pages with separator
    aggregated = "\n\n\n".join(page_md or "" for page_md in results)

    logger.info(
        "Markdown conversion complete — %d pages, %d total chars",
        total_pages,
        len(aggregated),
    )
    return aggregated
