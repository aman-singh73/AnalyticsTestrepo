# Variables for Terraform configuration
# Environment: dev

# Common variables
variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
}


variable "subscription_id" {
  description = "Azure subscription ID (not a secret)"
  type        = string
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Resource-specific variables
variable "consistency_policy" {
  description = "Consistency policy configuration"
  type = object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
  })
  default = {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
}
variable "express_backend_node_version" {
  description = "Node.js version for express-backend"
  type        = string
  default     = "18-lts"
}

variable "geo_location" {
  description = "Geo-location configuration"
  type = list(object({
    location          = string
    failover_priority = number
  }))

  validation {
    condition     = length(var.geo_location) > 0
    error_message = "At least one geo_location must be specified."
  }
}