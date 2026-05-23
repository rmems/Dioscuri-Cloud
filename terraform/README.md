# Terraform Layout

This repo uses Terraform to define reusable infrastructure primitives for cloud ML experiments.

Design principles:
- Keep modules provider-aware but provider-agnostic at the interface.
- Keep environments small and composable.
- Do not commit credentials, state files, or `.terraform/` directories.

## Directory structure

```text
terraform/
  modules/                   Reusable, provider-agnostic interfaces
    artifact_bucket/         Object storage bucket/container abstraction
    service_account/         IAM principal + minimal bindings abstraction

  envs/                      Environment stacks that compose modules
    ibm-dev/                 IBM Cloud dev scaffold (implementation deferred)
    gcp-artifacts/           GCP artifacts scaffold (implementation deferred)

  aws/                       Provider-specific notes (legacy placeholder)
  azure/                     Provider-specific notes (legacy placeholder)
  digitalocean/              Provider-specific notes (legacy placeholder)
```

## Modules vs envs

- `modules/*` define stable inputs/outputs. Implementations may be provider-specific internally, but the interface should remain consistent.
- `envs/*` are thin compositions for a single provider/account/project boundary. Each env should be safe to `plan`/`apply` independently.

## State

State backend configuration is intentionally deferred until HCP Terraform VCS integration is set up.
Until then:
- do not add local state files to git
- do not commit backend credentials

## Formatting

Terraform files should be kept `terraform fmt` clean.
