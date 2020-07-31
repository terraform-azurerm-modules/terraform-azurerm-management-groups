# terraform-azurerm-management-groups

This v0.13 module to create a nested Azure Management Group structure using a simple object. The default structure is based on [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale).

Note that this module is subject to breaking change as the management_groups variable structure may be changed to a more formal type constrained nested object.

## Usage

### Deploying the Definitions

It is very simple to get the management groups deployed:

```terraform
module "management_groups" {
  source                = "github.com/terraform-azurerm-modules/terraform-azurerm-management-groups?ref=v0.1.0"

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

### Using the Outputs

The module creates two outputs, "ids" and "list".

#### module.management_groups.ids

```json
{
  "Contoso" = {
    "Landing Zones" = {
      "Corp" = {
        "id" = "/providers/Microsoft.Management/managementGroups/76428ee7-e18a-4367-adfd-5c633b488560"
      }
      "Online" = {
        "id" = "/providers/Microsoft.Management/managementGroups/4b172ada-d1f3-4aac-8ccf-bea78c7fc702"
      }
      "id" = "/providers/Microsoft.Management/managementGroups/3d101328-1d96-4fa9-a232-0c31d3c59508"
    }
    "Platform" = {
      "Connectivity" = {
        "id" = "/providers/Microsoft.Management/managementGroups/be645ba3-62c5-4947-8daa-f93e6ca35e68"
      }
      "Identity" = {
        "id" = "/providers/Microsoft.Management/managementGroups/88e5dbf5-9e25-4fe4-9d3e-4a587ce15395"
      }
      "Management" = {
        "id" = "/providers/Microsoft.Management/managementGroups/2d9cb7ad-8c6d-4aea-9833-9df1ed70a1b2"
      }
      "id" = "/providers/Microsoft.Management/managementGroups/e7c41542-1ead-4de7-b798-033d521a2cd1"
    }
    "id" = "/providers/Microsoft.Management/managementGroups/e5b16442-a829-4891-83fe-bca2550b0040"
  }
}
```

Example usage:

```terraform
data "azurerm_client_config" "example" {}

resource "azurerm_role_assignment" "example" {
  scope                = module.management_groups.ids["Contoso"].Platform.Connectivity
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}
```

#### module.management_groups.set

This output is a flattened set, providing the full output

```json
[
  {
    "display_name" = "Contoso"
    "group_id" = "e5b16442-a829-4891-83fe-bca2550b0040"
    "id" = "/providers/Microsoft.Management/managementGroups/e5b16442-a829-4891-83fe-bca2550b0040"
    "level" = 1
    "name" = "e5b16442-a829-4891-83fe-bca2550b0040"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/f246eeb7-b820-4971-a083-9e100e084ed0"
    "subscription_ids" = []
  },
  {
    "display_name" = "Landing Zones"
    "group_id" = "3d101328-1d96-4fa9-a232-0c31d3c59508"
    "id" = "/providers/Microsoft.Management/managementGroups/3d101328-1d96-4fa9-a232-0c31d3c59508"
    "level" = 2
    "name" = "3d101328-1d96-4fa9-a232-0c31d3c59508"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/e5b16442-a829-4891-83fe-bca2550b0040"
    "subscription_ids" = []
  },
  {
    "display_name" = "Corp"
    "group_id" = "76428ee7-e18a-4367-adfd-5c633b488560"
    "id" = "/providers/Microsoft.Management/managementGroups/76428ee7-e18a-4367-adfd-5c633b488560"
    "level" = 3
    "name" = "76428ee7-e18a-4367-adfd-5c633b488560"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/3d101328-1d96-4fa9-a232-0c31d3c59508"
    "subscription_ids" = []
  },
  {
    "display_name" = "Online"
    "group_id" = "4b172ada-d1f3-4aac-8ccf-bea78c7fc702"
    "id" = "/providers/Microsoft.Management/managementGroups/4b172ada-d1f3-4aac-8ccf-bea78c7fc702"
    "level" = 3
    "name" = "4b172ada-d1f3-4aac-8ccf-bea78c7fc702"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/3d101328-1d96-4fa9-a232-0c31d3c59508"
    "subscription_ids" = []
  },
  {
    "display_name" = "Platform"
    "group_id" = "e7c41542-1ead-4de7-b798-033d521a2cd1"
    "id" = "/providers/Microsoft.Management/managementGroups/e7c41542-1ead-4de7-b798-033d521a2cd1"
    "level" = 2
    "name" = "e7c41542-1ead-4de7-b798-033d521a2cd1"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/e5b16442-a829-4891-83fe-bca2550b0040"
    "subscription_ids" = []
  },
  {
    "display_name" = "Connectivity"
    "group_id" = "be645ba3-62c5-4947-8daa-f93e6ca35e68"
    "id" = "/providers/Microsoft.Management/managementGroups/be645ba3-62c5-4947-8daa-f93e6ca35e68"
    "level" = 3
    "name" = "be645ba3-62c5-4947-8daa-f93e6ca35e68"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/e7c41542-1ead-4de7-b798-033d521a2cd1"
    "subscription_ids" = [
      "2ca40be1-7e80-4f2b-92f7-06b2123a68cc",
    ]
  },
  {
    "display_name" = "Identity"
    "group_id" = "88e5dbf5-9e25-4fe4-9d3e-4a587ce15395"
    "id" = "/providers/Microsoft.Management/managementGroups/88e5dbf5-9e25-4fe4-9d3e-4a587ce15395"
    "level" = 3
    "name" = "88e5dbf5-9e25-4fe4-9d3e-4a587ce15395"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/e7c41542-1ead-4de7-b798-033d521a2cd1"
    "subscription_ids" = [
      "2d31be49-d959-4415-bb65-8aec2c90ba62",
    ]
  },
  {
    "display_name" = "Management"
    "group_id" = "2d9cb7ad-8c6d-4aea-9833-9df1ed70a1b2"
    "id" = "/providers/Microsoft.Management/managementGroups/2d9cb7ad-8c6d-4aea-9833-9df1ed70a1b2"
    "level" = 3
    "name" = "2d9cb7ad-8c6d-4aea-9833-9df1ed70a1b2"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/e7c41542-1ead-4de7-b798-033d521a2cd1"
    "subscription_ids" = [
      "9a52c25a-b883-437e-80a6-ff4c2bccd44e",
    ]
  },
]
```

Example usage:

```terraform
locals {
  platform_management_group_id =
}
```