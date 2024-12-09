variable "location" {
  description = "The Azure location for resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnets" {
  description = "A list of subnet configurations"
  type = list(object({
    name           = string
    address_prefix = list(string)
  }))
}

variable "subnet_key" {
  description = "Key of the subnet to attach the NIC"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}



variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name"
  default     = null
}

variable "vnet_resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name"
  default     = "parimalaks-aks-vnet-rg"
}
variable "node_resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name for the actual VMs and other managed AKS resources"
  default     = null
}

variable "managed_aad_admin_group_object_ids" {
  type        = list(string)
  description = "List of AD group IDs that will have Admin Role on the cluster. Set it to [] if not using managed AAD."
}

variable "admin_ssh_key" {
  type        = string
  description = "The Public SSH Key used to access the cluster"
}

variable "aks_control_plane_version" {
  type        = string
  description = "Kubernetese version"
  default     = "1.29.7"
}

variable "sku_tier" {
  type        = string
  description = "Specifies the Sku of the cluster. Possible values are Free or Standard. Paid includes Uptime SLA. Defaults to Standard."
  default     = "Standard"
}

variable "os_disk_type" {
  type        = string
  description = "The Agent Operating System disk type"
  default     = "Ephemeral"
  validation {
    condition     = contains(["Managed", "Ephemeral"], var.os_disk_type)
    error_message = "Argument \"\" must be either \"Managed\", or \"Ephemeral\"."
  }
}

variable "create_resource_group" {
  type        = bool
  description = "decides if a new resource group should be created for the AKS resources"
  default     = true
}

variable "create_vnet_resource_group" {
  type        = bool
  description = "decides if a new resource group should be created for the AKS resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure resource tags for resource groups."
}

variable "outbound_ipv4_prefix_length" {
  type        = number
  description = <<EOS
  The CIDR subnet mask length for Public IP Address Prefixes to be created as described in the `aks_managed_outbound_ip_prefixes_enabled` variable.
  WARNING: Standard values are 28 to 31, but Azure Support can raise that limit, depending on the region.
           Defaults to 26 to max out the load balancer and have a single prefix by default,
           but requires a previous Support ticket to have this enabled in this subscription and location!
  Ref - https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-address-prefix#prefix-sizes
  EOS
  default     = 30
}

variable "outbound_ip_prefix_availability_zones" {
  type        = list(string)
  description = <<EOS
  (Optional) Specifies a list of Availability Zones in which this Public IP Prefix should be located. Changing this forces a new Public IP Prefix to be created.
   # Not every region supports availability zones, so we need ability to override this
  Ref - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix#zones
  Supported values: ["1"], ["2"], ["3"], ["1","2","3"] and null.
  EOS
  default     = ["1", "2", "3"]
}

variable "auto_scaler_profile_settings" {
  description = "Auto scaler profile settings."
  default     = {}
  type = object({
    balance_similar_node_groups                   = optional(bool)
    daemonset_eviction_for_empty_nodes_enabled    = optional(bool)
    daemonset_eviction_for_occupied_nodes_enabled = optional(bool)
    expander                                      = optional(string)
    ignore_daemonsets_utilization_enabled         = optional(bool)
    max_graceful_termination_sec                  = optional(number)
    max_node_provisioning_time                    = optional(string)
    max_unready_nodes                             = optional(number)
    max_unready_percentage                        = optional(number)
    new_pod_scale_up_delay                        = optional(string)
    scale_down_delay_after_add                    = optional(string)
    scale_down_delay_after_delete                 = optional(string)
    scale_down_delay_after_failure                = optional(string)
    scan_interval                                 = optional(string)
    scale_down_unneeded                           = optional(string)
    scale_down_unready                            = optional(string)
    scale_down_utilization_threshold              = optional(number)
    empty_bulk_delete_max                         = optional(number)
    skip_nodes_with_local_storage                 = optional(bool)
    skip_nodes_with_system_pods                   = optional(bool)

  })
}

variable "local_account_disabled" {
  type        = bool
  default     = true
  description = <<EOS
  -------------------------------------
  (Optional) (Kept for backward compatability)
  Disable AKS local admin account.
  If local_account_disabled is set to true, it is required to enable Kubernetes RBAC and AKS-managed Azure AD integration
  -------------------------------------
EOS
}

variable "agent_pool_default_enable_auto_scaling" {
  type        = bool
  description = "Whether to enable auto-scaler. Note that auto scaling feature requires the that the type is set to VirtualMachineScaleSets"
  default     = true
}

variable "agent_pool_default_vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Kubernetes Linux nodes VM type"
  default     = "Standard_D4s_v3"
}

variable "agent_pool_default_fips_enabled" {
  type        = bool
  description = "Whether to enable FIPS on the agent pool"
  default     = false
}

variable "agent_pool_default_max_pods_count" {
  type        = number
  description = "The maximum number of pods that can run on each agent"
  default     = 30
}

variable "agent_pool_default_os_sku" {
  type        = string
  description = "The Agent Operating System SKU AzureLinux, Ubuntu, Windows2019, Windows2022"
  default     = "AzureLinux"
}
variable "agent_pool_default_os_disk_size_gb" {
  type        = number
  description = "The Agent Operating System disk size in GB"
  default     = 100
}

