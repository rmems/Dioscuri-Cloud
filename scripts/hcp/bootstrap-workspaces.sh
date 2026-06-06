#!/usr/bin/env bash
# Bootstrap HCP Terraform workspaces for Dioscuri-Cloud (Issue #46).
# Public-safe: never prints secret values. Credentials read from local config only.
set -euo pipefail

ORG="${HCP_ORG:-Dioscuri-Cloud}"
API_BASE="${TF_API_BASE:-https://app.terraform.io/api/v2}"
SYNC_OCI=false
SYNC_IBM=false
LINK_VCS=false

usage() {
  cat <<'EOF'
Usage: bootstrap-workspaces.sh [OPTIONS]

Create or align HCP workspaces for Issue #46:
  dioscuri-cloud-hcp-core, dioscuri-cloud-ibm-dev, dioscuri-cloud-oracle-dev

Options:
  --sync-oci-from-local   Mirror ~/.oci/config to oracle-dev env vars (sensitive)
  --sync-ibm-from-env     Mirror IBMCLOUD_* shell env vars to ibm-dev env vars
  --link-vcs              Attach GitHub repo if an OAuth token exists in the org
  -h, --help              Show this help

Requires terraform login token in TF_TOKEN_app_terraform_io or
~/.terraform.d/credentials.tfrc.json
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sync-oci-from-local) SYNC_OCI=true ;;
    --sync-ibm-from-env) SYNC_IBM=true ;;
    --link-vcs) LINK_VCS=true ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ -z "${TF_TOKEN_app_terraform_io:-}" ]]; then
  if [[ -f "${HOME}/.terraform.d/credentials.tfrc.json" ]]; then
    TF_TOKEN_app_terraform_io="$(
      jq -r '.credentials["app.terraform.io"].token // empty' \
        "${HOME}/.terraform.d/credentials.tfrc.json"
    )"
  fi
fi

if [[ -z "${TF_TOKEN_app_terraform_io:-}" ]]; then
  echo "ERROR: Set TF_TOKEN_app_terraform_io or run terraform login" >&2
  exit 1
fi

api() {
  local method="$1"
  local path="$2"
  local data="${3:-}"
  if [[ -n "$data" ]]; then
    curl -sS -X "$method" \
      -H "Authorization: Bearer ${TF_TOKEN_app_terraform_io}" \
      -H "Content-Type: application/vnd.api+json" \
      -d "$data" \
      "${API_BASE}${path}"
  else
    curl -sS -X "$method" \
      -H "Authorization: Bearer ${TF_TOKEN_app_terraform_io}" \
      -H "Content-Type: application/vnd.api+json" \
      "${API_BASE}${path}"
  fi
}

workspace_id() {
  local name="$1"
  api GET "/organizations/${ORG}/workspaces/${name}" | jq -r '.data.id // empty'
}

ensure_workspace() {
  local name="$1"
  local working_dir="$2"
  local id
  id="$(workspace_id "$name")"

  local payload
  payload="$(jq -n \
    --arg name "$name" \
    --arg wd "$working_dir" \
    '{
      data: {
        type: "workspaces",
        attributes: {
          name: $name,
          "working-directory": $wd,
          "execution-mode": "remote",
          "auto-apply": false,
          "speculative-enabled": true
        }
      }
    }')"

  if [[ -z "$id" ]]; then
    echo "Creating workspace: ${name} (working-directory=${working_dir})" >&2
    local resp
    resp="$(api POST "/organizations/${ORG}/workspaces" "$payload")"
    id="$(echo "$resp" | jq -r '.data.id // empty')"
    if [[ -z "$id" ]]; then
      echo "ERROR: failed to create workspace ${name}" >&2
      echo "$resp" | jq '.' >&2 || echo "$resp" >&2
      exit 1
    fi
  else
    echo "Patching workspace: ${name} (id=${id})" >&2
    local patch_payload
    patch_payload="$(jq -n \
      --arg wd "$working_dir" \
      '{
        data: {
          id: "'"${id}"'",
          type: "workspaces",
          attributes: {
            "working-directory": $wd,
            "execution-mode": "remote",
            "auto-apply": false,
            "speculative-enabled": true
          }
        }
      }')"
    api PATCH "/workspaces/${id}" "$patch_payload" >/dev/null
  fi

  echo "$id"
}

