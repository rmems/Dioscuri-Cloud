# Module: artifact_bucket

Provider-agnostic interface for an artifact storage bucket/container.

Implementation is intentionally deferred. This skeleton establishes stable inputs/outputs so that future provider implementations can be added without breaking callers.

## Inputs
- `name` (string, required)
- `location` (string, required)
- `labels` (map(string), optional)
- `versioning` (bool, optional)
- `force_destroy` (bool, optional)

## Outputs
- `name`
- `location`

## TODO
- GCP: `google_storage_bucket`
- IBM: COS bucket + service credentials
- AWS: `aws_s3_bucket`
- Azure: storage account + container
- DigitalOcean: Spaces bucket
