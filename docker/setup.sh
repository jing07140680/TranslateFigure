#!/bin/bash

set -e

# ===== CONFIGURATION =====
IMAGE_NAME="yolov8-streamer"
VIDEO_FILE="bunny.mp4"
REMOTE_PORT=5000
LOCAL_PORT=5000
REMOTE_USER="wyj"              # ← EDIT THIS
REMOTE_HOST="pc607.emulab.net"  # ← EDIT THIS

# ===== 1. Install Docker (if not present) =====
if ! command -v docker &> /dev/null; then
  echo "[INFO] Installing Docker..."
  sudo apt update
  sudo apt install -y ca-certificates curl gnupg lsb-release
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
  echo "[INFO] Docker installed. Please log out and back in to apply docker group permissions."
  exit 0
else
  echo "[INFO] Docker is already installed."
fi

# ===== 2. Build Docker Image =====
echo "[INFO] Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .

# ===== 3. Run Docker Container =====
echo "[INFO] Running container on port $REMOTE_PORT..."
docker run -d --name $IMAGE_NAME \
  -p $REMOTE_PORT:$REMOTE_PORT \
  -v $(pwd)/$VIDEO_FILE:/app/$VIDEO_FILE \
  $IMAGE_NAME

# ===== 4. Ask to Set Up SSH Port Forwarding =====
read -p "Do you want to SSH forward remote:$REMOTE_PORT to local:$LOCAL_PORT? (y/n): " FORWARD

if [[ "$FORWARD" == "y" ]]; then
  echo "[INFO] Starting SSH tunnel..."
  ssh -N -L ${LOCAL_PORT}:localhost:${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} &
  SSH_PID=$!
  echo "[SUCCESS] Tunnel established. Visit: http://localhost:$LOCAL_PORT"
  echo "To stop the tunnel: kill $SSH_PID"
else
  echo "[INFO] You can access the stream directly at: http://${REMOTE_HOST}:${REMOTE_PORT}/"
fi
