# Design Decisions

This document records the **key design decisions** behind the Docker + NVIDIA GPU
setup in this repository.

The intent is to make trade-offs explicit and to explain *why* certain approaches
were chosen over alternatives.

---

## 1. Separate Host Configuration From Container Workflows

**Context**  
GPU-accelerated containers depend on a correctly configured host system
(drivers, kernel modules, power management).

**Decision**  
Keep host-level setup (CPU, GPU drivers, CUDA validation) in a **separate repository**
and limit this repository to **containerized GPU workflows only**.

**Rationale**
- Clear separation of concerns
- Easier debugging (host vs container)
- Cleaner mental model for readers
- Avoids conflating OS tuning with container runtime issues

**Trade-off**
- Requires users to reference two repositories instead of one

---

## 2. Use Docker Engine Instead of Alternative Runtimes

**Context**  
Multiple container runtimes support GPU workloads (Docker, Podman, containerd).

**Decision**  
Use **Docker Engine** as the primary runtime.

**Rationale**
- Widest industry adoption
- Best-documented NVIDIA GPU support
- Lowest friction for reproduction
- Compatible with NVIDIA Container Toolkit defaults

**Trade-off**
- Docker daemon requires elevated privileges
- Less flexible than rootless/container-native alternatives

---

## 3. Use NVIDIA Container Toolkit Instead of Manual GPU Mapping

**Context**  
GPU access can be enabled via manual device mounts or via NVIDIA’s runtime.

**Decision**  
Use **NVIDIA Container Toolkit (`nvidia-ctk`)** to configure GPU passthrough.

**Rationale**
- Officially supported by NVIDIA
- Automatically handles driver/library compatibility
- Reduces risk of fragile, version-dependent setups
- Simplifies multi-GPU and future expansion

**Trade-off**
- Adds an external dependency
- Requires host NVIDIA driver compatibility

---

## 4. Pin CUDA Base Image Versions Explicitly

**Context**  
CUDA container images evolve frequently, and breaking changes can be subtle.

**Decision**  
Use **explicitly versioned CUDA base images** (e.g. `nvidia/cuda:12.2.0-base-ubuntu22.04`).

**Rationale**
- Improves reproducibility
- Avoids accidental runtime upgrades
- Makes debugging easier when issues arise
- Aligns with production container practices

**Trade-off**
- Requires manual updates to adopt newer CUDA versions

---

## 5. Prefer Runtime CUDA Over Full Toolkit Inside Containers

**Context**  
CUDA containers can include either runtime-only or full development toolkits.

**Decision**  
Use **runtime-focused CUDA images** and install only what is required for PyTorch execution.

**Rationale**
- Smaller image size
- Faster builds
- Reduced attack and maintenance surface
- Sufficient for most ML workloads

**Trade-off**
- Not suitable for custom CUDA kernel development inside containers

---

## 6. Verification Before Benchmarking

**Context**  
Containers can appear correct while silently falling back to CPU execution.

**Decision**  
Prioritize **simple, explicit verification** before performance measurements.

**Rationale**
- Confirms GPU access unambiguously
- Reduces false confidence
- Keeps validation scripts understandable
- Encourages correctness-first workflows

**Trade-off**
- Does not provide peak performance metrics

---

## 7. Minimal, Readable Dockerfiles Over Highly Optimized Images

**Context**  
Dockerfiles can be aggressively optimized at the cost of readability.

**Decision**  
Favor **clarity and maintainability** over maximal image optimization.

**Rationale**
- Easier to audit and modify
- Lower cognitive overhead for readers
- Better suited for learning and debugging
- Aligns with documentation-focused goals of the repo

**Trade-off**
- Slightly larger image size
- Longer build time than heavily optimized images

---

## 8. Explicit GPU Flags Instead of Implicit Defaults

**Context**  
Docker can silently run containers without GPU access if flags are omitted.

**Decision**  
Require explicit use of `--gpus all` in run commands.

**Rationale**
- Makes GPU usage intentional
- Avoids silent CPU fallbacks
- Improves clarity for new users
- Encourages deliberate execution

**Trade-off**
- Slightly more verbose commands

---

## Closing Notes

These decisions prioritize:

- Correctness over cleverness
- Reproducibility over convenience
- Debuggability over maximal abstraction

The goal is a containerized GPU workflow that behaves **predictably**, can be
**reasoned about**, and serves as a reliable foundation for more complex systems.
