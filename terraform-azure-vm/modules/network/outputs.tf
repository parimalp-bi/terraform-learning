output "subnet_id" {
  description = "The ID of the created subnet"
  value       = azurerm_subnet.subnet.id
}

output "address_space" {
  description = "The address space for the virtual network"
  value       = var.address_space
}

output "address_prefix" {
  description = "The address prefix for the subnet"
  value       = var.address_prefix
}

output "subnet_name" {
  description = "The name of the created subnet"
  value       = var.subnet_name
}

output "vnet_name" {
  description = "The name of the created virtual network"
  value       = var.vnet_name
}