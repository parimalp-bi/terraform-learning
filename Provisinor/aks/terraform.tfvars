managed_aad_admin_group_object_ids = [""] # aad security group
prefix                             = "parimalaks"
admin_ssh_key                      = ""
location                           = "eastus2"
os_disk_type                       = "Ephemeral"
vnet_name                          = "parimalaks-testing-vnet"
address_space                      = ["10.0.0.0/16"]
create_vnet_resource_group         = true

subnets = [
    {
      name           = "defualt"
      address_prefix = ["10.0.0.0/20"]
    }
  ]


subnet_key = "defualt"