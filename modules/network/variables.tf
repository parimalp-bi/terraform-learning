variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}


variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}


variable "subnets" {
  description = "A list of subnet configurations"
  type = list(object({
    name           = string
    address_prefix = list(string)
  }))
}

variable "create_vnet_resource_group" {
  type        = bool
  description = "decides if a new resource group should be created for the AKS resources"
  default     = false
}
