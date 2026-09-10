#!/usr/bin/env bash
set -euo pipefail

echo "== training image dry-run check =="
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi || echo "nvidia-smi present but failed (no GPU attached to this container run?)"
else
  echo "nvidia-smi not found in PATH — GPU driver not mounted into this container."
fi

if [ "${1:-}" = "--help" ] || [ "$#" -eq 0 ]; then
  cat <<'EOF'
Usage: docker run ... <training-entrypoint-args>

This image runs a GPU dry-run check (nvidia-smi) on start, then execs the
given command. It ships no training script. Confirm the GPU/torch stack
with commands that work out of the box:

  docker run --gpus all <image> nvidia-smi
  docker run --gpus all <image> python3 -c "import torch; print(torch.cuda.is_available())"

Mount, COPY, or S3-stage your training code later, then pass it as the
command. See providers/aws/training-image-runbook.md for build/push and
EC2/SageMaker usage.
EOF
  exit 0
fi

exec "$@"
