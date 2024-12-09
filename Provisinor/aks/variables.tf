variable "location" {
  description = "The Azure location for resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
}

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
}

variable "sku_tier" {
  type        = string
  description = "Specifies the Sku of the cluster. Possible values are Free or Standard. Paid includes Uptime SLA. Defaults to Standard."
  default     = "Standard"
}

variable "vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Kubernetes Linux nodes VM type"
  default     = "Standard_D16pds_v5"
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
