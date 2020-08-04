output "output" {
  value = merge(azurerm_management_group.mg,
    {
      children = keys(local.children)
    },
    {
      mg = [
        for name, _ in local.children :
        module.mg3[name].output
      ]
    },
    {
      for name, _ in local.children :
      (name) => module.mg3[name].output
    }
  )
}
