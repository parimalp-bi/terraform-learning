locals {
  rg_name = var.resource_group_name != null ? var.resource_group_name : "${var.prefix}-acr-rg"
}