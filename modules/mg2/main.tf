locals {
  display_name = lookup(var.children, "display_name", var.name)

  children = {
    for key, value in var.children :
    key => value if key != "display_name"
  }

  next_level = var.level + 1

  subscription_ids = keys({
    for s in var.subscription_to_mg_csv_data :
    s.subId => s.mgName if s.mgName == var.name
  })
}

resource "azurerm_management_group" "mg" {
  display_name               = local.display_name
  name                       = var.name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = local.subscription_ids
}

module "mg3" {
  source   = "../mg3"
  for_each = local.children // var.level + 1 == 2 ? local.children : {}

  subscription_to_mg_csv_data = var.subscription_to_mg_csv_data
  level                       = local.next_level
  name                        = each.key
  parent_management_group_id  = azurerm_management_group.mg.id
  children                    = each.value
}
