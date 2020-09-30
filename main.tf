terraform {
  required_version = ">= 0.13.0"
}

data "azurerm_subscription" "current" {}

locals {
  parent               = var.parent_management_group_name != null ? true : false
  tenant_root_group_id = "/providers/Microsoft.Management/managementGroups/${data.azurerm_subscription.current.tenant_id}"
  subscription_to_mg_csv_data_check = {
    // This local checks for duplicate subscription IDs in the CSV
    // It is not used in the plan but is useful to prevent failures on apply
    for s in var.subscription_to_mg_csv_data :
    s.subId => s.mgName
  }
}


data "azurerm_management_group" "parent" {
  for_each = toset(local.parent ? ["Named"] : [])
  name     = var.parent_management_group_name
}

module "mg1" {
  source   = "./modules/mg1"
  for_each = var.management_groups

  subscription_to_mg_csv_data = var.subscription_to_mg_csv_data
  level                       = 1
  name                        = each.key
  parent_management_group_id  = local.parent ? data.azurerm_management_group.parent["Named"].id : local.tenant_root_group_id
  children                    = each.value
}
