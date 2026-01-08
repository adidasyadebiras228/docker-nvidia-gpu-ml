#!/usr/bin/env bash
set -euo pipefail

echo "== Host checks =="
command -v docker >/dev/null && docker --version
command -v nvidia-smi >/dev/null && nvidia-smi || true

echo
echo "== Docker GPU check (nvidia-smi inside container) =="
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

echo
echo "== Build PyTorch CUDA image =="
docker build -t pytorch-cuda-test -f docker/Dockerfile .

echo
echo "== Run PyTorch GPU test =="
docker run --rm --gpus all pytorch-cuda-test python /workspace/examples/pytorch_gpu_test.py

echo
echo "All checks passed ✅"