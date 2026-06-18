"""
Plaintext file processing utilities.

Reads plaintext files with UTF-8 encoding, falling back to cp1252/latin1
if necessary, to prepare text for splitting and embedding.
"""

import os
import logging

logger = logging.getLogger(__name__)


def parse_txt_to_string(file_path: str) -> str:
    """
    Read plaintext file content with encoding fallback.

    Args:
        file_path: Absolute path to the TXT file.

    Returns:
        The text content of the file.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Plaintext file not found: {file_path}")

    # Try standard encodings
    for encoding in ("utf-8", "cp1252", "latin1"):
        try:
            with open(file_path, "r", encoding=encoding) as f:
                content = f.read()
                logger.info(
                    "Successfully read TXT file: %s (encoding=%s)",
                    os.path.basename(file_path),
                    encoding,
                )
                return content
        except UnicodeDecodeError:
            continue

    # Final fallback: read with errors replaced
    with open(file_path, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()
        logger.warning(
            "Read TXT file with errors replaced: %s", os.path.basename(file_path)
        )
        return content
