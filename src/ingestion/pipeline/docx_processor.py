"""
Word Document (.docx) file processing utilities.

Extracts text content from DOCX files by parsing the internal OpenXML document structure.
Uses python's built-in zipfile and xml libraries for zero-dependency execution.
"""

import os
import logging
import zipfile
import xml.etree.ElementTree as ET

logger = logging.getLogger(__name__)


def parse_docx_to_string(file_path: str) -> str:
    """
    Read text content from a DOCX file.

    Args:
        file_path: Absolute path to the DOCX file.

    Returns:
        The extracted plain text content.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"DOCX file not found: {file_path}")

    logger.info("Parsing DOCX document: %s", os.path.basename(file_path))
    
    paragraphs = []
    # Namespaces for Word XML
    ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    
    try:
        with zipfile.ZipFile(file_path) as docx:
            xml_content = docx.read('word/document.xml')
            root = ET.fromstring(xml_content)
            # Find all paragraph elements <w:p>
            for p in root.findall('.//w:p', ns):
                # For each paragraph, find all text elements <w:t>
                texts = [t.text for t in p.findall('.//w:t', ns) if t.text]
                if texts:
                    paragraphs.append(''.join(texts))
        
        content = '\n'.join(paragraphs)
        logger.info(
            "Successfully parsed DOCX file: %s (%d paragraphs)",
            os.path.basename(file_path),
            len(paragraphs),
        )
        return content

    except Exception as e:
        logger.error("Error parsing DOCX file %s: %s", os.path.basename(file_path), str(e))
        raise
