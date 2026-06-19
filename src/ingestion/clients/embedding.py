"""
Embedding provider — configurable local ONNX or remote API embedding generation.

Supports:
  - Local: nomic-embed-text-v1.5 via ONNX Runtime (CPU-optimized)
  - Remote: Any OpenAI-compatible embedding API endpoint

The provider is selected at runtime based on the 'embedding.provider' config.
"""

import abc
import logging

import numpy as np
import httpx

from ingestion.config.settings import EmbeddingSettings

logger = logging.getLogger(__name__)


class EmbeddingProvider(abc.ABC):
    """Abstract base class for embedding generation."""

    @abc.abstractmethod
    def generate(self, text: str) -> list[float]:
        """
        Generate a normalized embedding vector for the given text.

        Args:
            text: Input text to embed.

        Returns:
            List of floats representing the embedding vector.
        """

    @abc.abstractmethod
    def close(self) -> None:
        """Release any resources held by the provider."""


class OnnxEmbeddingProvider(EmbeddingProvider):
    """
    Local embedding generation using ONNX Runtime.

    Loads the Nomic Embed model with Matryoshka truncation to the
    configured dimension. Uses CPU execution provider.
    """

    def __init__(self, settings: EmbeddingSettings):
        self._settings = settings
        self._tokenizer = None
        self._model = None
        self._initialized = False

    def _lazy_init(self) -> None:
        """Lazy-load the model and tokenizer on first use."""
        if self._initialized:
            return

        import os
        from transformers import AutoTokenizer
        from optimum.onnxruntime import ORTModelForFeatureExtraction

        model_id = self._settings.model_id
        logger.info("Loading ONNX embedding model: %s", model_id)

        self._tokenizer = AutoTokenizer.from_pretrained(
            model_id, trust_remote_code=True
        )

        # Determine the ONNX file name and subfolder to load
        file_name = "model.onnx"
        subfolder = "onnx"  # Default for HF repo
        
        if os.path.isdir(model_id):
            # Check local files
            root_onnx = os.path.join(model_id, "model.onnx")
            sub_onnx = os.path.join(model_id, "onnx", "model.onnx")
            
            if os.path.exists(root_onnx):
                file_name = "model.onnx"
                subfolder = None
                logger.info("Found local ONNX model at root: %s", root_onnx)
            elif os.path.exists(sub_onnx):
                file_name = "model.onnx"
                subfolder = "onnx"
                logger.info("Found local ONNX model in subfolder: %s", sub_onnx)
            else:
                # Neither exists, check for PyTorch/Safetensors to explain the issue
                has_pytorch = (
                    os.path.exists(os.path.join(model_id, "model.safetensors")) or
                    os.path.exists(os.path.join(model_id, "pytorch_model.bin"))
                )
                if has_pytorch:
                    raise FileNotFoundError(
                        f"The local model directory '{model_id}' contains PyTorch weights, "
                        "but does not contain an ONNX model file. Because nomic-bert-2048 is a custom "
                        "architecture, Hugging Face Optimum cannot export it on the fly. Please download the "
                        "pre-exported ONNX file (model.onnx or onnx/model.onnx) from Hugging Face and place it in the folder."
                    )
                else:
                    raise FileNotFoundError(
                        f"No ONNX model file found in the local model directory '{model_id}'."
                    )

        self._model = ORTModelForFeatureExtraction.from_pretrained(
            model_id,
            file_name=file_name,
            subfolder=subfolder,
            provider="CPUExecutionProvider",
            trust_remote_code=True,
        )
        self._initialized = True
        logger.info("ONNX embedding model loaded successfully")

    def generate(self, text: str) -> list[float]:
        """
        Generate a Matryoshka embedding using the local ONNX model.

        Prepends 'search_document: ' prefix as required by the Nomic model,
        truncates to the configured dimension, and L2-normalizes.
        """
        self._lazy_init()

        enriched_text = f"search_document: {text}"
        inputs = self._tokenizer(
            enriched_text,
            padding=True,
            truncation=True,
            max_length=self._settings.max_length,
            return_tensors="pt",
        )

        outputs = self._model(**inputs)
        raw_vectors = outputs.last_hidden_state.mean(dim=1).detach().numpy()[0]

        # Matryoshka truncation to target dimension
        truncated = raw_vectors[: self._settings.dimension]

        # L2 normalization
        norm = np.linalg.norm(truncated)
        if norm > 0:
            truncated = truncated / norm

        return truncated.tolist()

    def close(self) -> None:
        """Release model resources."""
        self._model = None
        self._tokenizer = None
        self._initialized = False
        logger.debug("ONNX embedding provider closed")


class ApiEmbeddingProvider(EmbeddingProvider):
    """
    Remote embedding generation via an OpenAI-compatible API.

    Calls the /v1/embeddings endpoint with the configured model.
    """

    def __init__(self, settings: EmbeddingSettings):
        self._settings = settings
        self._client = httpx.Client(timeout=httpx.Timeout(60.0))

        if not settings.api_url:
            raise ValueError(
                "embedding.api_url must be set when using 'api' provider"
            )
        if not settings.api_model:
            raise ValueError(
                "embedding.api_model must be set when using 'api' provider"
            )

    def generate(self, text: str) -> list[float]:
        """
        Generate an embedding via remote API call.

        Sends text to the /v1/embeddings endpoint and returns the
        embedding vector from the response.
        """
        url = f"{self._settings.api_url.rstrip('/')}/v1/embeddings"
        payload = {
            "model": self._settings.api_model,
            "input": f"search_document: {text}",
        }

        response = self._client.post(url, json=payload)
        response.raise_for_status()

        data = response.json()
        embedding = data["data"][0]["embedding"]

        # Truncate to configured dimension if needed
        embedding = embedding[: self._settings.dimension]

        # L2 normalize
        arr = np.array(embedding, dtype=np.float32)
        norm = np.linalg.norm(arr)
        if norm > 0:
            arr = arr / norm

        return arr.tolist()

    def close(self) -> None:
        """Close the HTTP client."""
        self._client.close()
        logger.debug("API embedding provider closed")


def create_embedding_provider(settings: EmbeddingSettings) -> EmbeddingProvider:
    """
    Factory function to create the appropriate embedding provider.

    Args:
        settings: Embedding configuration specifying the provider type.

    Returns:
        An initialized EmbeddingProvider instance.

    Raises:
        ValueError: If the provider type is not recognized.
    """
    provider_type = settings.provider.lower()

    if provider_type == "onnx":
        logger.info("Using ONNX local embedding provider")
        return OnnxEmbeddingProvider(settings)
    elif provider_type == "api":
        logger.info("Using API remote embedding provider")
        return ApiEmbeddingProvider(settings)
    else:
        raise ValueError(
            f"Unknown embedding provider: '{provider_type}'. "
            "Expected 'onnx' or 'api'."
        )
