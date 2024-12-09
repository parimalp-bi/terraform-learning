module "network" {
  source              = "../../modules/network"
  vnet_name           = var.vnet_name
  location            = var.location
  subnet_name         = var.subnet_name
  address_prefix      = var.address_prefix
  resource_group_name = local.rg_name
  address_space       = var.address_space

}

module "aks" {
  source                             = "../../modules/aks"
  depends_on                         = [module.network]
  subnets_id                         = module.network.subnet_id // for Node and Pod Network Settings
  location                           = var.location
  prefix                             = var.prefix
  managed_aad_admin_group_object_ids = var.managed_aad_admin_group_object_ids
  admin_ssh_key                      = var.admin_ssh_key
  aks_control_plane_version          = var.aks_control_plane_version
  sku_tier                           = var.sku_tier
  resource_group_name                = local.rg_name
  node_resource_group_name           = local.node_resource_group_name
  create_resource_group              = var.create_resource_group
  outbound_ipv4_prefix_length        = var.outbound_ipv4_prefix_length
outbound_ip_prefix_availability_zones = var.outbound_ip_prefix_availability_zones
}