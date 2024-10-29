output "public_ip_address" {
    description = "Public IP"
    value = azurerm_public_ip.public_ip.ip_address
}

output "public_ip_id" {
    description = "Public IP"
    value = azurerm_public_ip.public_ip.id
}