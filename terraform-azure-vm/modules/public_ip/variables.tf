variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}


variable "location" {
  description = "Location for public ip"
  type        = string
}

variable "public_ip_name" {
  description = "public ip name"
  type        = string
}

variable "public_ip_allocation_method" {
  description = "public_ip_allocation_method"
  type        = string
}
