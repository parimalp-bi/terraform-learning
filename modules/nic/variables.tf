variable "vm_name" {
  description = "The name of the virtual machine (used for NIC name)"
  type        = string
}

variable "location" {
  description = "The Azure location for resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the NIC will be created"
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the Public IP to associate with the NIC"
  type        = string
  default     = null
}
