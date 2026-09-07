# Pinned CUDA runtime base — bump deliberately and update
# providers/aws/training-image-runbook.md when you do. See
# docs/runbooks/gpu-smoke-test-readiness.md for the readiness gates a GPU
# run using this image must satisfy before any cloud spend.
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ARG PYTHON_VERSION=3.11

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION} \
        python3-pip \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Torch build must track the CUDA runtime above (cu124). Bump both together.
RUN python3 -m pip install --no-cache-dir \
        torch --index-url https://download.pytorch.org/whl/cu124 \
    && python3 -m pip install --no-cache-dir \
        boto3 \
        numpy

WORKDIR /opt/training
COPY entrypoint.sh /opt/training/entrypoint.sh
RUN chmod +x /opt/training/entrypoint.sh

# No dataset/checkpoint/weight files are baked into this image — training
# code and datasets are staged at runtime from S3 (docs/training/artifact-layout.md).

ENTRYPOINT ["/opt/training/entrypoint.sh"]
CMD ["--help"]
