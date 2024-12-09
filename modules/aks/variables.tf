variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "create_resource_group" {
  type        = bool
  description = "decides if a new resource group should be created for the AKS resources"
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name"
  default     = null
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


variable "aks_control_plane_version" {
  type        = string
  description = "AKS control plane version to install, avaible using `az aks get-versions --location eastus --output table`"
  default     = "1.29.7"
}


variable "sku_tier" {
  type        = string
  description = "Specifies the Sku of the cluster. Possible values are Free or Standard. Paid includes Uptime SLA. Defaults to Standard."
  default     = "Standard"
}

variable "node_resource_group_name" {
  type        = string
  description = "(Optional) define a custom resource group name for the actual VMs and other managed AKS resources"
  default     = null
}

variable "location" {
  type        = string
  description = "The azure datacenter to deploy the resources to. (e.g: eastus2)."
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

variable "agent_pool_default_name" {
  type        = string
  description = "Default Agent pool name"
  default     = "system"
}

# Agent pool profile
variable "agent_pool_default_vm_count" {
  type        = number
  description = "Number of Agents (VMs) in the Pool. Possible values must be in the range of 1 to 100 (inclusive). Defaults to 1."
  default     = 1
}

variable "agent_pool_default_vm_min_count" {
  type        = number
  description = "Minimum number of nodes for auto-scaling"
  default     = 2
}

variable "agent_pool_default_vm_max_count" {
  type        = number
  description = "Maximum number of nodes for auto-scaling"
  default     = 3
}

variable "agent_pool_default_enable_auto_scaling" {
  type        = bool
  description = "Whether to enable auto-scaler. Note that auto scaling feature requires the that the type is set to VirtualMachineScaleSets"
  default     = true
}

variable "agent_pool_default_fips_enabled" {
  type        = bool
  description = "Whether to enable FIPS on the agent pool"
  default     = false
}

variable "agent_pool_default_vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Kubernetes Linux nodes VM type"
  default     = "Standard_D4s_v3"
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

# Network
variable "subnets_id" {
  type        = map(string)
  description = <<EOS
    Map of subnet ids for the k8s cluster. It must contain a 'default' key as the default node pool subnet
    Example:
      {
        default = "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Network/virtualNetworks/<vnet name>/subnets/<subnet1 name>",
        subnet2 = "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Network/virtualNetworks/<vnet name>/subnets/<subnet2 name>",
}
EOS
  validation {
    condition     = can(var.subnets_id.default)
    error_message = "Variable k8s_subnets_id must contain a key 'default' as the default node pool subnet."
  }
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

variable "agent_pool_default_node_labels" {
  type        = map(string)
  description = "(Optional) Map of node labels for the default node pool"
  default     = null
}

variable "agent_pool_default_node_taints" {
  type        = list(string)
  description = <<EOS
    (Optional) List of node taints for the default node pool

    WARNING: This is currently only partially supported.
    AZURERM v2.35 REMOVED THIS, WHILE AKS ONLY SUPPORTS THE CriticalAddonsOnly TAINTS LATELY.

    See https://github.com/terraform-providers/terraform-provider-azurerm/issues/9183
    See https://github.com/Azure/AKS/issues/1833
  EOS
  default     = null
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

variable "admin_ssh_key" {
  type        = string
  description = "The Public SSH Key used to access the cluster"
}

variable "network_dns_service_ip" {
  type        = string
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). This is required when network_plugin is set to azure."
  default     = "192.168.0.10"
}

variable "network_service_cidr_ipv4" {
  type        = string
  description = "The ipc4 cidr used by the Kubernetes service. This is required when network_plugin is set to azure."
  default     = "192.168.0.0/16"
}

variable "network_pod_cidr_ipv4" {
  type        = string
  description = "The CIDR to use for pod IPv4 addresses. This field can only be set when network_plugin is set to kubenet or azure CNI Overlay."
  default     = "10.0.0.0/22"
}


variable "load_balancer_sku" {
  type        = string
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are basic and standard."
  default     = "standard"
}

variable "outbound_type" {
  type        = string
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer"
  default     = "loadBalancer"
}

variable "outbound_ports_allocated" {
  type        = number
  description = "Number of desired SNAT(Source Network Address Translation)port for each VM in the clusters load balancer. Must be between 0 and 64000 inclusive. Ensures sufficient outbound connectivity for applications. # MUST BE a multiple of 8  "
  default     = 1296
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "Desired outbound flow idle timeout in minutes for the cluster load balancer. Must be between 4 and 100 inclusive. Defaults to 30 Defines how long an idle connection remains open before being terminated by the Load Balancer."
  default     = 30
}


variable "managed_aad_enabled" {
  type        = bool
  description = "Use managed AAD"
  default     = true
}


variable "managed_aad_admin_group_object_ids" {
  type        = list(string)
  description = "List of AD group IDs that will have Admin Role on the cluster. Set it to [] if not using managed AAD."
}

variable "managed_aad_azure_rbac_enabled" {
  type        = bool
  description = <<EOS
    Should Role Based Access Control based on Azure AD be enabled?

    This allows managing authorization via Azure AD, and Kubernetes RBAC as a fallback.
    If enabled, the managed_aad_admin_group_object_ids will be assigned the
    "Azure Kubernetes Service RBAC Cluster Admin" role, as well as to the SP/Identity running TF,
    so it can manage the cluster accordingly.

    See https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac
  EOS
  default     = true
}

variable "workload_identity_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable Workload Identity."
}


variable "maintenance_window" {
  type = object({
    allowed = optional(list(object({
      day   = string
      hours = list(number)
    })))
    not_allowed = optional(list(object({
      start = string
      end   = string
    })))
  })
  description = <<EOS
  (Optional)
  Warning: This is a preview feature. We need to install the aks-preview extension with the following command:
  `az extension add --name aks-preview`
  For more detail: https://docs.microsoft.com/en-us/azure/aks/planned-maintenance

  Maintenance windows will update your control plane as well as your kube-system Pods on a VMSS instance and minimize workload impact.
  Planned Maintenance windows are specified in Coordinated Universal Time (UTC).
  Each time slot gives a maintenance window of 1 hour.

  day - (Required) A day in a week. Possible values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday and Saturday.
  hours - (Required) An array of hour slots in a day. Possible values are between 0 and 23. Example: [1, 2] means 1 hour starting from 1am and 1 hour starting from 2am, so the maintenance window is 1am to 3am
  start - (Required) The start of a time span, formatted as an RFC3339 string.
  end - (Required) The end of a time span, formatted as an RFC3339 string.
  Example format:
  {
    "allowed" : [
      {
        "day" : "Monday",
        "hours" : [1, 2]
      }
    ],
    "not_allowed" : [
      {
        "start": "2021-11-05T03:00:00Z",
        "end": "2021-11-06T12:00:00Z"
      }
    ]
  }
  For more detail in aks tf provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#maintenance_window
  EOS
  default     = null
}

variable "maintenance_window_node_os" {
  type = object({
    day_of_month = optional(number)
    day_of_week  = optional(string)
    duration     = number
    frequency    = string
    interval     = number
    start_date   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    week_index   = optional(string)
    not_allowed = optional(set(object({
      end   = string
      start = string
    })))
  })
  default     = null
  description = <<-EOT
 - `day_of_month` - (Optional) The day of the month for the maintenance run. Required in combination with AbsoluteMonthly frequency. Value between 0 and 31 (inclusive).
 - `day_of_week` - (Optional) The day of the week for the maintenance run. Options are `Monday`, `Tuesday`, `Wednesday`, `Thurday`, `Friday`, `Saturday` and `Sunday`. Required in combination with weekly frequency.
 - `duration` - (Required) The duration of the window for maintenance to run in hours.
 - `frequency` - (Required) Frequency of maintenance. Possible options are `Daily`, `Weekly`, `AbsoluteMonthly` and `RelativeMonthly`.
 - `interval` - (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based.
 - `start_date` - (Optional) The date on which the maintenance window begins to take effect.
 - `start_time` - (Optional) The time for maintenance to begin, based on the timezone determined by `utc_offset`. Format is `HH:mm`.
 - `utc_offset` - (Optional) Used to determine the timezone for cluster maintenance.
 - `week_index` - (Optional) The week in the month used for the maintenance run. Options are `First`, `Second`, `Third`, `Fourth`, and `Last`.

 ---
 `not_allowed` block supports the following:
 - `end` - (Required) The end of a time span, formatted as an RFC3339 string.
 - `start` - (Required) The start of a time span, formatted as an RFC3339 string.
For more details:
  https://learn.microsoft.com/en-us/azure/aks/planned-maintenance?tabs=azure-cli#create-a-maintenance-window
  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#maintenance_window_node_os
EOT
}

#maintenance_window = null
#{
#  "allowed" : [
#    {
#      "day" : "Tuesday",
#      "hours" : [0, 1, 2, 3, 4, 5]
#    },
#    {
#      "day" : "Thursday",
#      "hours" : [0, 1, 2, 3, 4, 5]
#    },
#    {
#      "day" : "Friday",
#      "hours" : [0, 1, 2, 3, 4, 5]
#    },
#  ],
#  "not_allowed" : [
#    {
#      "start" : "2021-11-05T03:00:00Z",
#      "end" : "2021-11-06T12:00:00Z"
#    }
#  ]
#}

variable "attached_container_registry_ids" {
  type        = list(string)
  description = <<EOS
  Resource IDs of attached ACRs. This grants AKS workloads permission to access container images stored in these registries directly through the kubelet identity principalm
  Effectively does the same thing as 'attach-acr' flag under https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-update-optional-parameters for more information
  EOS
  default     = []
}


variable "workload_runtime" {
  type        = string
  description = <<EOS
    (Optional) Used to specify the workload runtime. Allowed values are OCIContainer and WasmWasi.
    WebAssembly System Interface node pools are in Public Preview - more information and details on
    how to opt into the preview can be found in https://docs.microsoft.com/azure/aks/use-wasi-node-pools
    OCIContainer-Represents the standard Open Container Initiative (OCI) runtime for running regular containerized workloads.
    This is the default runtime and includes support for Linux and Windows containers using runtimes like ContainerD or Docker

EOS
  default     = "OCIContainer"
  validation {
    condition     = contains(["OCIContainer", "WasmWasi"], var.workload_runtime)
    error_message = "Var.workload_runtime only allows \"OCIContainer\" and \"WasmWasi\"."
  }
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

/* agent_pools = {
  pool1 = {
    os_type               = "Linux"
    os_sku                = "Ubuntu"
    node_count            = 3
    vm_size               = "Standard_DS2_v2"
    mode                  = "System"
    autoscale             = true
    max_node_count        = 5
    min_node_count        = 2
    os_disk_size_gb       = "128"
    os_disk_type          = "Ephemeral"
    max_pods_count        = "110"
    aks_version           = "1.28.0"
    enable_node_public_ip = false
    fips_enabled          = false
    node_labels           = { "env" = "prod", "team" = "devops" }
    node_taints           = ["key1=value1:NoSchedule"]
    subnet_id             = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>"
    max_surge             = 1
    availability_zones    = ["1", "2"]
    tags                  = { "project" = "AKS", "owner" = "team1" }

    kubelet_config = {
      allowed_unsafe_sysctls    = ["net.ipv4.tcp_syncookies"]
      container_log_max_line    = 1000
      container_log_max_size_mb = 50
      cpu_cfs_quota_enabled     = true
      cpu_manager_policy        = "static"
      image_gc_high_threshold   = 85
      image_gc_low_threshold    = 70
      pod_max_pid               = 100
      topology_manager_policy   = "restricted"
    }

    linux_os_config = {
      swap_file_size_mb             = 2048
      transparent_huge_page_enabled = "madvise"
      transparent_huge_page_defrag  = "always"
      sysctl_config = {
        fs_file_max            = 2097152
        net_core_somaxconn     = 1024
        vm_swappiness          = 10
        net_ipv4_tcp_keepalive_time = 600
      }
    }
  }
} */


variable "law_sku" {
  type        = string
  default     = "PerGB2018"
  description = <<EOS
  -------------------------------------
  (Optional)
  You can override the SKU if needed. The Free SKU is N/A anymore, use "law_daily_quota_gb".
  See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace#sku
  Default ""
  -------------------------------------
EOS
  validation {
    condition     = contains(["PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018", ""], var.law_sku)
    error_message = "Var.law_sku only allows https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace#sku and not 'Free' any more."
  }
}


variable "law_daily_quota_gb" {
  type        = number
  default     = null
  description = <<EOS
  -------------------------------------
  (Optional)
  The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted.
  You can use this feature to reduce cost, especially for testing environments (the Free SKU is N/A anymore).
  Default ""
  -------------------------------------
EOS
}

variable "law_internet_ingestion_enabled" {
  type        = bool
  default     = true
  description = <<EOS
  -------------------------------------
  (Optional)
  Allow logs to be ingestion from the internet e.g external oms clents from an external k8s cluster.
  Default true
  -------------------------------------
EOS
}

variable "law_internet_query_enabled" {
  type        = bool
  default     = true
  description = <<EOS
  -------------------------------------
  (Optional)
  Allow internet to query workspace.
  Default true
  -------------------------------------
EOS
}

variable "law_capacity_reservation" {
  type    = number
  default = null
  validation {
    condition     = (var.law_capacity_reservation == null || can(regex("^$|^[1-5]00$|^[1-2]000$|^5000$", var.law_capacity_reservation)))
    error_message = "The law_capacity_reservation must be between 100 and 500 in 100 increments or 1000, 2000, 5000."
  }
  description = <<EOS
  -------------------------------------
  (Optional)
  Reserved capacity, see https://azure.microsoft.com/en-gb/pricing/details/monitor/
  default null
  -------------------------------------
EOS
}

variable "law_retention_in_days" {
  type    = number
  default = 30
  validation {
    condition     = can(regex("^([1-6][0-9][0-9]|7[0-2][0-9]|730|[3-9][0-9])$", var.law_retention_in_days))
    error_message = "The law_retention must be between 30 and 730."
  }
  description = <<EOS
  -------------------------------------
  (Optional)
  Retention period of the Log Analytics Workspace in days. Between 30 and 730
  Default 60
  -------------------------------------
EOS
}


variable "resource_group_tags" {
  type        = map(string)
  default     = {}
  description = "Azure resource tags for resource groups."
}

variable "tags" {
  type        = map(string)
  description = "Azure resource tags"
  default     = {}
}

variable "agent_pool_default_tags" {
  type        = map(string)
  description = "(Optional) Map of tags for the default node pool"
  default     = {}
}

variable "law_tags" {
  type        = map(string)
  description = "(Optional) Map of tags for the law tags"
  default     = {}
}
