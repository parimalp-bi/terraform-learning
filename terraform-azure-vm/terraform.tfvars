vm_name             = "my-vm"
location            = "East US"
resource_group_name = "kml_rg_main-f59c52460cdb4f3a"
vm_size             = "Standard_DS1_v2"
subnet_id           = "/subscriptions/a2b28c85-1948-4263-90ca-bade2bac4df4/resourceGroups/kml_rg_main-f59c52460cdb4f3a/providers/Microsoft.Network/virtualNetworks/parimaltestingtobedeleted/subnets/default"
admin_username      = "adminuser"
# admin_password      = "<>" your machine passsowrd here 
image_publisher     = "Canonical"
image_offer         = "UbuntuServer"
image_sku           = "18.04-LTS"
image_version       = "latest"
tags = {
  environment = "dev"
  owner       = "parimal-testing"
}

# Network variables
vnet_name      = "parimaltesting-vnet"
subnet_name    = "default"
address_space  = ["10.0.0.0/16"]
address_prefix = ["10.0.1.0/29"] # CIDR block with 8 IPs, providing 6 usable IPs

public_ip_allocation_method = "Static"
public_ip_name              = "parimaltestingpublicip"