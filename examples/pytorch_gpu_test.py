import torch

print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())

if not torch.cuda.is_available():
    raise SystemExit("CUDA is not available inside the container")

print("GPU:", torch.cuda.get_device_name(0))

a = torch.randn(3000, 3000, device="cuda")
b = torch.randn(3000, 3000, device="cuda")
torch.matmul(a, b)

print("GPU computation successful ✅")
```

### `examples/cuda_smoke_test.sh`

```bash
#!/usr/bin/env bash
set -e
nvidia-smi
echo "CUDA container runtime OK ✅"