"""
PDF page renderer — converts PDF pages to base64-encoded PNG images using PyMuPDF.

Renders each page at a configurable DPI scale for high-fidelity
layout extraction by the NuMarkdown VLM.
"""

import base64
import logging

import fitz  # PyMuPDF

logger = logging.getLogger(__name__)


def extract_pages_as_base64(pdf_path: str, dpi_scale: float = 2.0) -> list[str]:
    """
    Render all pages of a PDF as high-resolution base64-encoded PNG images.

    Args:
        pdf_path: Path to the PDF file.
        dpi_scale: Scale factor for rendering (2.0 = 144 DPI, good for OCR/VLM).

    Returns:
        List of base64-encoded PNG strings, one per page.

    Raises:
        FileNotFoundError: If the PDF file does not exist.
        RuntimeError: If the PDF cannot be opened.
    """
    logger.info("Rendering PDF pages — file=%s, scale=%.1f", pdf_path, dpi_scale)

    doc = fitz.open(pdf_path)
    base64_images: list[str] = []

    try:
        total_pages = len(doc)
        matrix = fitz.Matrix(dpi_scale, dpi_scale)

        for page_num in range(total_pages):
            page = doc.load_page(page_num)
            pixmap = page.get_pixmap(matrix=matrix, alpha=False)
            png_bytes = pixmap.tobytes("png")
            b64_str = base64.b64encode(png_bytes).decode("utf-8")
            base64_images.append(b64_str)

            logger.debug(
                "Rendered page %d/%d — size=%dx%d",
                page_num + 1,
                total_pages,
                pixmap.width,
                pixmap.height,
            )

        logger.info(
            "PDF rendering complete — %d pages extracted from %s",
            total_pages,
            pdf_path,
        )
    finally:
        doc.close()

    return base64_images
