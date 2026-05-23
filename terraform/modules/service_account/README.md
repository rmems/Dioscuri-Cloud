# Module: service_account

Provider-agnostic interface for an IAM principal used by experiments and artifact workflows.

Implementation is intentionally deferred. This skeleton establishes a stable interface.

## Inputs
- `name` (string, required)
- `description` (string, optional)
- `labels` (map(string), optional)
- `roles` (list(string), optional)

## Outputs
- `name`

## TODO
- GCP: `google_service_account` + IAM bindings
- IBM: service ID + policy attachments
- AWS: IAM role + policy attachments
- Azure: AD application/service principal + role assignments
