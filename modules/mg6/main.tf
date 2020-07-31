variable "level" {
  type = number
}

variable "display_name" {}

variable "parent_management_group_id" {}

variable "children" {
  type = map

  validation {
    condition     = length(var.children) == 0 || keys(var.children) == "ami-"
    error_message = "The maximum depth for a management group hierarchy is 6."
  }
}

locals {
  subscription_ids = flatten([
    for key, value in var.children :
    key == "subscription_ids" ? toset(value) : []
  ])

  /*
  children = {
    for key, value in var.children :
    key => value if key != "subscription_ids"
  }

  next_level = var.level + 1
*/
}

resource "azurerm_management_group" "mg" {
  display_name               = var.display_name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = local.subscription_ids
}

/*
module "mg7" {
  source   = "../mg7"
  for_each = local.children // var.level + 1 == 2 ? local.children : {}

  level                      = local.next_level
  display_name               = each.key
  parent_management_group_id = azurerm_management_group.mg.id
  children                   = each.value
}
*/

output "management_groups" {
  value = [
    merge(azurerm_management_group.mg, { level = var.level })
  ]
}

output "management_group_id" {
  value ={
    id = azurerm_management_group.mg.id
  }
}