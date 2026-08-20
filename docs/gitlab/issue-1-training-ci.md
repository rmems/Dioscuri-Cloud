# GitLab issue #1 — proposed overwrite (2026-08-19)

Apply manually in GitLab UI or with `glab issue update 1` when authenticated.

**Override (2026-08-19):** Previous title: `GitLab secondary CI workflow (local runner + MCP + LSP)`. Scope rewritten for **cloud AI model training setup** CI.

## Title

`[TRAIN] CI path for training-image build and dry-run`

## Goal

GitLab secondary CI builds the CUDA **training image** (#61) and runs a **dry-run** (docker build + optional `nvidia-smi` on docker executor with GPU tags), without secrets in the repo.

## Scope

- Extend `.gitlab-ci.yml` with a `training-image` job: build `training/docker/` on runner `ShipOfTheseus-local-docker` when present.
- Document in `docs/gitlab/training-ci.md` how this complements GitHub Actions (primary).
- No MCP/LSP runner setup in this issue.

## Non-goals

- No full cloud training job in GitLab CI (execution stays AWS #53/#54).
- No agent-swarm or IDE MCP OAuth work.

## Acceptance criteria

- [ ] Training image Dockerfile builds in GitLab pipeline or documents blocker
- [ ] Job is optional/manual on `main` if GPU runner unavailable
- [ ] `docs/gitlab/setup.md` cross-links training CI doc

## Depends on

- GitHub #61 CUDA training image spec

## Audit comment (post when updating)

Previous title: `GitLab secondary CI workflow (local runner + MCP + LSP)`. Canonical body: `docs/gitlab/issue-1-training-ci.md`.
