# # Network variables
vnet_name     = "parimaltesting-vnet"
address_space = ["10.0.0.0/16"]

subnets = [
  {
    name           = "subnet1"
    address_prefix = ["10.0.1.0/29"]
  }
]

subnet_key = "subnet1"

public_ip_allocation_method = "Static"
public_ip_name              = "parimaltestingpublicip"


location            = "East US"
resource_group_name = "parimal-testing"
vm_name             = "parimal-vm"
vm_size             = "Standard_DS1_v2"
admin_username      = ""
admin_password      = ""
image_publisher     = "Canonical"
image_offer         = "UbuntuServer"
image_sku           = "18.04-LTS"
image_version       = "latest"
tags = {
  environment = "dev"
  owner       = "parimal-testing"
}
