terraform {
  required_version = ">= 1.3.0"
}

// TODO(provider-specific): implement for GCP (GCS), IBM (COS), AWS (S3), Azure (Blob), DO (Spaces).
// Keep the module interface stable and expose a small set of common outputs.
