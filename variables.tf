variable "parent_management_group_name" {
  // The scope at which to create the management groups
  // If unspecified then will default to root tenant group, but this requires special permissions
  // <https://docs.microsoft.com/azure/governance/management-groups/overview>

  type    = string
  default = null
}

variable "subscription_to_mg_csv_data" {
  // This variable should be the csvdecode() output of a two column CSV file, e.g.:
  // subId,mgName
  // 167d4f7a-0484-44f1-a84f-93f07ff3c798,ES-LandingZones

  type    = any
  default = null
}

variable "management_groups" {
  // This will error if any scope contains both a) one of more child management groups and b) an array of subscription IDs
  // The map structure is flexible, but the entities at any level must all be the same type

  type = any

  // The keys in this object are the Management Group name.
  // The name can only be an ASCII letter, digit, -, _, (, )
  // Specifying display_name is optional. If omitted the name is used.

  default = {
    "ES" = {
      display_name = "ES"
      "ES-LandingZones" = {
        display_name = "LandingZones"
        "ES-Corp" = {
          display_name = "Corp"
        },
        "ES-Online" = {
          display_name = "Online"
        }
      },
      "ES-Platform" = {
        display_name = "Platform"
        "ES-Management" = {
          display_name = "Management"
        },
        "ES-Connectivity" = {
          display_name = "Connectivity"
        },
        "ES-Identity" = {
          display_name = "Identity"
        },
      }
    }
  }
}
