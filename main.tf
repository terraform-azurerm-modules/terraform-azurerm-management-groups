terraform {
  required_version = ">= 0.13.0"
}

locals {
  parent = var.parent_management_group_display_name != null || var.parent_management_group_id != null ? true : false
}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "parent" {
  display_name = var.parent_management_group_display_name
  name         = local.parent ? var.parent_management_group_id : data.azurerm_subscription.current.tenant_id
}

module "mg1" {
  source   = "./modules/mg1"
  for_each = var.management_groups

  level                      = 1
  display_name               = each.key
  parent_management_group_id = data.azurerm_management_group.parent.id
  children                   = each.value
}
