output "subnet_id" {
  description = "The ID of the created subnet"
  value       = azurerm_subnet.subnet.id
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}