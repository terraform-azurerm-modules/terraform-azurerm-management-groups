locals {
  subscription_ids = flatten([
    for key, value in var.children :
    key == "subscription_ids" ? toset(value) : []
  ])

  children = {
    for key, value in var.children :
    key => value if key != "subscription_ids"
  }

  next_level = var.level + 1
}

resource "azurerm_management_group" "mg" {
  display_name               = var.display_name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = local.subscription_ids
}

module "mg2" {
  source   = "../mg2"
  for_each = local.children // var.level + 1 == 2 ? local.children : {}

  level                          = local.next_level
  display_name                   = each.key
  parent_management_group_id     = azurerm_management_group.mg.id
  children                       = each.value
}
