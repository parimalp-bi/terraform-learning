# # Network variables
vnet_name      = "parimaltesting-vnet"
subnet_name    = "default"
address_space  = ["10.0.0.0/16"]
address_prefix = ["10.0.1.0/29"] # CIDR block with 8 IPs, providing 6 usable IPs

public_ip_allocation_method = "Static"
public_ip_name              = "parimaltestingpublicip"


location            = "East US"
resource_group_name = "kml_rg_main-9e25c0c8b6d44a91"
vm_name             = "parimal-vm"
vm_size         = "Standard_DS1_v2"
admin_username  = "adminuser"
admin_password  = "P@ssword123!"
image_publisher = "Canonical"
image_offer     = "UbuntuServer"
image_sku       = "18.04-LTS"
image_version   = "latest"
tags = {
  environment = "dev"
  owner       = "parimal-testing"
}
