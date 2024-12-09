resource "azurerm_resource_group" "vnet" {
  count    = var.create_vnet_resource_group == true ? 1 : 0
  name     = local.rg_name
  location = var.location
}


resource "azurerm_virtual_network" "vnet" {
  depends_on = [ azurerm_resource_group.vnet ]
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.create_vnet_resource_group ? azurerm_resource_group.vnet[0].name : var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each            = { for idx, subnet in var.subnets : idx => subnet }
  name                = each.value.name
  resource_group_name = var.create_vnet_resource_group ? azurerm_resource_group.vnet[0].name : var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = each.value.address_prefix
}