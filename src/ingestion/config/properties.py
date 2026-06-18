"""
Java-style .properties file parser.

Reads key=value pairs from .properties files, handling comments (#, !)
and blank lines. Values are stripped of leading/trailing whitespace.
"""

import os
import logging

logger = logging.getLogger(__name__)


def load_properties(file_path: str) -> dict[str, str]:
    """
    Parse a Java-style .properties file into a dictionary.

    Args:
        file_path: Absolute or relative path to the .properties file.

    Returns:
        Dictionary of key-value pairs from the file.

    Raises:
        FileNotFoundError: If the properties file does not exist.
    """
    if not os.path.isfile(file_path):
        raise FileNotFoundError(f"Properties file not found: {file_path}")

    properties: dict[str, str] = {}

    with open(file_path, "r", encoding="utf-8") as f:
        for line_num, raw_line in enumerate(f, start=1):
            line = raw_line.strip()

            # Skip blank lines and comments
            if not line or line.startswith("#") or line.startswith("!"):
                continue

            # Split on first '=' only
            if "=" not in line:
                logger.warning(
                    "Skipping malformed line %d in %s: no '=' delimiter found",
                    line_num,
                    file_path,
                )
                continue

            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip()

            if not key:
                logger.warning(
                    "Skipping line %d in %s: empty key", line_num, file_path
                )
                continue

            properties[key] = value

    logger.info(
        "Loaded %d properties from %s", len(properties), file_path
    )
    return properties
