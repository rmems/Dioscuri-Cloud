#!/usr/bin/env bash
set -euo pipefail

out_dir="${1:-}"
if [[ -z "$out_dir" ]]; then
  echo "usage: $0 <output-dir>" >&2
  exit 2
fi

mkdir -p "$out_dir"

run_date="$(date -u +%F)"
run_time_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat >"$out_dir/hello-dioscuri-cloud.txt" <<EOF
hello from dioscuri-cloud
time_utc=$run_time_utc
EOF

cat >"$out_dir/manifest.json" <<EOF
{
  "schema": "dioscuri-cloud.artifact-manifest.v1",
  "created_at_utc": "$run_time_utc",
  "files": [
    {
      "path": "hello-dioscuri-cloud.txt",
      "sha256": "$(sha256sum "$out_dir/hello-dioscuri-cloud.txt" | awk '{print $1}')"
    }
  ]
}
EOF

cat >"$out_dir/summary.json" <<EOF
{
  "schema": "dioscuri-cloud.smoke-test-summary.v1",
  "date_utc": "$run_date",
  "notes": "No-GPU object-storage artifact smoke test"
}
EOF

echo "Wrote artifacts to: $out_dir" >&2
