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
  description = "The azure datacenter to deploy the resources to. (e.g: eastus2). This will be automatically determined from the Azure Subscription name if the Nuance Subscription naming convention is followed."
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
  default     = "Standard_D16pds_v5"
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