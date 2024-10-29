# module "network" {
#   source              = "./modules/network"
#   vnet_name           = var.vnet_name
#   subnet_name         = var.subnet_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = var.address_space
#   address_prefix      = var.address_prefix
# }

module "vm" {
  source                      = "./modules/vm"
  vm_name                     = var.vm_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  vm_size                     = var.vm_size
  subnet_id                   = var.subnet_id
  admin_username              = var.admin_username
  admin_password              = var.admin_password
  image_publisher             = var.image_publisher
  image_offer                 = var.image_offer
  image_sku                   = var.image_sku
  image_version               = var.image_version
  tags                        = var.tags
  address_prefix              = var.address_prefix
  address_space               = var.address_space
  subnet_name                 = var.subnet_name
  vnet_name                   = var.vnet_name
  public_ip_allocation_method = var.public_ip_allocation_method
  public_ip_name              = var.public_ip_name
}
