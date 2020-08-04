# terraform-azurerm-management-groups

This v0.13 module to create a nested Azure Management Group structure using a simple and dense input object.

For an overview, please read the [Management Groups](https://docs.microsoft.com/azure/governance/management-groups/overview) documentation.

The default value for the input structure is based on [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale).

The input object has `type = any` for greater flexibility, including a mix and match of children and subscription ID lists at the same scope points. There is currently no use of type constraints or variable validation.

The output is a deep object with multiple nesting designed so that is can be used with expressions that are very human readable. See below for more details.

## Example Use

It is very simple to get the management groups deployed:

```terraform
module "management_groups" {
  source                = "github.com/terraform-azurerm-modules/terraform-azurerm-management-groups?ref=v0.1.2"

  parent_management_group_display_name = "Contoso
"

  management_groups = {
    "Landing Zones" = {
      "Corp" = {
        "Prod"     = {},
        "Non-Prod" = {},
      },
      "Online"  = {
        "Prod"     = {},
        "Non-Prod" = {},
      }
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
```

## Named Parent v Root Tenant Group

The recommended approach is to have the AAD Global Admin elevate their access and create a single top level management group to represent the organisation. (Named parent.)

Once that is done then either the name or id can be used as a module argument. Management groups can then be created by anyone with Owner, Contributor or Management Group Contributor role.

You can use the module as an elevated user and create directly under the Root Tenant Group.

See the <https://docs.microsoft.com/azure/governance/management-groups/overview> page for more info.

## Output

The module creates a nested output object called "output".

The object can become very large when there are multiple levels, so the example output below has been truncated to only show the output for the Platform section.

```terraform
{
  "Platform" = {
    "Connectivity" = {
      "children" = []
      "display_name" = "Connectivity"
      "group_id" = "635c4cb7-0b62-4a3f-86e7-4412144e9546"
      "id" = "/providers/Microsoft.Management/managementGroups/635c4cb7-0b62-4a3f-86e7-4412144e9546"
      "mg" = []
      "name" = "635c4cb7-0b62-4a3f-86e7-4412144e9546"
      "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
      "subscription_ids" = [
        "2d31be49-d959-4415-bb65-8aec2c90ba62",
      ]
    }
    "Identity" = {
      "children" = []
      "display_name" = "Identity"
      "group_id" = "d09be029-bf85-48ef-8f31-f4366bf4f824"
      "id" = "/providers/Microsoft.Management/managementGroups/d09be029-bf85-48ef-8f31-f4366bf4f824"
      "mg" = []
      "name" = "d09be029-bf85-48ef-8f31-f4366bf4f824"
      "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
      "subscription_ids" = []
    }
    "Management" = {
      "children" = []
      "display_name" = "Management"
      "group_id" = "7b7f2734-9ab0-4a96-960d-74231dd53318"
      "id" = "/providers/Microsoft.Management/managementGroups/7b7f2734-9ab0-4a96-960d-74231dd53318"
      "mg" = []
      "name" = "7b7f2734-9ab0-4a96-960d-74231dd53318"
      "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
      "subscription_ids" = []
    }
    "children" = [
      "Connectivity",
      "Identity",
      "Management",
    ]
    "display_name" = "Platform"
    "group_id" = "4dfaecd8-4323-415a-9090-351cc36e74eb"
    "id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
    "mg" = [
      {
        "children" = []
        "display_name" = "Connectivity"
        "group_id" = "635c4cb7-0b62-4a3f-86e7-4412144e9546"
        "id" = "/providers/Microsoft.Management/managementGroups/635c4cb7-0b62-4a3f-86e7-4412144e9546"
        "mg" = []
        "name" = "635c4cb7-0b62-4a3f-86e7-4412144e9546"
        "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
        "subscription_ids" = [
          "2d31be49-d959-4415-bb65-8aec2c90ba62",
        ]
      },
      {
        "children" = []
        "display_name" = "Identity"
        "group_id" = "d09be029-bf85-48ef-8f31-f4366bf4f824"
        "id" = "/providers/Microsoft.Management/managementGroups/d09be029-bf85-48ef-8f31-f4366bf4f824"
        "mg" = []
        "name" = "d09be029-bf85-48ef-8f31-f4366bf4f824"
        "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
        "subscription_ids" = []
      },
      {
        "children" = []
        "display_name" = "Management"
        "group_id" = "7b7f2734-9ab0-4a96-960d-74231dd53318"
        "id" = "/providers/Microsoft.Management/managementGroups/7b7f2734-9ab0-4a96-960d-74231dd53318"
        "mg" = []
        "name" = "7b7f2734-9ab0-4a96-960d-74231dd53318"
        "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/4dfaecd8-4323-415a-9090-351cc36e74eb"
        "subscription_ids" = []
      },
    ]
    "name" = "4dfaecd8-4323-415a-9090-351cc36e74eb"
    "parent_management_group_id" = "/providers/Microsoft.Management/managementGroups/contoso"
    "subscription_ids" = []
  }
}
```

In terms of child objects, you have a choice of using:

* **children**: A list of names
* **mg** array of child objects, useful for splat operations
* (**$names**) - individual named maps for each child object, e.g. Identity, Connectivity and Management above.

You can see the last two in use below.

## Module Output In Use

Some examples of usage:

```terraform
data "azurerm_client_config" "example" {}

resource "azurerm_role_assignment" "example" {
  scope                = module.management_groups.output.Platform.Connectivity.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_role_assignment" "example2" {
  scope                = module.management_groups.output["Landing Zones"].Corp.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_role_assignment" "example3" {
  scope                = module.management_groups.output["Landing Zones"]["Online"]["Non-Prod"].id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_role_assignment" "example4" {
  for_each = {
    for scope in module.management_groups.output["Landing Zones"].mg[*].Prod.id :
    basename(scope) => scope
  }

  role_definition_name = "Reader"
  scope                = each.value
  principal_id         = data.azurerm_client_config.example.object_id
}
```

## Warnings

There is no lifecycle ignore for subscription_ids. There is no ability to dynamically control whether they are ignored or not.
