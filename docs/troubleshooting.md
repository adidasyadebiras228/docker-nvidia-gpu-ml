# Troubleshooting

This document lists **common failure modes** encountered when running GPU-accelerated
containers with Docker and NVIDIA Container Toolkit, along with practical fixes.

The focus is on **diagnosis first**, then resolution.

---

## 1. `docker: permission denied`

**Symptom**
```text
Got permission denied while trying to connect to the Docker daemon socket
````

**Cause**
The current user is not in the `docker` group.

**Fix**

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Or log out and log back in.

**Verification**

```bash
docker run --rm hello-world
```

---

## 2. `could not select device driver "" with capabilities: [[gpu]]`

**Symptom**

```text
docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]]
```

**Cause**
NVIDIA Container Toolkit is not installed or not configured for Docker.

**Fix**

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

**Verification**

```bash
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
```

---

## 3. `nvidia-smi` Works on Host but Not Inside Container

**Symptom**

* `nvidia-smi` works on host
* Fails or is missing inside container

**Cause**

* NVIDIA runtime not enabled
* Container started without `--gpus` flag

**Fix**
Always run containers with:

```bash
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
```

**Note**
GPU access is **never implicit** in Docker.

---

## 4. Container Falls Back to CPU Silently

**Symptom**

* PyTorch runs
* `torch.cuda.is_available()` returns `False`

**Cause**

* GPU not passed to container
* CUDA libraries unavailable inside image

**Fix**

* Ensure `--gpus all` is present
* Use a CUDA-enabled base image
* Verify with a minimal CUDA test

**Verification**

```bash
docker run --rm --gpus all pytorch-cuda-test python - << 'EOF'
import torch
print(torch.cuda.is_available())
EOF
```

---

## 5. Driver / CUDA Version Mismatch Concerns

**Symptom**
Uncertainty about CUDA version compatibility.

**Clarification**

* NVIDIA **driver version** determines maximum supported CUDA runtime
* CUDA containers include user-space libraries only

**Rule of Thumb**
If:

```bash
nvidia-smi
```

works on the host, CUDA containers built on compatible base images will work.

---

## 6. Secure Boot Enabled (NVIDIA Driver Not Loaded)

**Symptom**

```text
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver
```

**Cause**
Secure Boot prevents NVIDIA kernel module from loading.

**Fix Options**

* Disable Secure Boot in BIOS
  **or**
* Enroll NVIDIA module signing keys (advanced)

**Verification**

```bash
lsmod | grep nvidia
```

---

## 7. Docker Build Fails Due to Network or DNS Issues

**Symptom**

* `apt-get` or `pip install` fails during Docker build

**Cause**
Temporary network or DNS resolution issues.

**Fix**
Retry build:

```bash
docker build --no-cache -t pytorch-cuda-test -f docker/Dockerfile .
```

If persistent, check:

```bash
cat /etc/resolv.conf
```

---

## 8. Low GPU Memory Errors (Small GPUs)

**Symptom**
CUDA out-of-memory errors during container execution.

**Cause**
Limited VRAM (common on laptop GPUs).

**Fix**

* Reduce batch size or tensor dimensions
* Use smaller test workloads
* Avoid running multiple GPU containers simultaneously

---

## 9. Docker Uses GPU but Desktop Becomes Sluggish

**Symptom**
System UI becomes laggy during GPU workloads.

**Cause**
GPU shared between display server and compute workloads (Optimus).

**Mitigation**

* Prefer short-lived GPU workloads
* Avoid heavy GPU compute during interactive desktop use
* This is expected behavior on shared GPUs

---

## 10. When in Doubt: Reduce the Problem

**Debug Strategy**

1. Test `nvidia-smi` on host
2. Test `nvidia-smi` in a CUDA base container
3. Run a minimal PyTorch GPU script
4. Add complexity incrementally

Most issues become obvious when reduced to first principles.

---

## Closing Note

GPU container issues are rarely caused by Docker itself.

They usually result from:

* Missing runtime configuration
* Implicit assumptions about GPU availability
* Version mismatches hidden by abstraction layers

Treat GPU access as **explicit**, **verifiable**, and **intentional**.
