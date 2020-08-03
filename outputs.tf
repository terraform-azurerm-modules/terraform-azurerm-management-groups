/*
output "list" {
  value = flatten([
    for name, _ in var.management_groups :
    module.mg1[name].management_groups
  ])
}

output "ids" {
  value = {
    for name, _ in var.management_groups :
    name => module.mg1[name].management_group_id
  }
}
*/

output "output" {
  value = {
    for name, _ in var.management_groups :
    name => module.mg1[name].output
  }
}
