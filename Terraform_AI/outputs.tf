# Outputs for Terraform configuration
# Environment: dev

output "app_service_plan_id" {
  description = "App Service Plan ID"
  value       = module.shared_plan.id
}

output "express-backend_id" {
  description = "Resource ID of express-backend"
  value       = module.express_backend_app.id
}

output "express-backend_url" {
  description = "URL of express-backend"
  value       = module.express_backend_app.default_hostname
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.log_analytics.id
}

output "mongodb-database_connection_string" {
  description = "Connection string for mongodb-database"
  sensitive   = true
  value       = module.mongodb_database_cosmos.connection_strings[0]
}

output "mongodb-database_endpoint" {
  description = "Endpoint for mongodb-database"
  value       = module.mongodb_database_cosmos.endpoint
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = module.main_rg.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = module.main_rg.name
}
