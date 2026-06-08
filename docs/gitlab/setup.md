# GitLab setup (secondary CI target)

GitHub remains **primary** (`origin`, PRs, GitHub Actions, HCP VCS). GitLab is for local-runner CI experiments only.

## Remotes

```bash
git remote -v
# origin  → github.com/rmems/Dioscuri-Cloud   (primary)
# gitlab  → gitlab.com/rmems/Dioscuri-Cloud   (secondary)
```

Push to GitLab only when testing CI:

```bash
git push origin main
git push gitlab main
```

## GitLab runner registration (fix for 422 errors)

When `gitlab-runner register` prompts interactively, use **only** the instance base URL:

| Prompt | Correct value | Wrong (causes 422) |
|--------|---------------|---------------------|
| GitLab instance URL | `https://gitlab.com/` | `https://gitlab.com/rmems/Dioscuri-Cloud` |
| GitLab instance URL | `https://gitlab.com/` | Registration page URL or `glrt-...` token |

**Non-interactive register** (new `glrt-` token workflow — tags/run-untagged are set in GitLab UI, not CLI):

```bash
gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --token "glrt-<FROM_GITLAB_UI>" \
  --executor "docker" \
  --docker-image "hashicorp/terraform:1.10.5" \
  --description "ShipOfTheseus-local-docker"
```

Registration page: `https://gitlab.com/rmems/Dioscuri-Cloud/-/runners/<id>/register`

**User-mode** (no sudo): config at `~/.gitlab-runner/config.toml`; start processing:

```bash
gitlab-runner run --config ~/.gitlab-runner/config.toml
```

**System-mode** (recommended): `sudo gitlab-runner register ...` and `sudo systemctl enable --now gitlab-runner`.

## Cursor: GitLab MCP (official OAuth)

Added to `~/.cursor/mcp.json`:

```json
"GitLab": {
  "type": "http",
  "url": "https://gitlab.com/api/v4/mcp"
}
```

Restart Cursor and complete OAuth in the browser. Keep the existing `github` MCP as primary.

## Cursor: GitLab Workflow extension + LSP

1. Extensions → install **GitLab Workflow** (`GitLab.gitlab-workflow`).
2. Command Palette → **GitLab: Authenticate** → `https://gitlab.com` (OAuth).
3. Because `origin` is GitHub, use **GitLab: Select Project** → `rmems/Dioscuri-Cloud`.

The Language Server (`gitlab-lsp`) is bundled with the extension; no separate install.

## CI policy

- **Merge gate:** GitHub Actions (`.github/workflows/terraform-validate.yml`)
- **GitLab CI:** `.gitlab-ci.yml` — local docker runner validation only
