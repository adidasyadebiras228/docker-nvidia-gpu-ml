#!/usr/bin/env bash
set -euo pipefail

echo "[1/6] Base dependencies"
sudo apt update
sudo apt install -y ca-certificates curl gnupg

echo "[2/6] Install Docker Engine (official repo)"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[3/6] Enable docker without sudo (optional but recommended)"
sudo usermod -aG docker "$USER" || true

echo "[4/6] Install NVIDIA Container Toolkit repo + package"
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

sudo apt update
sudo apt install -y nvidia-container-toolkit

echo "[5/6] Configure NVIDIA runtime for Docker"
sudo nvidia-ctk runtime configure --runtime=docker

echo "[6/6] Restart Docker"
sudo systemctl restart docker

echo "Setup complete."
echo "IMPORTANT: log out and log back in (or run: newgrp docker) if you want docker without sudo."