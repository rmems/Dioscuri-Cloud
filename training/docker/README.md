# Training image

CUDA training container for cloud AI training smokes (GitHub #61). Pinned
base: `nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04` (CUDA 12.4, cuDNN
runtime, Ubuntu 22.04). Torch is installed from the matching `cu124` wheel
index — bump both together when upgrading CUDA.

No dataset/checkpoint/weight files are baked into the image. Training code
and data are staged at runtime from the S3 bucket in
`terraform/envs/aws-training/` (see `docs/training/artifact-layout.md`).

## Build locally

```bash
cd training/docker
docker build -t dioscuri-cloud-training:local .
```

This does not require a GPU — `docker build` only compiles the image layers.
A GPU is only needed to *run* the container (`docker run --gpus all ...`) or
on the EC2/SageMaker instance that executes it.

## Smoke-test the image (no GPU required)

```bash
docker run --rm dioscuri-cloud-training:local --help
```

On a GPU host, the entrypoint runs `nvidia-smi` as a dry-run check before
executing your command. The image ships no training script — use these
commands, which work out of the box, to confirm the driver and torch CUDA
build:

```bash
docker run --rm --gpus all dioscuri-cloud-training:local nvidia-smi
docker run --rm --gpus all dioscuri-cloud-training:local \
  python3 -c "import torch; print(torch.__version__, torch.cuda.is_available())"
```

Real training code is not baked in. Mount it, `COPY` it in a downstream
image, or stage it from S3 at container start (see
`docs/training/artifact-layout.md`), then pass your script as the command:

```bash
docker run --rm --gpus all -v "$(pwd)":/workspace -w /workspace \
  dioscuri-cloud-training:local python3 your_train.py --steps 10
```

## Build and push to ECR

See `providers/aws/training-image-runbook.md` for the full tag/push flow
against the ECR repository provisioned by `terraform/modules/training_execution/`.
