output "id" {
  description = "The ID of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.id
}

output "name" {
  description = "The name of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "The endpoint of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "The primary key for the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "primary_readonly_key" {
  description = "The primary readonly key for the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.primary_readonly_key
  sensitive   = true
}

output "connection_strings" {
  description = "A list of connection strings for the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.connection_strings
  sensitive   = true
}



