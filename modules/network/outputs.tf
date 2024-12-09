output "subnet_ids" {
  description = "A map of subnet IDs keyed by subnet names"
  value       = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}
