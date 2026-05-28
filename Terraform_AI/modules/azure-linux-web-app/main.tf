resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id
  https_only          = var.https_only

  site_config {
    application_stack {
      node_version   = var.runtime_stack.language == "node" ? var.runtime_stack.version : null
      python_version = var.runtime_stack.language == "python" ? var.runtime_stack.version : null
      dotnet_version = var.runtime_stack.language == "dotnet" ? var.runtime_stack.version : null
      java_version   = var.runtime_stack.language == "java" ? var.runtime_stack.version : null
      php_version    = var.runtime_stack.language == "php" ? var.runtime_stack.version : null
    }
  }

  app_settings = var.app_settings

  identity {
    type = var.enable_system_identity ? "SystemAssigned" : "None"
  }

  tags = var.tags
}



