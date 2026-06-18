FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Create working directory
WORKDIR /app

# Install system dependencies (required for Oracle client if native connectivity is needed)
RUN apt-get update && apt-get install -y \
    build-essential \
    libaio1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and configuration
COPY src/ /app/src/
COPY config/ /app/config/

# Expose the API port
EXPOSE 8000

# Start the FastAPI server
CMD ["uvicorn", "src.agentic_backend.server:app", "--host", "0.0.0.0", "--port", "8000"]
