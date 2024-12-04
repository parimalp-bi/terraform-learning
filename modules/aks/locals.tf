locals {
    rg_name= var.resource_group_name != null ? var.resource_group_name : "${var.prefix}-aks-rg"
    node_resource_group_name = var.node_resource_group_name != null ? var.node_resource_group_name : "${var.prefix}-aks-resources"
}