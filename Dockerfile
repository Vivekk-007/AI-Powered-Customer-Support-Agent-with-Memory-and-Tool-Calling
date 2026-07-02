FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip uv

COPY pyproject.toml uv.lock ./

# Install CPU-only PyTorch
RUN pip install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cpu

RUN uv sync --frozen --no-dev

COPY . .

CMD ["uv", "run", "python", "main.py"]