# Terraform configuration generated from Resource Plan
# Environment: dev
# Generated from deterministic resource plan (Phase 2)
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestor4468"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}


terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# ========================================
# Phase: 1 Foundation
# ========================================

# Module: rg_main (azurerm_resource_group)
module "main_rg" {
  source = "./modules/azure-resource-group"

  location = var.location
  name     = "project-rg-7d6bab"
  tags     = var.tags
}

# Module: log_analytics (azurerm_log_analytics_workspace)
module "log_analytics" {
  source = "./modules/azure-log-analytics-workspace"

  location            = var.location
  name                = "project-log"
  resource_group_name = module.main_rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

# ========================================
# Phase: 2 Shared Infrastructure
# ========================================

# Module: app_service_plan (azurerm_service_plan)
module "shared_plan" {
  source = "./modules/azure-app-service-plan"

  kind                = "Linux"
  location            = var.location
  name                = "project-infrastructure"
  resource_group_name = module.main_rg.name
  sku = {
    tier     = "Basic"
    size     = "B1"
    capacity = 1
  }
  tags = merge(var.tags, {
    cost_center = "governance-required"
    environment = "governance-required"
    owner = "governance-required"
    project = "governance-required"
  })
}

# ========================================
# Phase: 3 Data
# ========================================

# Module: mongodb-database_account (azurerm_cosmosdb_account)
module "mongodb_database_cosmos" {
  source = "./modules/azure-cosmosdb-account"

  consistency_policy              = var.consistency_policy
  enable_automatic_failover       = true
  enable_multiple_write_locations = false
  geo_location                    = var.geo_location
  kind                            = "MongoDB"
  location                        = var.location
  name                            = "project-cosmos-269686"
  offer_type                      = "Standard"
  resource_group_name             = module.main_rg.name
  tags                            = merge(var.tags, {
    cost_center = "governance-required"
    environment = "governance-required"
    owner = "governance-required"
    project = "governance-required"
  })
}

# ========================================
# Phase: 4 Compute
# ========================================

# Module: express-backend_app (azurerm_linux_web_app)
module "express_backend_app" {
  source = "./modules/azure-linux-web-app"

  app_settings = {
  }
  enable_system_identity = true
  https_only             = true
  location               = var.location
  name                   = "project-backend-cf6a5d"
  resource_group_name    = module.main_rg.name
  runtime_stack = {
    language = "node"
    version  = var.express_backend_node_version
  }
  service_plan_id = module.shared_plan.id
  tags            = var.tags
}
