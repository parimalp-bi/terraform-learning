resource "azurerm_resource_group" "aks" {
  count    = var.create_resource_group == true ? 1 : 0
  name     = local.rg_name
  location = var.location
  tags     = merge(var.resource_group_tags, var.tags)
}

# https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-address-prefix#prefix-sizes  for prefix_length /28 (IPv4) or /124 (IPv6) = 16 addresses
resource "azurerm_public_ip_prefix" "ip_prefixes" {
  depends_on          = [azurerm_resource_group.aks]
  name                = "${var.prefix}-ip-prefixes"
  location            = var.location
  resource_group_name = local.rg_name
  prefix_length       = var.outbound_ipv4_prefix_length
  tags                = merge(var.resource_group_tags, var.tags)
  zones               = var.outbound_ip_prefix_availability_zones
}

resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [
    azurerm_resource_group.aks,
    azurerm_public_ip_prefix.ip_prefixes
  ]
  name                = "${var.prefix}-k8s"
  location            = var.location
  resource_group_name = local.rg_name

  # dns_prefix   (FQDN) of the Kubernetes API server.
  dns_prefix = "${var.prefix}-k8s"

  kubernetes_version  = var.aks_control_plane_version
  node_resource_group = local.node_resource_group_name

  sku_tier = var.sku_tier

  local_account_disabled = var.local_account_disabled

  auto_scaler_profile {

    balance_similar_node_groups                   = var.auto_scaler_profile_settings.balance_similar_node_groups
    daemonset_eviction_for_empty_nodes_enabled    = var.auto_scaler_profile_settings.daemonset_eviction_for_empty_nodes_enabled
    daemonset_eviction_for_occupied_nodes_enabled = var.auto_scaler_profile_settings.daemonset_eviction_for_occupied_nodes_enabled
    ignore_daemonsets_utilization_enabled         = var.auto_scaler_profile_settings.ignore_daemonsets_utilization_enabled
    expander                                      = var.auto_scaler_profile_settings.expander
    max_graceful_termination_sec                  = var.auto_scaler_profile_settings.max_graceful_termination_sec
    max_node_provisioning_time                    = var.auto_scaler_profile_settings.max_node_provisioning_time
    max_unready_nodes                             = var.auto_scaler_profile_settings.max_unready_nodes
    max_unready_percentage                        = var.auto_scaler_profile_settings.max_unready_percentage
    new_pod_scale_up_delay                        = var.auto_scaler_profile_settings.new_pod_scale_up_delay
    scale_down_delay_after_add                    = var.auto_scaler_profile_settings.scale_down_delay_after_add
    scale_down_delay_after_delete                 = var.auto_scaler_profile_settings.scale_down_delay_after_delete
    scale_down_delay_after_failure                = var.auto_scaler_profile_settings.scale_down_delay_after_failure
    scan_interval                                 = var.auto_scaler_profile_settings.scan_interval
    scale_down_unneeded                           = var.auto_scaler_profile_settings.scale_down_unneeded
    scale_down_unready                            = var.auto_scaler_profile_settings.scale_down_unready
    scale_down_utilization_threshold              = var.auto_scaler_profile_settings.scale_down_utilization_threshold
    empty_bulk_delete_max                         = var.auto_scaler_profile_settings.empty_bulk_delete_max
    skip_nodes_with_local_storage                 = var.auto_scaler_profile_settings.skip_nodes_with_local_storage
    skip_nodes_with_system_pods                   = var.auto_scaler_profile_settings.skip_nodes_with_system_pods
  }


  default_node_pool {

    temporary_name_for_rotation = format("%stmp", var.agent_pool_default_name)

    name = var.agent_pool_default_name
    # In an AKS cluster, when auto-scaling is enabled for a node pool, the node_count property is typically not required or used, as the number of nodes is managed dynamically within the specified range (min_count and max_count).
    node_count                   = var.agent_pool_default_enable_auto_scaling ? null : var.agent_pool_default_vm_count
    vm_size                      = var.agent_pool_default_vm_size
    auto_scaling_enabled         = var.agent_pool_default_enable_auto_scaling
    fips_enabled                 = var.agent_pool_default_fips_enabled
    min_count                    = var.agent_pool_default_enable_auto_scaling ? var.agent_pool_default_vm_min_count : null
    max_count                    = var.agent_pool_default_enable_auto_scaling ? var.agent_pool_default_vm_max_count : null
    max_pods                     = var.agent_pool_default_max_pods_count #optional
    os_sku                       = var.agent_pool_default_os_sku
    os_disk_size_gb              = var.agent_pool_default_os_disk_size_gb
    os_disk_type                 = var.agent_pool_default_os_disk_type
    type                         = "VirtualMachineScaleSets"
    vnet_subnet_id               = var.subnets_id.default
    orchestrator_version         = var.aks_control_plane_version
    node_labels                  = var.agent_pool_default_node_labels
    tags                         = merge(var.agent_pool_default_tags, var.tags)
    only_critical_addons_enabled = var.agent_pool_default_only_critical_addons_enabled
    zones                        = var.cluster_availability_zones

    #The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade.
    dynamic "upgrade_settings" {
      for_each = var.agent_pool_default_max_surge != null ? [1] : []
      content {
        max_surge = var.agent_pool_default_max_surge
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  # CSI driver secret enabled true
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  linux_profile {
    admin_username = "gatekeeper"

    ssh_key {
      key_data = var.admin_ssh_key
    }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    network_plugin_mode = null
    dns_service_ip = var.network_dns_service_ip
    #pod_cidr       = var.network_pod_cidr_ipv4
    service_cidr   = var.network_service_cidr_ipv4
    outbound_type  = var.outbound_type

    load_balancer_sku = var.load_balancer_sku

    load_balancer_profile {
      outbound_ports_allocated  = var.outbound_ports_allocated
      idle_timeout_in_minutes   = var.idle_timeout_in_minutes
      managed_outbound_ip_count = null
      outbound_ip_prefix_ids    = [azurerm_public_ip_prefix.ip_prefixes.id]
      outbound_ip_address_ids   = null
    }
  }

  # https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/aks/aad-integration.md
  role_based_access_control_enabled = true

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.managed_aad_enabled ? [1] : []
    content {
      admin_group_object_ids = var.managed_aad_admin_group_object_ids
      azure_rbac_enabled     = var.managed_aad_azure_rbac_enabled
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window[*]
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed != null ? maintenance_window.value.allowed[*] : []
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed != null ? maintenance_window.value.not_allowed[*] : []
        content {
          start = not_allowed.value.start
          end   = not_allowed.value.end
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.maintenance_window_node_os == null ? [] : [var.maintenance_window_node_os]
    content {
      duration     = maintenance_window_node_os.value.duration
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      day_of_month = maintenance_window_node_os.value.day_of_month
      day_of_week  = maintenance_window_node_os.value.day_of_week
      start_date   = maintenance_window_node_os.value.start_date
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      week_index   = maintenance_window_node_os.value.week_index

      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed == null ? [] : maintenance_window_node_os.value.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }
}


# cluster-aks-rg group lock
/* resource "azurerm_management_lock" "rg-group-lock" {
  depends_on = [azurerm_resource_group.aks]
  count      = var.resource_lock && var.create_resource_group == true ? 1 : 0
  name       = "${var.prefix}-${var.location}-rg-lock"
  scope      = azurerm_resource_group.aks[0].id
  lock_level = "CanNotDelete"
  # Lifecycle blocks can't take interpolation https://github.com/hashicorp/terraform/issues/3116
  lifecycle {
    prevent_destroy = true
  }
}

# cluster-aks-rg group lock
resource "azurerm_management_lock" "cluster-lock" {
  depends_on = [azurerm_kubernetes_cluster.aks, azurerm_kubernetes_cluster_node_pool.agent_pools]
  count      = var.resource_lock ? 1 : 0
  name       = "${var.prefix}-${var.location}-cluster-lock"
  scope      = azurerm_kubernetes_cluster.aks.id
  lock_level = "CanNotDelete"
  # Lifecycle blocks can't take var interpolation https://github.com/hashicorp/terraform/issues/3116
  lifecycle {
    prevent_destroy = true
  }
} */