var_exists() {
  local ws_id="$1"
  local key="$2"
  api GET "/workspaces/${ws_id}/vars" | jq -e --arg k "$key" \
    '.data[] | select(.attributes.key == $k)' >/dev/null 2>&1
}

set_terraform_var() {
  local ws_id="$1"
  local key="$2"
  local value="$3"
  local sensitive="${4:-false}"

  if var_exists "$ws_id" "$key"; then
    echo "  var exists: ${key}" >&2
    return 0
  fi

  local payload
  payload="$(jq -n \
    --arg key "$key" \
    --arg value "$value" \
    --argjson sensitive "$sensitive" \
    '{
      data: {
        type: "vars",
        attributes: {
          key: $key,
          value: $value,
          category: "terraform",
          sensitive: $sensitive
        }
      }
    }')"

  api POST "/workspaces/${ws_id}/vars" "$payload" >/dev/null
  echo "  set terraform var: ${key}" >&2
}

set_env_var() {
  local ws_id="$1"
  local key="$2"
  local value="$3"
  local sensitive="${4:-false}"

  if var_exists "$ws_id" "$key"; then
    echo "  env var exists: ${key}" >&2
    return 0
  fi

  local payload
  payload="$(jq -n \
    --arg key "$key" \
    --arg value "$value" \
    --argjson sensitive "$sensitive" \
    '{
      data: {
        type: "vars",
        attributes: {
          key: $key,
          value: $value,
          category: "env",
          sensitive: $sensitive
        }
      }
    }')"

  api POST "/workspaces/${ws_id}/vars" "$payload" >/dev/null
  echo "  set env var: ${key} (sensitive=${sensitive})" >&2
}

sync_oci_vars() {
  local ws_id="$1"
  local config="${HOME}/.oci/config"

  if [[ ! -f "$config" ]]; then
    echo "WARN: ${config} not found; skipping OCI sync" >&2
    return 0
  fi

  local user tenancy fingerprint region key_file
  user="$(awk -F= '/^user=/{print $2}' "$config" | head -1 | tr -d ' ')"
  tenancy="$(awk -F= '/^tenancy=/{print $2}' "$config" | head -1 | tr -d ' ')"
  fingerprint="$(awk -F= '/^fingerprint=/{print $2}' "$config" | head -1 | tr -d ' ')"
  region="$(awk -F= '/^region=/{print $2}' "$config" | head -1 | tr -d ' ')"
  key_file="$(awk -F= '/^key_file=/{print $2}' "$config" | head -1 | tr -d ' ')"

  if [[ -z "$user" || -z "$tenancy" || -z "$fingerprint" || -z "$region" ]]; then
    echo "WARN: incomplete ~/.oci/config; skipping OCI sync" >&2
    return 0
  fi

  set_env_var "$ws_id" "OCI_USER_OCID" "$user" true
  set_env_var "$ws_id" "OCI_TENANCY_OCID" "$tenancy" true
  set_env_var "$ws_id" "OCI_FINGERPRINT" "$fingerprint" true
  set_env_var "$ws_id" "OCI_REGION" "$region" false

  if [[ -n "$key_file" && -f "$key_file" ]]; then
    local pem
    pem="$(cat "$key_file")"
    set_env_var "$ws_id" "OCI_PRIVATE_KEY" "$pem" true
  else
    echo "WARN: OCI key_file not found; OCI_PRIVATE_KEY not set" >&2
  fi

  if [[ -n "${OCI_COMPARTMENT_OCID:-}" ]]; then
    set_env_var "$ws_id" "OCI_COMPARTMENT_OCID" "${OCI_COMPARTMENT_OCID}" true
  else
    echo "WARN: OCI_COMPARTMENT_OCID not in shell env; set manually in HCP" >&2
  fi
}

