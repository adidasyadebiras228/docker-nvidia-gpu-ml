#!/usr/bin/env bash
set -e

echo "Removing test image (optional)"
docker rmi -f pytorch-cuda-test 2>/dev/null || true

echo "Pruning unused Docker resources (safe)"
docker system prune -f

echo "Done ✅"