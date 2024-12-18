variable "location" {
  description = "The Azure location for resources"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
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

variable "public_ip_name" {
  description = "The name of the public IP"
  type        = string
}

variable "public_ip_allocation_method" {
  description = "The allocation method for the Public IP (Static or Dynamic)"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
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

variable "subnet_key" {
  description = "Key of the subnet to attach the NIC"
  type        = string
}