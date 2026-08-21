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
  tail -n +2 "$file" | sed '/^[[:space:]]*$/{N;s/^\n//;}' > "$body"
  # Drop a leading blank line left after stripping the H1 title.
  sed -i '/./,$!d' "$body"
  echo "Updating #${n}: ${title}"
  if ! gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$body" --add-label training; then
    echo "label add failed for #${n}; updating title and body only" >&2
    gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$body"
  fi
done
echo "Done. Verify: gh issue list --repo $REPO --state open"
