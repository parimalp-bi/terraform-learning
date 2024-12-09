resource "azurerm_resource_group" "acr_rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.resource_group_tags
}

resource "azurerm_container_registry" "acr" {
  for_each               = toset(var.acr_names)
  name                   = each.value
  resource_group_name    = azurerm_resource_group.acr_rg.name
  location               = var.location
  sku                    = var.acr_sku
  admin_enabled          = var.acr_admin_enabled
  anonymous_pull_enabled = var.acr_anonymous_pull_enabled
  data_endpoint_enabled  = var.acr_sku == "Premium" ? var.acr_data_endpoint_enabled : null
  dynamic "georeplications" {
    for_each = var.acr_sku == "Premium" ? var.acr_georeplication_locations : []
    content {
      location                  = georeplications.value
      regional_endpoint_enabled = var.acr_regional_endpoint_enabled
      zone_redundancy_enabled   = var.acr_zone_redundancy_enabled
      tags                      = var.acr_tags
    }
  }

  zone_redundancy_enabled       = var.acr_sku == "Premium" ? var.acr_zone_redundancy_enabled : false
  public_network_access_enabled = var.acr_sku == "Premium" ? var.acr_public_network_access_enabled : true
  trust_policy_enabled          = var.acr_sku == "Premium" ? var.acr_trust_policy_enabled : false
  tags                          = merge(var.resource_group_tags, var.acr_tags)
}

resource "azurerm_private_endpoint" "acr_endpoints" {
  for_each            = var.enable_private_endpoint ? toset(var.acr_georeplication_locations) : []
  name                = "acr-${each.key}-pep"
  location            = each.key
  resource_group_name = var.pep_resource_group_name
  subnet_id           = var.region_subnet_map[each.value]

  private_service_connection {
    name                           = "acr-${each.key}-connection"
    private_connection_resource_id = azurerm_container_registry.acr[each.key].id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.private_endpoint_tags
}

