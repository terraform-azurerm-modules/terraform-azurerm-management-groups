terraform {
  required_version = ">= 0.13.0"
}

data "azurerm_subscription" "current" {}

locals {
  parent               = var.parent_management_group_display_name != null || var.parent_management_group_id != null ? true : false
  tenant_root_group_id = "/providers/Microsoft.Management/managementGroups/${data.azurerm_subscription.current.tenant_id}"
}


data "azurerm_management_group" "parent" {
  for_each     = toset(local.parent ? ["Named"] : [])
  display_name = var.parent_management_group_display_name
  name         = var.parent_management_group_id
}

module "mg1" {
  source   = "./modules/mg1"
  for_each = var.management_groups

  level                      = 1
  display_name               = each.key
  parent_management_group_id = local.parent ? data.azurerm_management_group.parent["Named"].id : local.tenant_root_group_id
  children                   = each.value
}
