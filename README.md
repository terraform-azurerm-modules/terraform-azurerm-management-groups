# terraform-azurerm-management-groups

⚠️ Note that we highly recommend the official Microsoft Terraform modules.

* <https://aka.ms/alz/tf> - Official Microsoft Terraform module for Azure Landing Zones
* <https://aka.ms/alz/tf/wiki> - Wiki with instructions for use

## Overview

This v0.13 module creates a nested Azure Management Group structure using a simple and dense input object.

For an overview, please read the [Management Groups](https://docs.microsoft.com/azure/governance/management-groups/overview) documentation.

The default value for the input structure is based on [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale).

The input object has `type = any` for greater flexibility, including a mix and match of children and optional `display_name` attributes at the same scope points. There is currently no use of type constraints or variable validation in this object.

> Note that the management group name must contain only ASCII letters, digits, numbers, _, -, (, ) .

The main key names map to the created Management Group `name` property. This cannot be changed once created. The `display_name` property can be optionally specified if you would like it to be different than the name.

The output is a deep object with multiple nesting designed so that is can be used with expressions that are very human readable. See below for more details.

## Example Use

It is very simple to get the management groups deployed:

```terraform
provider "azurerm" {
  features {}
}

module "management_groups" {
  source = "github.com/terraform-azurerm-modules/terraform-azurerm-management-groups?ref=v0.2.0"

  subscription_to_mg_csv_data  = csvdecode(file("subs.csv"))

  management_groups = {
    "Contoso" = {
      "LandingZones" = {
        display_name   = "Landing Zones"
        "Corp"         = {},
        "Online"       = {}
      },
      "Platform" = {
        "Management"   = {},
        "Connectivity" = {},
        "Identity"     = {},
      },
      "Sandbox"        = {},
      "Decommissioned" = {}
    }
  }
}
```

It is recommended to use names without spaces, and to be consistent in capitalisation formats.

### Managing Subscriptions in Management Groups

A simple CSV file is used to provide the mapping of subscription IDs to management group names. As an example:

```csv
subId,mgName
e94d25de-c27a-4ed9-9868-ce06a34a6b8b,Corp
a4666b85-0dcf-452b-94c8-e0e63c31b03b,Online
a4012b85-0bad-452b-1976-e0e5a11fe3ab,Online
876b13ab-1386-4977-83f8-468511349907,Identity
6a1c057a-11ce-4df1-8036-cd6661a82d27,Connectivity
```
The module will check for duplicate subscription IDs in the file and fail at the plan stage if found.

### Parent

The default parent is the root tenant group.

You can specify an alternate parent management group using:

* parent_management_group_name

## Permissions

> _Note that this sections needs validation, and is only represents current understanding._

Anyone with Owner or Contributor access on a subscription in that tenant can create the management groups themselves.

Adding roles to management groups initially requires elevation from the Global Admin.

Adding a subscription_id into a management group requires both:

* `Microsoft.Authorization/roleAssignments` on the subscription (i.e. Owner or User Access Administrator)
* `Microsoft.Management/managementGroups` on the management group (i.e. Management Group Contributor)

Adding an RBAC role assignment to a management group requires:

* `Microsoft.Authorization/roleAssignments` on the subscription (i.e. Owner or User Access Administrator)

Adding a policy or policy set definition requires:

* `Microsoft.Authorization/policyassignments` (i.e. Owner, Contributor, Resource Policy Contributor)

References:

* <https://docs.microsoft.com/azure/governance/management-groups/overview>
* <https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner>
* <https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor>
* <https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator>
* <https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#management-group-contributor>
* <https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#resource-policy-contributor>

## Import an existing Management Group into Terraform State

You may find yourself in a scenario where a Management Group may already exist that you want to manage with this module in your hierarchy.

A common example of this scenario is where you are not permitted to have permissions on the Tenant Root Scope "/", but the department/user with those permissions, or they can elevate into that permission, may be willing to create your top level Management Group and assign you permissions upon it. This would enable you to only create the hierarchy from this manually created Management Group level and downwards in the scope, without having any permissions over other hierarchies within the Tenant or permissions over the entire Tenant; this is very common in large enterprise deployments.

Using the same example usage of this module from [above](#example-use), lets assume the **"Contoso"** top level Management Group in the defined hierarchy has been manually created outside of your Terraform code, and therefore not present in your Terraform state file. So before you can run Terraform Plan & Apply to create your required hierarchy you need to import the existing Management Group into your Terraform State file using the ```terraform import``` command.

> You need to have your Terraform backend configured and Terraform initialised (init) before doing the below import!

An example of how use ```terraform import``` to import the **"Contoso"** Management Group based on the above example is shown below using PowerShell (including PowerShell Core):

```powershell

terraform import 'module.management_groups.module.mg1[\"Contoso\"].azurerm_management_group.mg' /providers/Microsoft.Management/managementGroups/Contoso

```

> Please note the character escaping required around the **"Contoso"** Management Group due to using PowerShell. Further information for other OS's can be found [here](https://www.terraform.io/docs/cli/commands/import.html#example-import-into-resource-configured-with-for_each).

## Recommendation

The recommended approach is to have the AAD Global Admin elevate their access and create a single top level management group to represent the organisation. The Global Admin can also add the required RBAC role assignments: for the security principal to create role assignments, policy assignments etc.

Once that is done then either the name or id can be used as a module argument.

## Module output in use

The output includes both nested objects keyed on the display name and also an array called my that contains the same information again. This makes the output very flexible, but also means that the full output object can become very large when the management group structure becomes deep.

### Management Group Names

Here are a few example module output expressions, finding the resource ID of a specific management group:

```terraform
data "azurerm_client_config" "example" {}

resource "azurerm_role_assignment" "example" {
  scope                = module.management_groups.output.Platform.Connectivity.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_role_assignment" "example2" {
  scope                = module.management_groups.output["LandingZones"].Corp.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_role_assignment" "example3" {
  scope                = module.management_groups.output["LandingZones"]["Online"]["Non-Prod"].id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.example.object_id
}
```

## Output

The module creates a nested output object called "output". THis output is subject to breaking change before productionisation.

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

You can see the last two used in the examples above.


## Warnings

Lifecycle ignore is switched on for subscription_ids. There is currently no ability to dynamically control whether they are ignored or not.

There is an upcoming azurerm_management_group_subscription_association resource. Once available, this module will be simplified to use it.

The output may be subject to breaking change based on any feedback and issues during the pre-release phase.
