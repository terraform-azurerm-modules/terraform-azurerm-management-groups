output "output" {
  value = merge(azurerm_management_group.mg,
    {
      children = keys(local.children)
    },
    {
      mg = [
        for name, _ in local.children :
        module.mg5[name].output
      ]
    },
    {
      for name, _ in local.children :
      (name) => module.mg5[name].output
    }
  )
}
