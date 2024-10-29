module "public_ip" {
  source = "../public_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ip_name = var.public_ip_name
  public_ip_allocation_method = var.public_ip_allocation_method
}

module "network" {
  source              = "../network"
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  address_prefix      = var.address_prefix
}

module "nic" {
  source = "../nic"
  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id  
  public_ip_id        = module.public_ip.public_ip_id
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [module.nic.nic_id] # Reference the nic module output
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}
