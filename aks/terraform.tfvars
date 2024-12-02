managed_aad_admin_group_object_ids = ["<aad-group-object-id>"] # aad security group
prefix                             = "onpremsetup"
admin_ssh_key                      = "<admin public ssh key for node ssh>"
location                           = "eastus2"
subnets_id                         = { default = "<vnet-resource-id>" } # this vnet is for pod and node ips. internal-loadbalancer services will also take ip from here
agent_pool_default_os_disk_type    = "Ephemeral"
agent_pool_default_vm_size         = "Standard_D4s_v3"