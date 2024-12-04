output "nic_id" {
  description = "The ID of the created Network Interface"
  value       = azurerm_network_interface.nic.id
}
