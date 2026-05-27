# Platform healing — reconcile apply

- **Proposal:** `proposal-ec1557a55b7e`
- **Resource:** `this`
- **Drift type:** `CLOUD_VS_STATE`
- **Terraform address:** `module.main_rg`
- **Target file:** `main.tf`

Merging this PR authorizes `terraform apply` to sync cloud state with the declared baseline. No `.tf` file changes are required.
