FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl ffmpeg libsm6 libxext6 libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Copy files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY bunny.mp4 .

EXPOSE 5000

CMD ["python", "app.py"]
