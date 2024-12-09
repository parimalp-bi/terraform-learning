variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name"
  default     = null
}

variable "location" {
  type        = string
  description = "location name where do you want to create a resources"
}

variable "acr_names" {
  type    = list(string)
  default = ["gatekeeper"]
}

variable "acr_sku" {
  type    = string
  default = "Premium"
}

variable "acr_admin_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether the admin user is enabled, default to False. If activated, you can use the registry name as username and admin user access key as password to docker login to your container registry."
}

variable "acr_anonymous_pull_enabled" {
  type        = string
  description = "Whether anonymous pull should be enabled"
  default     = false
}

variable "acr_data_endpoint_enabled" {
  type        = bool
  description = "Whether to enable dedicated data endpoints"
  default     = false
}

variable "acr_georeplication_locations" {
  type        = list(string)
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated."
  default     = []
}

variable "acr_regional_endpoint_enabled" {
  type        = bool
  description = "Whether to enable regionnal endpoint"
  default     = false
}

variable "acr_zone_redundancy_enabled" {
  type        = bool
  description = "Whether to enable zone redundancy"
  default     = false
}

variable "acr_public_network_access_enabled" {
  type        = bool
  description = "Whether to enable public network access"
  default     = false
}

variable "acr_image_retention_policy_enabled" {
  type        = bool
  default     = false
  description = "Enable Retention policy, which will clean up untagged images"
}

variable "acr_trust_policy_enabled" {
  type        = bool
  description = "Whether to enable trust policy When turned on, content trust enables you to push trusted images to the registry"
  default     = false
}


variable "resource_group_tags" {
  type        = map(string)
  default     = {}
  description = "Azure resource tags for resource groups."
}

variable "acr_tags" {
  type        = map(string)
  description = "Azure resource acr_tags"
  default     = {}
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint creation for ACR"
  type        = bool
  default     = false
}

variable "pep_resource_group_name" {
  type        = string
  default     = null
  description = "Private endpoint creation resource group"
}

variable "region_subnet_map" {
  description = "Mapping of regions to subnet IDs for private endpoint creation"
  type        = map(string) # Example: { "East US" = "subnet-id-1", "West US" = "subnet-id-2" }
}

variable "private_endpoint_tags" {
  description = "Tags for private endpoints"
  type        = map(string)
  default     = {}
}
