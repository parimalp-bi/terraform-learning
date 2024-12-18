variable "vm_name" {
  description = "The name of the virtual machine"
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

variable "nic_id" {
  description = "The ID of the Network Interface"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
}

variable "image_publisher" {
  description = "The publisher of the VM image"
  type        = string
}

variable "image_offer" {
  description = "The offer of the VM image"
  type        = string
}

variable "image_sku" {
  description = "The SKU of the VM image"
  type        = string
}

variable "image_version" {
  description = "The version of the VM image"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the VM"
  type        = map(string)
}
