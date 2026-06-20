"""
Word Document (.docx) processing utilities.

Extracts structured content from DOCX files:
  - Paragraphs with style info (heading levels)
  - Section boundaries with domain/section headings
  - Tables (for annex/advisory/DPSC data)

Supports two output modes:
  1. Flat text (legacy): parse_docx_to_string
  2. Structured sections: parse_inspection_docx
"""

import os
import re
import logging
import zipfile
import xml.etree.ElementTree as ET

logger = logging.getLogger(__name__)

NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}

# Domain / section heading patterns found in RBI inspection reports
SECTION_HEADING_PATTERN = re.compile(
    r'^(Section\s+\d+|Annex\s+\w+|Appendix)\b',
    re.IGNORECASE,
)
DOMAIN_HEADING_PATTERN = re.compile(
    r'^[A-Z][A-Za-z\s/]+(?:Security|Governance|Management|Controls|Operations|'
    r'Resilience|Scalability|Reconciliation|Audit|Awareness|Access|Configuration|'
    r'Infrastructure|Channel|Review|Backup)$',
)

ANNEX_MARKERS = re.compile(r'Annex\s+(I|II|III|IV|V)\b', re.IGNORECASE)


def parse_docx_to_string(file_path: str) -> str:
    """
    Legacy: extract flat text from a DOCX file.

    Args:
        file_path: Absolute path to the DOCX file.

    Returns:
        The extracted plain text content.
    """
    sections = parse_inspection_docx(file_path)
    return '\n'.join(s['text'] for s in sections)


def parse_inspection_docx(file_path: str) -> list[dict]:
    """
    Parse an inspection report DOCX into structured sections.

    Each section contains:
      - index:        section sequence number
      - heading:      section heading text (if any)
      - domain_name:  detected domain (e.g. 'Governance and Security Organisation')
      - domain_index: order of domains in the document
      - annex_type:   'Annex_I', 'Annex_II', etc. if applicable
      - text:         full section text
      - tables:       list of {headers, rows} dicts found in this section

    Returns:
        List of section dicts in document order.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"DOCX file not found: {file_path}")

    logger.info("Parsing inspection DOCX: %s", os.path.basename(file_path))

    try:
        paragraphs = _extract_paragraphs_with_styles(file_path)
        tables = _extract_tables(file_path)
    except Exception as e:
        logger.error("Error parsing DOCX %s: %s", os.path.basename(file_path), e)
        raise

    sections, current_heading = [], ""
    domain_idx, seen_domains = -1, set()
    annex_type = None

    for para in paragraphs:
        text = para['text']
        style = para.get('style', '')
        is_heading = style.startswith('Heading') or para.get('is_heading', False)

        if is_heading or _is_section_marker(text):
            if text:
                current_heading = text

                annex_match = ANNEX_MARKERS.search(text)
                if annex_match:
                    roman = annex_match.group(1)
                    annex_map = {'I': 'Annex_I', 'II': 'Annex_II',
                                 'III': 'Annex_III', 'IV': 'Annex_IV', 'V': 'Annex_V'}
                    annex_type = annex_map.get(roman, f'Annex_{roman}')

                domain_candidate = _detect_domain(text)
                if domain_candidate and domain_candidate not in seen_domains:
                    seen_domains.add(domain_candidate)
                    domain_idx += 1

        sections.append({
            'index': len(sections),
            'heading': current_heading,
            'domain_name': list(seen_domains)[-1] if seen_domains else None,
            'domain_index': domain_idx if seen_domains else None,
            'annex_type': annex_type,
            'text': text,
            'tables': [],
        })

    _assign_tables_to_sections(sections, tables)

    collapsed = _collapse_sections(sections)
    logger.info("Parsed %d sections from %s", len(collapsed), os.path.basename(file_path))
    return collapsed


def _extract_paragraphs_with_styles(file_path: str) -> list[dict]:
    """Extract paragraphs with their style information from a DOCX file."""
    paragraphs = []
    try:
        with zipfile.ZipFile(file_path) as docx:
            xml_content = docx.read('word/document.xml')
            root = ET.fromstring(xml_content)
            for p in root.findall('.//w:p', NS):
                texts = [t.text for t in p.findall('.//w:t', NS) if t.text]
                if not texts:
                    continue
                text = ''.join(texts).strip()
                if not text:
                    continue
                ppr = p.find('.//w:pPr', NS)
                style = ''
                if ppr is not None:
                    style_el = ppr.find('w:pStyle', NS)
                    if style_el is not None and style_el.get('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}val'):
                        style = style_el.get('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}val')
                paragraphs.append({
                    'text': text,
                    'style': style,
                    'is_heading': style.startswith('Heading') if style else False,
                })
    except Exception as e:
        logger.warning("Error extracting paragraphs with styles: %s", e)
    return paragraphs


def _extract_tables(file_path: str) -> list[dict]:
    """Extract tables from a DOCX file as structured dicts."""
    tables = []
    try:
        with zipfile.ZipFile(file_path) as docx:
            xml_content = docx.read('word/document.xml')
            root = ET.fromstring(xml_content)
            for tbl in root.findall('.//w:tbl', NS):
                rows = tbl.findall('.//w:tr', NS)
                table_data = []
                for tr in rows:
                    cells = [''.join(t.text or '' for t in tc.findall('.//w:t', NS))
                             for tc in tr.findall('.//w:tc', NS)]
                    table_data.append(cells)

                headers = table_data[0] if table_data else []
                data_rows = table_data[1:] if len(table_data) > 1 else []

                tables.append({
                    'headers': headers,
                    'rows': data_rows,
                    'text': '\n'.join(' | '.join(r) for r in table_data),
                })
    except Exception as e:
        logger.warning("Error extracting tables: %s", e)
    return tables


def _is_section_marker(text: str) -> bool:
    """Check if text looks like a section boundary marker."""
    if SECTION_HEADING_PATTERN.match(text):
        return True
    if re.match(r'^[A-Z][A-Za-z\s/]{3,50}$', text) and len(text.split()) >= 2:
        return True
    return False


def _detect_domain(text: str) -> str | None:
    """Extract a domain name from a section heading."""
    text_clean = text.strip().rstrip('.')
    if DOMAIN_HEADING_PATTERN.match(text_clean):
        return text_clean
    if len(text_clean) > 5 and ':' in text_clean:
        return text_clean.split(':')[0].strip()
    return None


def _assign_tables_to_sections(sections: list[dict], tables: list[dict]) -> None:
    """Assign each table to the nearest preceding section."""
    if not sections or not tables:
        return
    # Estimate section boundaries by paragraph index
    tables_per_section = max(1, len(tables) // max(1, len(sections)))
    ti = 0
    for i, sec in enumerate(sections):
        while ti < len(tables) and (ti < tables_per_section * (i + 1) or i == len(sections) - 1):
            sec['tables'].append(tables[ti])
            ti += 1
            if ti >= len(tables):
                break


def _collapse_sections(sections: list[dict]) -> list[dict]:
    """Merge consecutive paragraphs with the same heading into a single section."""
    if not sections:
        return []

    collapsed = [dict(sections[0])]
    for sec in sections[1:]:
        if sec['heading'] == collapsed[-1]['heading'] and not sec['heading']:
            collapsed[-1]['text'] += '\n' + sec['text']
            collapsed[-1]['tables'].extend(sec['tables'])
        else:
            collapsed.append(dict(sec))
    return collapsed