variable "agent_pool_default_os_disk_type" {
  type        = string
  description = "The Agent Operating System disk type"
  default     = "Ephemeral"
  validation {
    condition     = contains(["Managed", "Ephemeral"], var.agent_pool_default_os_disk_type)
    error_message = "Argument \"\" must be either \"Managed\", or \"Ephemeral\"."
  }
}

variable "agent_pool_default_node_labels" {
  type        = map(string)
  description = "(Optional) Map of node labels for the default node pool"
  default     = null
}

variable "agent_pool_default_tags" {
  type        = map(string)
  description = "(Optional) Map of tags for the default node pool"
  default     = {}
}

variable "agent_pool_default_only_critical_addons_enabled" {
  type        = bool
  description = <<EOS
    Flag to enable/disable critical addons for default nodepool.
    Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule taint.
    https://registry.terraform.io/providers/hashicorp/azurerm/2.50.0/docs/resources/kubernetes_cluster
    Default value in azurerm codebase is 'false', ref - https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/azurerm/internal/services/containers/kubernetes_nodepool.go#L404
  EOS
  default     = false
}

variable "cluster_availability_zones" {
  type        = list(string)
  description = <<EOS
  (Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster should be located.
  This requires that the type is set to VirtualMachineScaleSets and that load_balancer_sku is set to Standard.

  See https://docs.microsoft.com/en-us/azure/aks/availability-zones#limitations-and-region-availability
  For limitations and region availability

  WARNING! Changing this (including disabling it) FORCES A NEW Cluster to be created (RE-CREATE)

  Supported values: ["1"], ["2"], ["3"], ["1","2","3"] and null. Default is not zone-redundant.
  EOS
  default     = null
}

variable "agent_pool_default_max_surge" {
  type        = number
  description = "System agent pool upgrade max surge nodes"
  default     = 1
}

variable "agent_pools" {
  description = <<EOS
    Agent pool map. The map key.name is used as the name attribute for the node pool.

    See https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster_node_pool.html
    for the semantics of each property.

    WARNING: linux_os_config requires Preview feature Microsoft.ContainerService/CustomNodeConfigPreview to be enabled!
    For os_sku: If not specified, the default is Ubuntu if OSType=Linux or Windows2019 if OSType=Windows. And the
    default Windows OSSKU will be changed to Windows2022 after Windows2019 is deprecated.

    WARNING: Updating availability_zones forces a replacement of the nodepool (destroy and recreate)
             See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool#zones
  EOS

  default = {}
  type = map(object({
    os_type                = string
    os_sku                 = optional(string)
    node_count             = number
    vm_size                = string
    mode                   = string
    autoscale              = bool
    max_node_count         = number
    min_node_count         = number
    os_disk_size_gb        = string
    os_disk_type           = string
    max_pods_count         = string
    node_public_ip_enabled = bool
    fips_enabled           = optional(bool)
    node_labels            = map(string)
    node_taints            = list(string)
    subnet_id              = string
    max_surge              = optional(number)
    availability_zones     = optional(list(string)) # update this force a replacement https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool#zones
    tags                   = optional(map(string))
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(set(string))
      container_log_max_line    = optional(number)
      container_log_max_size_mb = optional(number)
      cpu_cfs_quota_enabled     = optional(bool)
      cpu_cfs_quota_period      = optional(string)
      cpu_manager_policy        = optional(string)
      image_gc_high_threshold   = optional(number)
      image_gc_low_threshold    = optional(number)
      pod_max_pid               = optional(number)
      topology_manager_policy   = optional(string)
    }))
    linux_os_config = optional(object({
      swap_file_size_mb             = optional(number)
      transparent_huge_page_enabled = optional(string)
      transparent_huge_page_defrag  = optional(string)
      sysctl_config = optional(object({
        fs_aio_max_nr                      = optional(number)
        fs_file_max                        = optional(number)
        fs_inotify_max_user_watches        = optional(number)
        fs_nr_open                         = optional(number)
        kernel_threads_max                 = optional(number)
        net_core_netdev_max_backlog        = optional(number)
        net_core_optmem_max                = optional(number)
        net_core_rmem_default              = optional(number)
        net_core_rmem_max                  = optional(number)
        net_core_somaxconn                 = optional(number)
        net_core_wmem_default              = optional(number)
        net_core_wmem_max                  = optional(number)
        net_ipv4_ip_local_port_range_max   = optional(number)
        net_ipv4_ip_local_port_range_min   = optional(number)
        net_ipv4_neigh_default_gc_thresh1  = optional(number)
        net_ipv4_neigh_default_gc_thresh2  = optional(number)
        net_ipv4_neigh_default_gc_thresh3  = optional(number)
        net_ipv4_tcp_fin_timeout           = optional(number)
        net_ipv4_tcp_keepalive_intvl       = optional(number)
        net_ipv4_tcp_keepalive_probes      = optional(number)
        net_ipv4_tcp_keepalive_time        = optional(number)
        net_ipv4_tcp_max_syn_backlog       = optional(number)
        net_ipv4_tcp_max_tw_buckets        = optional(number)
        net_ipv4_tcp_tw_reuse              = optional(bool)
        net_netfilter_nf_conntrack_buckets = optional(number)
        net_netfilter_nf_conntrack_max     = optional(number)
        vm_max_map_count                   = optional(number)
        vm_swappiness                      = optional(number)
        vm_vfs_cache_pressure              = optional(number)
      }))
    }))
  }))
}