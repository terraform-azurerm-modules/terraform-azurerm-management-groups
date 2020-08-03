/*
output "management_groups" {
  value = [
    merge(azurerm_management_group.mg, { level = var.level })
  ]
}

output "management_group_id" {
  value = {
    id = azurerm_management_group.mg.id
  }
}
*/

output "output" {
  value = merge(azurerm_management_group.mg, { level = var.level })
}
