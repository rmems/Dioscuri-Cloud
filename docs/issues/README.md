# Issue override source (2026-08-19)

Canonical bodies for the **cloud AI model training setup** rewrite of open GitHub issues
`#47`, `#50`, `#52`, `#53`, `#54`, `#57`, `#59`, `#60`, `#61`, `#62`.

Linear mirrors (`RM-72` … `RM-82`) are updated from the same content. If GitHub issue
bodies are stale, apply from this directory with a personal `gh` token (the Cloud Agent
integration token cannot edit issues on `rmems/Dioscuri-Cloud`).

```bash
# From repo root, with gh authenticated as rmems (not the cursor app):
for n in 47 50 52 53 54 57 59 60 61 62; do
  gh issue edit "$n" --repo rmems/Dioscuri-Cloud \
    --title "$(head -1 "docs/issues/gh-${n}.md" | sed 's/^# //')" \
    --body-file "docs/issues/gh-${n}.md"
done
```

Each `gh-*.md` file is the full issue body (title is the first line after `#`).
