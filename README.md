# Docker + NVIDIA GPU (CUDA / PyTorch) on Ubuntu

A reproducible, production-minded guide for running **GPU-accelerated containers**
on Ubuntu using **Docker + NVIDIA Container Toolkit**.

This repository focuses exclusively on **containerized GPU workflows** and assumes
a correctly configured host system.

> For host-level Ubuntu performance tuning and native CUDA / PyTorch validation, see:  
> 👉 https://github.com/vikram2327/ubuntu-performance-ml-setup

---

## ✨ What This Repository Covers

- Installing Docker Engine on Ubuntu
- Installing and configuring NVIDIA Container Toolkit
- Enabling GPU passthrough into Docker containers
- Verifying GPU access inside containers (`nvidia-smi`)
- Building and running a CUDA-enabled PyTorch container
- Minimal, explicit verification scripts for correctness

This guide prioritizes **correctness, reproducibility, and debuggability** over
maximum optimization.

---

## 🎯 Scope & Design Philosophy

- This repository **does not tune the host system**
- GPU access is treated as **explicit and verifiable**
- All steps are written to be:
  - Observable
  - Repeatable
  - Easy to debug

Design decisions and trade-offs are documented rather than hidden.

---

## 🚀 Quick Start

Clone the repository and run:

```bash
bash scripts/setup.sh
bash scripts/verify.sh
````

* `setup.sh` installs Docker and configures NVIDIA GPU support
* `verify.sh` validates GPU access inside containers and runs a PyTorch CUDA test

> ⚠️ If you add your user to the `docker` group, log out and log back in before running verification.

---

## 📁 Repository Structure

```text
docker-nvidia-gpu-ml/
├── README.md
├── scripts/
│   ├── setup.sh        # Install Docker + NVIDIA Container Toolkit
│   ├── verify.sh       # Validate GPU access inside containers
│   └── cleanup.sh      # Optional cleanup of test artifacts
├── docker/
│   ├── Dockerfile      # CUDA + PyTorch base image
│   └── run.sh          # Example GPU-enabled run command
├── examples/
│   ├── pytorch_gpu_test.py  # Minimal PyTorch CUDA verification
│   └── cuda_smoke_test.sh   # nvidia-smi smoke test
└── docs/
    ├── design-decisions.md  # Architectural and design choices
    └── troubleshooting.md  # Common failure modes and fixes
```

---

## 🧠 Why This Repository Exists

Running GPU workloads inside containers adds an additional abstraction layer.

In practice, failures often stem from:

* Missing runtime configuration
* Implicit assumptions about GPU availability
* Silent CPU fallbacks
* Driver / runtime mismatches

This repository exists to make those interactions **explicit, observable, and reproducible**.

---

## 🔍 Who This Is For

This guide may be useful if you:

* Use NVIDIA GPUs on Ubuntu
* Run ML or compute workloads inside Docker
* Want a reliable GPU container baseline
* Care about system correctness and debuggability
* Prefer explicit verification over implicit assumptions

---

## 👤 Author

**Vikram Pratap Singh**

* GitHub: [https://github.com/vikram2327](https://github.com/vikram2327)
* LinkedIn: [https://www.linkedin.com/in/vikrampratapsingh2](https://www.linkedin.com/in/vikrampratapsingh2)

---

## 📌 Notes

This repository is intentionally conservative:

* It uses officially supported NVIDIA tooling
* It avoids runtime hacks or undocumented flags
* It favors clarity over aggressive optimization

The goal is a containerized GPU workflow that behaves **predictably** and can be
**reasoned about** when things go wrong.
