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
  tags = var.tags
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
  tags                            = var.tags
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



# ========================================
# Phase: 5 Virtual Machine (For Testing)
# ========================================

resource "azurerm_virtual_network" "test_vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = module.main_rg.name
}

resource "azurerm_subnet" "test_subnet" {
  name                 = "test-subnet"
  resource_group_name  = module.main_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "test_pip" {
  name                = "test-pip"
  location            = var.location
  resource_group_name = module.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "test_nsg" {
  name                = "test-nsg"
  location            = var.location
  resource_group_name = module.main_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "test_nic" {
  name                = "test-nic"
  location            = var.location
  resource_group_name = module.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "test_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.test_nic.id
  network_security_group_id = azurerm_network_security_group.test_nsg.id
}

resource "azurerm_linux_virtual_machine" "test_vm" {
  name                            = "test-stress-vm"
  resource_group_name             = module.main_rg.name
  location                        = var.location
  size                            = "Standard_B2ms"
  admin_username                  = "azureuser"
  admin_password                  = "TestP@ssw0rd123!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.test_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
