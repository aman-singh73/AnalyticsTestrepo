# Platform healing — reconcile apply

- **Proposal:** `proposal-4ea7c99692b2`
- **Resource:** `project-log`
- **Drift type:** `CLOUD_VS_STATE`
- **Terraform address:** `module.log_analytics`
- **Target file:** `main.tf`

Merging this PR authorizes `terraform apply` to sync cloud state with the declared baseline. No `.tf` file changes are required.
