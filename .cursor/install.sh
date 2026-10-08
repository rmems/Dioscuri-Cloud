#!/usr/bin/env bash
# Cursor Cloud Agent install script for Dioscuri-Cloud (`install` in .cursor/environment.json).
#
# Cursor runs this from the repository root during every Build, on its default
# Ubuntu base image (CPU only: cloud agents have no GPU), then snapshots the disk.
# It must be idempotent. Shell exports don't survive into agent runs, so the tools
# it installs are exposed through /etc/profile.d and /usr/local/bin.
# See https://cursor.com/docs/cloud-agent/setup
#
# Installs only what this repo's CI and manifests need:
#   - apt: curl, ca-certificates, gnupg, unzip
#   - Terraform 1.10.5 (official zip, GPG and sha256-verified, /usr/local/bin)
#   - terraform init -backend=false -lockfile=readonly for the 5 roots with committed lock files
#
# It ends with a dependency fetch/prebuild, not a test run.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# Install apt packages that are not already present.
apt_install() {
  local missing=() pkg
  for pkg in "$@"; do
    if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
      missing+=("$pkg")
    fi
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    $SUDO apt-get -o Acquire::Retries=5 update -qq
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=5 install -y --no-install-recommends "${missing[@]}"
  fi
}

# --- System packages (secure downloads, signature verification, and zip extraction) ---
apt_install curl ca-certificates gnupg unzip

# --- Terraform 1.10.5 (terraform-validate.yml: hashicorp/setup-terraform terraform_version 1.10.5) ---
TF_VERSION="1.10.5"
if ! terraform version 2>/dev/null | head -n1 | grep -qx "Terraform v${TF_VERSION}"; then
  arch="$(dpkg --print-architecture)"
  umask 077
  tmp="$(mktemp -d)"
  chmod 700 "$tmp"
  trap 'rm -rf -- "$tmp"' EXIT
  base="https://releases.hashicorp.com/terraform/${TF_VERSION}"
  zip="terraform_${TF_VERSION}_linux_${arch}.zip"
  sums="terraform_${TF_VERSION}_SHA256SUMS"
  fingerprint="C874011F0AB405110D02105534365D9472D7468F"
  curl -fsSL --retry 3 -o "$tmp/$zip" "$base/$zip"
  curl -fsSL --retry 3 -o "$tmp/$sums" "$base/$sums"
  curl -fsSL --retry 3 -o "$tmp/$sums.sig" "$base/$sums.sig"
  curl -fsSL --retry 3 -o "$tmp/hashicorp.asc" "https://keybase.io/hashicorp/pgp_keys.asc"
  mkdir -m 700 "$tmp/gnupg"
  gpg --batch --homedir "$tmp/gnupg" --import "$tmp/hashicorp.asc"
  gpg --batch --homedir "$tmp/gnupg" --status-fd 1 \
    --verify "$tmp/$sums.sig" "$tmp/$sums" 2>/dev/null \
    | grep -Eq "^\[GNUPG:\] VALIDSIG .* ${fingerprint}$"
  (cd "$tmp" && grep " ${zip}\$" "$sums" | sha256sum -c -)
  unzip -o -q "$tmp/$zip" terraform -d "$tmp"
  $SUDO install -m 0755 "$tmp/terraform" /usr/local/bin/terraform
  rm -rf -- "$tmp"
  trap - EXIT
fi
terraform version

# --- Prefetch providers (no backend, no plan/apply) ---
# Only the roots with a committed .terraform.lock.hcl need providers; -lockfile=readonly
# keeps init from rewriting them. The other modules validate without provider plugins.
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"
for d in terraform/modules/training_execution terraform/modules/training_node \
  terraform/envs/aws-training terraform/envs/oracle-dev infra/terraform/environments/vultr-dev; do
  terraform -chdir="$d" init -backend=false -input=false -lockfile=readonly
done

echo "Cursor install for Dioscuri-Cloud finished."
