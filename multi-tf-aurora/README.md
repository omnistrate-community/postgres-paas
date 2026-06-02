# Multi Terraform Aurora Example

This fixture exercises service plan spec imports with multiple Terraform
resources sourced from the same Git repository but different Terraform
subdirectories.

- `spec.yaml` defines ten Terraform resources.
- Each resource points at the same repository and Git reference.
- Each resource uses a different folder under `terraform/aurora-cluster-*`.

The orchestration integration test rewrites the repository URL to a temporary
local Git repository so it can verify repository caching without network access.
