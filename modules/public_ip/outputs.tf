output "public_ip_id" {
  description = "The ID of the created Public IP"
  value       = azurerm_public_ip.public_ip.id
}
