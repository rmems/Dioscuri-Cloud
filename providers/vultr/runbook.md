# Vultr Runbook

## Purpose
Opportunistic GPU smoke testing only.

## Constraint
GPU availability may be low/uncertain; treat this provider as optional.

## Usage guidance
- Only run when capacity exists and cost estimate is documented.
- Keep runtime short and scope limited to smoke validation.

## Teardown checklist
- Terminate GPU/instance resources promptly.
- Delete unattached volumes and temporary networking artifacts.
- Confirm no active billable resources remain.

## Cost notes
- Use Vultr credits conservatively due to uncertain scheduling value.
