variable "name" {
  description = "Name of the Cosmos DB account"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 44
    error_message = "Cosmos DB account name must be between 1 and 44 characters."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "offer_type" {
  description = "Cosmos DB offer type"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard"], var.offer_type)
    error_message = "Offer type must be Standard."
  }
}

variable "kind" {
  description = "Cosmos DB kind (GlobalDocumentDB, MongoDB, Parse)"
  type        = string
  default     = "GlobalDocumentDB"

  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB", "Parse"], var.kind)
    error_message = "Kind must be GlobalDocumentDB, MongoDB, or Parse."
  }
}

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

variable "enable_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}



