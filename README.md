# terraform-azurerm-management-groups

This v0.13 module to create a nested Azure Management Group structure using a simple object. The default structure is based on [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale).

Note that this module is subject to breaking change as the management_groups variable structure may be changed to a more formal type constrained nested object.

Note also that the format forces unique displayNames.

## Usage

### Deploying the Definitions

It is very simple to get the management groups deployed:

```terraform
module "management_groups" {
  source                = "github.com/terraform-azurerm-modules/terraform-azurerm-management-groups?ref=v0.1.1"

  management_groups = {
    "Contoso" = {
      "Landing Zones" = {
        "Corp" = {},
        "Online"  = {}
      },
      "Platform" = {
        "Management" = {
          "subscription_ids" = ["2ca40be1-7e80-4f2b-92f7-06b2123a68cc"]
        },
        "Connectivity"  = {
          "subscription_ids" = ["2d31be49-d959-4415-bb65-8aec2c90ba62"]
        },
        "Identity"  = {
          "subscription_ids" = ["9a52c25a-b883-437e-80a6-ff4c2bccd44e"]
        },
      }
    }
  }
}
```

### Using the Output

The module creates a nested output object called "output".

Example output:

```terraform
{
  "Contoso" = {
    "children" = [
      {
        "name" = {
          "children" = [
            {
              "name" = {
                "children" = []
                "display_name" = "Corp"
                "group_id" = "41459b7c-7fc0-4799-a624-ee7996767be4"
                "id" = "/providers/Microsoft.Management/managementGroups/41459b7c-7fc0-4799-a624-ee7996767be4"
                "level" = 3
                "name" = "41459b7c-7fc0-4799-a624-ee7996767be4"
                "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/972dc068-d460-486a-be0f-4ec53615df9c"
              }
            },
            {
              "name" = {
                "children" = []
                "display_name" = "Online"
                "group_id" = "ba46658d-8528-4af7-9c08-206d1a0168e1"
                "id" = "/providers/Microsoft.Management/managementGroups/ba46658d-8528-4af7-9c08-206d1a0168e1"
                "level" = 3
                "name" = "ba46658d-8528-4af7-9c08-206d1a0168e1"
                "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/972dc068-d460-486a-be0f-4ec53615df9c"
              }
            },
          ]
          "display_name" = "Landing Zones"
          "group_id" = "972dc068-d460-486a-be0f-4ec53615df9c"
          "id" = "/providers/Microsoft.Management/managementGroups/972dc068-d460-486a-be0f-4ec53615df9c"
          "level" = 2
          "name" = "972dc068-d460-486a-be0f-4ec53615df9c"
          "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/9813ee40-5887-4da4-bf96-aa85d03af9b0"
        }
      },
      {
        "name" = {
          "children" = [
            {
              "name" = {
                "children" = ["2d31be49-d959-4415-bb65-8aec2c90ba62"]
                "display_name" = "Connectivity"
                "group_id" = "fd9ba85e-80ae-4592-a64d-c580b99475fb"
                "id" = "/providers/Microsoft.Management/managementGroups/fd9ba85e-80ae-4592-a64d-c580b99475fb"
                "level" = 3
                "name" = "fd9ba85e-80ae-4592-a64d-c580b99475fb"
                "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
              }
            },
            {
              "name" = {
                "children" = ["9a52c25a-b883-437e-80a6-ff4c2bccd44e"]
                "display_name" = "Identity"
                "group_id" = "d4c4a4c4-1366-446c-af2f-57c3a972a111"
                "id" = "/providers/Microsoft.Management/managementGroups/d4c4a4c4-1366-446c-af2f-57c3a972a111"
                "level" = 3
                "name" = "d4c4a4c4-1366-446c-af2f-57c3a972a111"
                "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
              }
            },
            {
              "name" = {
                "children" = ["2ca40be1-7e80-4f2b-92f7-06b2123a68cc"]
                "display_name" = "Management"
                "group_id" = "cd7eca97-9698-47fa-a6c6-45a680a74c06"
                "id" = "/providers/Microsoft.Management/managementGroups/cd7eca97-9698-47fa-a6c6-45a680a74c06"
                "level" = 3
                "name" = "cd7eca97-9698-47fa-a6c6-45a680a74c06"
                "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
              }
            },
          ]
          "display_name" = "Platform"
          "group_id" = "ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
          "id" = "/providers/Microsoft.Management/managementGroups/ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
          "level" = 2
          "name" = "ad5234b6-8dec-47bb-b1e6-6f8af8826d6c"
          "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/9813ee40-5887-4da4-bf96-aa85d03af9b0"
        }
      },
    ]
    "display_name" = "Contoso"
    "group_id" = "9813ee40-5887-4da4-bf96-aa85d03af9b0"
    "id" = "/providers/Microsoft.Management/managementGroups/9813ee40-5887-4da4-bf96-aa85d03af9b0"
    "level" = 1
    "name" = "9813ee40-5887-4da4-bf96-aa85d03af9b0"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/f246eeb7-b820-4971-a083-9e100e084ed0"
  }
}
```

Example usage:

```terraform
data "azurerm_client_config" "example" {}

resource "azurerm_role_assignment" "example" {
  scope                = module.management_groups.ids["Contoso"].Platform.Connectivity.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}
```
