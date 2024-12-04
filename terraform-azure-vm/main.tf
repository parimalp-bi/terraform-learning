module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  address_prefix      = var.address_prefix
}

output "subnet_id" {
  value = module.network.subnet_id
}

module "nic" {
  source              = "./modules/nic"
  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.subnet_id # Use subnet_id from the network module
  public_ip_id        = module.public_ip.public_ip_id
}

output "nic_id" {
  value = module.nic.nic_id
}

module "public_ip" {
  source                      = "./modules/public_ip"
  public_ip_name              = var.public_ip_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  public_ip_allocation_method = var.public_ip_allocation_method
}

output "public_ip_id" {
  description = "The ID of the created Public IP"
  value       = module.public_ip.public_ip_id
}

module "vm" {
  source              = "./modules/vm"
  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  nic_id              = module.nic.nic_id # Use NIC ID from the NIC module
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  image_version       = var.image_version
  tags                = var.tags
}
