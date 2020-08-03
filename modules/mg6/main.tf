locals {
  subscription_ids = flatten([
    for key, value in var.children :
    key == "subscription_ids" ? toset(value) : []
  ])
}

resource "azurerm_management_group" "mg" {
  display_name               = var.display_name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = local.subscription_ids
}
