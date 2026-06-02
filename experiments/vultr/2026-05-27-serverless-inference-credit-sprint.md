# Vultr Serverless Inference Credit Sprint

Start time UTC: `2026-05-27T00:00:00Z`

End time UTC: `2026-05-27T23:59:59Z`

Provider: `vultr`

GitHub issue: `rmems/Dioscuri-Cloud#44`

## Summary

The Vultr credit window was closed through a serverless inference sprint after earlier Cloud GPU capacity and authenticated account checks were not sufficient to approve planned GPU execution.

## Billing Closeout

| Field | Value |
|---|---:|
| Promo credit | `$250.00` |
| Account credit date | `2026-04-27` |
| Charges this month | `$237.31` |
| Account balance | `-$237.31` |
| Amount owed | `$0.00` |
| Estimated balance | `$0.00` |
| Expired promo credit | `$12.69` on `2026-05-28` |
| Token usage | `1,604,112+` tokens |

## Invoice Evidence

Public-safe invoice fields from the final Vultr serverless inference credit statement:

| Field | Value |
|---|---:|
| Invoice date | `2026-06-01` |
| Service start | `2026-05-23 20:15` |
| Service end | `2026-06-01 00:00` |
| Line item | `Vultr Serverless Inference usage (Coding Agent) (blended rate/1M tokens)` |
| Billed quantity | `554` |
| Subtotal | `$237.31` |
| Free credits applied | `$237.31` |
| Taxable amount | `$0.00` |
| Sales tax | `$0.00` |
| Total | `$237.31` |
| Credits and payments | `$237.31` |
| Total less credits and payments | `$0.00` |

The invoice number, account email, and line-item identifier are intentionally omitted from this repo because they are private billing/account identifiers.

## Console Snapshot Evidence

Public-safe facts visible in the Vultr serverless inference console snapshot:

| Field | Value |
|---|---:|
| API status | `OK` |
| Token usage | `1,604,112` |
| Current charges | `$237.29` |
| Label | `Coding Agent` |

The snapshot is consistent with the final invoice closeout and should be treated as a point-in-time dashboard view, not a private credential source. The visible API key, account email, and subscription/manage identifier are intentionally omitted from this repo.

Interpretation: `$237.31` of the `$250.00` promo credit was consumed by serverless inference usage. `$12.69` expired or was forfeited as promo credit. No amount was owed after credit application.

## Execution Pivot

Earlier Vultr work recorded API/auth blockers and GPU availability uncertainty. The sprint therefore pivoted from planned Cloud GPU execution to Vultr serverless inference, which avoided unmanaged compute lifecycle risk while still producing useful model/API evaluation data before the credit deadline.

## OpenAI-Compatible API Notes

| Item | Public-Safe Note |
|---|---|
| Base URL | Vultr serverless inference exposes an OpenAI-compatible API base URL. Record the exact value in local secret/config notes, not in this repo if it reveals private account context. |
| Model ID pattern | Use provider-published serverless model IDs exactly as returned by the API or console. |
| API key handling | No Vultr API key is uploaded, configured, or committed for this repo update. Future Vultr API material should remain out of repo and should only be used if a future issue explicitly reactivates Vultr. |
| Kilo/Cline/OpenCode/RooCode compatibility | Tools that support OpenAI-compatible base URLs can be pointed at Vultr serverless inference with the provider base URL, model ID, and local key. |

## Prompt And Evaluation Categories

- Rust code review.
- CUDA/kernel reasoning.
- SAAQ reasoning.
- MoE/quantization planning.
- Synthetic data generation.
- Agent/tool-calling tests.

## Resource Closeout

No active Vultr compute resource is recorded as created by this repo for the serverless sprint. Serverless inference usage was reconciled through the billing closeout values above. Vultr is considered inactive for near-term execution, and this repo update does not upload/configure Vultr API access.

Authenticated Vultr resource audit status: `not performed in this PR`. The repo should not upload or configure Vultr API material to complete a post-credit audit unless a future issue explicitly reactivates Vultr. This report therefore records the public-safe billing closeout and the absence of repo-managed compute resources, but does not claim account-wide proof that no pre-existing Vultr resources exist.

API/HCP cleanup status: `no Vultr API key or HCP Vultr variable was uploaded or configured by this PR`. Any pre-existing local/provider-side keys should be revoked or rotated outside the repo.

## Lessons Learned

- Serverless inference can be a practical fallback when GPU capacity or account gates block direct GPU execution.
- Credit-expiration windows need a bounded queue and a fallback plan before the final week.
- Public-safe closeout records should separate billing totals from private account identifiers and screenshots.
- Vultr should remain closeout-only unless a future issue explicitly reactivates the provider with fresh approval, cost caps, and secret-handling rules.

## Downstream References

- Cost ledger: `cost-ledger.md`
- Vultr closeout runbook: `providers/vultr/credit-closeout.md`
- Cloud credit strategy: `docs/cloud-credit-strategy.md`
