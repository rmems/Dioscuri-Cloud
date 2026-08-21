#!/usr/bin/env bash
# Apply training-setup issue overwrites to GitHub (requires personal gh auth with Issues write).
set -euo pipefail
REPO="rmems/Dioscuri-Cloud"
ROOT="$(cd "$(dirname "$0")/../docs/issues" && pwd)"
ISSUES=(47 50 52 53 54 57 59 60 61 62)

for n in "${ISSUES[@]}"; do
  file="${ROOT}/gh-${n}.md"
  if [[ ! -f "$file" ]]; then
    echo "missing body file: $file" >&2
    exit 1
  fi
done

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

for n in "${ISSUES[@]}"; do
  file="${ROOT}/gh-${n}.md"
  title="$(head -1 "$file" | sed 's/^# //')"
  body="${tmpdir}/gh-${n}.body.md"
  # Skip H1 title line, then drop leading blank lines (portable; no GNU sed -i).
  tail -n +2 "$file" | awk 'NF { p = 1 } p' > "$body"
  echo "Updating #${n}: ${title}"
  if ! gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$body" --add-label training; then
    echo "label add failed for #${n}; updating title and body only" >&2
    gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$body"
  fi
done
echo "Done. Verify: gh issue list --repo $REPO --state open"
