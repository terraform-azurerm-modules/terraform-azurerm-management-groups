terraform {
  required_version = ">= 0.13.0"
}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "tenant_root_group" {
  name = data.azurerm_subscription.current.tenant_id
}

module "mg1" {
  source   = "./modules/mg1"
  for_each = var.management_groups

  level                      = 1
  display_name               = each.key
  parent_management_group_id = data.azurerm_management_group.tenant_root_group.id
  children                   = each.value
}
