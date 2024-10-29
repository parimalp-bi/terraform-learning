output "vm_id" {
  description = "ID of the created Virtual Machine"
  value       = azurerm_virtual_machine.vm.id
}

output "nic_id" {
  description = "ID of the created Virtual Machine"
  value       = module.nic.nic_id
}
