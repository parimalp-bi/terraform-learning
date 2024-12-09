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
  source     = "../../modules/aks"
  depends_on = [module.network]
  // for Node and Pod Network Settings
  subnets_id = module.network.subnet_id
  // for Node and Pod Network Settings 
  // for ip_prefixes
  outbound_ipv4_prefix_length           = var.outbound_ipv4_prefix_length
  outbound_ip_prefix_availability_zones = var.outbound_ip_prefix_availability_zones
  // for ip_prefixes
  // for aks
  location                           = var.location
  prefix                             = var.prefix
  managed_aad_admin_group_object_ids = var.managed_aad_admin_group_object_ids
  admin_ssh_key                      = var.admin_ssh_key
  aks_control_plane_version          = var.aks_control_plane_version
  sku_tier                           = var.sku_tier
  resource_group_name                = local.rg_name
  node_resource_group_name           = local.node_resource_group_name
  create_resource_group              = var.create_resource_group
  // for aks


  local_account_disabled = var.local_account_disabled
  # Agent Pools
  auto_scaler_profile_settings                    = var.auto_scaler_profile_settings
  agent_pool_default_vm_size                      = var.agent_pool_default_vm_size
  agent_pool_default_fips_enabled                 = var.agent_pool_default_fips_enabled
  agent_pool_default_max_pods_count               = var.agent_pool_default_max_pods_count
  agent_pool_default_os_sku                       = var.agent_pool_default_os_sku
  agent_pool_default_os_disk_size_gb              = var.agent_pool_default_os_disk_size_gb
  agent_pool_default_os_disk_type                 = var.agent_pool_default_os_disk_type
  agent_pool_default_node_labels                  = var.agent_pool_default_node_labels
  agent_pool_default_tags                         = var.agent_pool_default_tags
  agent_pool_default_only_critical_addons_enabled = var.agent_pool_default_only_critical_addons_enabled
  cluster_availability_zones                      = var.cluster_availability_zones
  agent_pool_default_max_surge                    = var.agent_pool_default_max_surge
}