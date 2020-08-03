variable "management_groups" {
  type = map
  default = {
    "Contoso" = {
      "Landing Zones" = {
        "Corp"   = {},
        "Online" = {}
      },
      "Platform" = {
        "Management"   = {},
        "Connectivity" = {},
        "Identity"     = {},
      }
    }
  }

  validation {
    condition     = length(var.management_groups) == 1
    error_message = "This module expects only one management group at the top level under root tenant group."
  }
}
