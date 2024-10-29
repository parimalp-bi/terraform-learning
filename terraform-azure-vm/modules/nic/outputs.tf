output "nic_id" {
  description = "ID of the created nic "
  value       = azurerm_network_interface.vm_nic.id
}