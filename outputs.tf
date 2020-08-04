output "output" {
  value = {
    for name, _ in var.management_groups :
    name => module.mg1[name].output
  }
}