sync_ibm_vars() {
  local ws_id="$1"

  if [[ -z "${IBMCLOUD_API_KEY:-}" ]]; then
    echo "WARN: IBMCLOUD_API_KEY not set; skipping IBM sync" >&2
    return 0
  fi

  set_env_var "$ws_id" "IBMCLOUD_API_KEY" "${IBMCLOUD_API_KEY}" true
  if [[ -n "${IBMCLOUD_REGION:-}" ]]; then
    set_env_var "$ws_id" "IBMCLOUD_REGION" "${IBMCLOUD_REGION}" false
  fi
  if [[ -n "${IBMCLOUD_RESOURCE_GROUP:-}" ]]; then
    set_env_var "$ws_id" "IBMCLOUD_RESOURCE_GROUP" "${IBMCLOUD_RESOURCE_GROUP}" false
  fi
}

link_vcs_repo() {
  local ws_id="$1"
  local oauth_token_id
  oauth_token_id="$(api GET "/organizations/${ORG}/oauth-tokens" | jq -r '.data[0].id // empty')"

  if [[ -z "$oauth_token_id" ]]; then
    echo "WARN: no OAuth tokens in org ${ORG}; install HashiCorp GitHub app first" >&2
    return 0
  fi

  local payload
  payload="$(jq -n \
    --arg id "$ws_id" \
    --arg oauth "$oauth_token_id" \
    '{
      data: {
        id: $id,
        type: "workspaces",
        attributes: {
          "vcs-repo": {
            identifier: "rmems/Dioscuri-Cloud",
            "oauth-token-id": $oauth,
            branch: "",
            "ingress-submodules": false
          }
        }
      }
    }')"

  api PATCH "/workspaces/${ws_id}" "$payload" >/dev/null
  echo "  linked VCS: rmems/Dioscuri-Cloud" >&2
}

echo "=== HCP bootstrap: org=${ORG} ===" >&2

HCP_CORE_ID="$(ensure_workspace "dioscuri-cloud-hcp-core" "infra/terraform/environments/dev")"
IBM_ID="$(ensure_workspace "dioscuri-cloud-ibm-dev" "terraform/envs/ibm-dev")"
ORACLE_ID="$(ensure_workspace "dioscuri-cloud-oracle-dev" "terraform/envs/oracle-dev")"

echo "=== Scaffold Terraform variables ===" >&2

echo "hcp-core (${HCP_CORE_ID}):" >&2
set_terraform_var "$HCP_CORE_ID" "project_name" "dioscuri-cloud"
set_terraform_var "$HCP_CORE_ID" "environment" "dev"
set_terraform_var "$HCP_CORE_ID" "owner" "raulmc"

echo "ibm-dev (${IBM_ID}):" >&2
set_terraform_var "$IBM_ID" "location" "us-south"
set_terraform_var "$IBM_ID" "artifact_bucket_name" "dioscuri-cloud-dev-artifacts"
set_terraform_var "$IBM_ID" "service_account_name" "dioscuri-artifact-reader"

echo "oracle-dev (${ORACLE_ID}):" >&2
set_terraform_var "$ORACLE_ID" "location" "us-phoenix-1"
set_terraform_var "$ORACLE_ID" "artifact_bucket_name" "dioscuri-cloud-dev-artifacts"
set_terraform_var "$ORACLE_ID" "service_account_name" "dioscuri-artifact-reader"

if $SYNC_OCI; then
  echo "=== Sync OCI env vars (oracle-dev) ===" >&2
  sync_oci_vars "$ORACLE_ID"
fi

if $SYNC_IBM; then
  echo "=== Sync IBM env vars (ibm-dev) ===" >&2
  sync_ibm_vars "$IBM_ID"
fi

if $LINK_VCS; then
  echo "=== Link VCS (if OAuth token available) ===" >&2
  link_vcs_repo "$HCP_CORE_ID"
  link_vcs_repo "$IBM_ID"
  link_vcs_repo "$ORACLE_ID"
fi

echo "=== Done ==="
echo "Workspaces:"
echo "  dioscuri-cloud-hcp-core: ${HCP_CORE_ID}"
echo "  dioscuri-cloud-ibm-dev: ${IBM_ID}"
echo "  dioscuri-cloud-oracle-dev: ${ORACLE_ID}"
