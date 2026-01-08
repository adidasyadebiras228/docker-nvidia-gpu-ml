# Docker + NVIDIA GPU (CUDA / PyTorch) on Ubuntu

A reproducible guide and reference implementation for running **GPU-accelerated containers**
on Ubuntu using **Docker + NVIDIA Container Toolkit**.

This repository focuses on **containerized GPU workflows** (not host tuning).

> For host-level Ubuntu performance tuning and native CUDA/PyTorch validation, see:  
> https://github.com/vikram2327/ubuntu-performance-ml-setup

## What This Covers

- Install Docker Engine (Ubuntu)
- Install and configure NVIDIA Container Toolkit
- Validate GPU access inside containers (`nvidia-smi`)
- Build and run a PyTorch CUDA container
- Minimal verification scripts for correctness

## Quick Start

```bash
bash scripts/setup.sh
bash scripts/verify.sh
````

## Repository Structure

* `scripts/` — install/configure/verify
* `docker/` — Dockerfile + run commands
* `examples/` — CUDA + PyTorch GPU smoke tests
* `docs/` — design decisions + troubleshooting

## Author

Vikram Pratap Singh
GitHub: [https://github.com/vikram2327](https://github.com/vikram2327)
LinkedIn: [https://www.linkedin.com/in/vikrampratapsingh2](https://www.linkedin.com/in/vikrampratapsingh2)
