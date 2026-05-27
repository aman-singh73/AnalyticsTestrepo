# Module: unmanagedtest2060 (azurerm_storage_account)
module "unmanagedtest2060" {
  source = "./modules/azure-storage-account"

  name = "unmanagedtest2060"
  location = "eastus"
  resource_group_name = "project-rg-7d6bab"
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}
