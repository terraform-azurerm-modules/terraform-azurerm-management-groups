variable "parent_management_group_id" {
  // The scope at which to create the management groups
  // If unspecified then will default to root tenant group, but this requires special permissions
  // <https://docs.microsoft.com/azure/governance/management-groups/overview>

  type    = string
  default = null
}

variable "parent_management_group_display_name" {
  type    = string
  default = null
}

variable "management_groups" {
  // This will error if any scope contains both a) one of more child management groups and b) an array of subscription IDs
  // The map structure is flexible, but the entities at any level must all be the same type

  type = any

  default = {
    "Landing Zones" = {
      "Corp"   = {},
      "Online" = {}
    },
    "Platform" = {
      "Management" = {},
      "Connectivity" = {
        subscription_ids = ["2d31be49-d959-4415-bb65-8aec2c90ba62"]

      },
      "Identity" = {},
    }
  }
}
