#!/usr/bin/env bash
# Apply training-setup issue overwrites to GitHub (requires personal gh auth with Issues write).
# Cloud Agent integration tokens cannot edit issues on rmems/Dioscuri-Cloud.
set -euo pipefail
REPO="rmems/Dioscuri-Cloud"
ROOT="$(cd "$(dirname "$0")/../docs/issues" && pwd)"
for n in 47 50 52 53 54 57 59 60 61 62; do
  file="${ROOT}/gh-${n}.md"
  title="$(head -1 "$file" | sed 's/^# //')"
  echo "Updating #${n}: ${title}"
  gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$file" \
    --add-label training 2>/dev/null || gh issue edit "$n" --repo "$REPO" --title "$title" --body-file "$file"
done
echo "Done. Verify: gh issue list --repo $REPO --state open"
