locals {
  display_name = lookup(var.children, "display_name", var.name)

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
