"""
Aphrodite LLM client — OpenAI-compatible chat completions via Aphrodite API.

Provides methods for:
  - Generic chat completion calls
  - Image-to-Markdown conversion (multimodal, NuMarkdown)
  - Structured metadata extraction from document text
"""

import json
import re
import logging
import time
import random

import httpx

from ingestion.config.settings import AphroditeSettings

logger = logging.getLogger(__name__)


class AphroditeClient:
    """
    Client for the Aphrodite OpenAI-compatible API.

    All LLM interactions go through /v1/chat/completions.
    Model names, temperatures, and token limits are loaded from configuration.
    """

    def __init__(self, settings: AphroditeSettings, timeout: int = 180,
                 connect_timeout: int = 10):
        self._settings = settings
        self._base_url = settings.base_url.rstrip("/")

        headers = {"Content-Type": "application/json"}
        if settings.api_key:
            headers["Authorization"] = f"Bearer {settings.api_key}"

        self._client = httpx.Client(
            timeout=httpx.Timeout(float(timeout), connect=float(connect_timeout)),
            headers=headers,
        )

    # -----------------------------------------------------------------------
    # Generic chat completion
    # -----------------------------------------------------------------------

    def chat_completion(
        self,
        messages: list[dict],
        model: str,
        max_tokens: int = 4096,
        temperature: float = 0.1,
    ) -> str:
        """
        Send a chat completion request to Aphrodite with retry logic.

        Args:
            messages: List of message dicts with 'role' and 'content'.
            model: Model identifier to use.
            max_tokens: Maximum tokens in the response.
            temperature: Sampling temperature.

        Returns:
            The assistant's response text.

        Raises:
            httpx.HTTPStatusError: On non-2xx responses.
            ValueError: If the response format is unexpected.
        """
        payload = {
            "model": model,
            "messages": messages,
            "max_tokens": max_tokens,
            "temperature": temperature,
        }

        url = f"{self._base_url}/chat/completions"
        logger.debug("Aphrodite request — model=%s, url=%s", model, url)

        max_retries = 5
        base_delay = 2.0  # seconds
        
        for attempt in range(max_retries):
            try:
                response = self._client.post(url, json=payload)
                response.raise_for_status()
                break  # Success! Break the retry loop
            except httpx.HTTPStatusError as e:
                # If we get a rate limit (429) or temporary server error (5xx), retry
                is_transient = e.response.status_code == 429 or (500 <= e.response.status_code < 600)
                if is_transient and attempt < max_retries - 1:
                    delay = base_delay * (2 ** attempt) + random.uniform(0.1, 1.0)
                    logger.warning(
                        "Aphrodite request failed with status %d (attempt %d/%d). Retrying in %.2fs...",
                        e.response.status_code,
                        attempt + 1,
                        max_retries,
                        delay
                    )
                    time.sleep(delay)
                    continue
                else:
                    raise
            except (httpx.ConnectError, httpx.TimeoutException) as e:
                if attempt < max_retries - 1:
                    delay = base_delay * (2 ** attempt) + random.uniform(0.1, 1.0)
                    logger.warning(
                        "Aphrodite connection error (attempt %d/%d). Retrying in %.2fs...",
                        attempt + 1,
                        max_retries,
                        delay
                    )
                    time.sleep(delay)
                    continue
                else:
                    raise

        data = response.json()
        choices = data.get("choices", [])
        if not choices:
            raise ValueError("Aphrodite returned empty choices array")

        content = choices[0].get("message", {}).get("content", "")
        return content

    # -----------------------------------------------------------------------
    # Image-to-Markdown (NuMarkdown VLM)
    # -----------------------------------------------------------------------

    def convert_image_to_markdown(self, base64_image: str) -> str:
        """
        Convert a document page image to Markdown using NuMarkdown.

        Sends the image as a base64 data URI in a multimodal chat message.
        Strips <think>...</think> reasoning tags from the response.

        Args:
            base64_image: Base64-encoded PNG image string.

        Returns:
            Cleaned Markdown text of the document page.
        """
        cfg = self._settings.numarkdown

        messages = [
            {
                "role": "user",
                "content": [
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/png;base64,{base64_image}"
                        },
                    },
                    {
                        "type": "text",
                        "text": (
                            "Convert this document layout into standardized "
                            "GitHub-Flavored Markdown text transparently."
                        ),
                    },
                ],
            }
        ]

        raw_output = self.chat_completion(
            messages=messages,
            model=cfg.model,
            max_tokens=cfg.max_tokens,
            temperature=cfg.temperature,
        )

        # Strip <think>...</think> reasoning blocks
        cleaned = re.sub(r"<think>.*?</think>", "", raw_output, flags=re.DOTALL)
        return cleaned.strip()

    # -----------------------------------------------------------------------
    # Metadata Extraction
    # -----------------------------------------------------------------------

    def extract_metadata(self, first_page_markdown: str) -> dict:
        """
        Extract structured metadata from the first page of a document.

        Sends the first page markdown to the LLM with a structured extraction
        prompt. Expects a JSON response with entity_name and evaluation_year.

        Args:
            first_page_markdown: Markdown content of the document's first page.

        Returns:
            Dictionary with extracted metadata fields:
                - entity_name (str)
                - evaluation_year (int)
        """
        cfg = self._settings.metadata

        prompt = (
            "You are a metadata extraction assistant. Analyze the following "
            "document page and extract the metadata fields listed below.\n\n"
            "Return ONLY a valid JSON object with these fields:\n"
            '- "entity_name": The name of the entity, organization, or bank '
            "being evaluated/inspected.\n"
            '- "evaluation_year": The year of the evaluation/inspection as an integer.\n\n'
            "If a field cannot be determined, use null.\n\n"
            "Document content:\n"
            "---\n"
            f"{first_page_markdown}\n"
            "---\n\n"
            "JSON output:"
        )

        messages = [{"role": "user", "content": prompt}]

        raw_output = self.chat_completion(
            messages=messages,
            model=cfg.model,
            max_tokens=cfg.max_tokens,
            temperature=cfg.temperature,
        )

        # Strip thinking tags and extract JSON
        cleaned = re.sub(r"<think>.*?</think>", "", raw_output, flags=re.DOTALL)
        cleaned = cleaned.strip()

        # Try to extract JSON from code fences if present
        json_match = re.search(r"```(?:json)?\s*(.*?)```", cleaned, re.DOTALL)
        if json_match:
            cleaned = json_match.group(1).strip()

        try:
            metadata = json.loads(cleaned)
        except json.JSONDecodeError:
            logger.error("Failed to parse metadata JSON: %s", cleaned)
            metadata = {"entity_name": None, "evaluation_year": None}

        logger.info("Extracted metadata: %s", metadata)
        return metadata

    # -----------------------------------------------------------------------
    # Lifecycle
    # -----------------------------------------------------------------------

    def close(self) -> None:
        """Close the underlying HTTP client."""
        self._client.close()
        logger.debug("Aphrodite client closed")
