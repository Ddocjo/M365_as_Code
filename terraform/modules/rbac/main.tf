terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0"
    }
  }
}

resource "azuread_group" "this" {
  display_name     = var.group_name
  mail_nickname    = replace(lower(var.group_name), " ", "-")
  description      = var.description
  security_enabled = true
}

resource "azuread_group_member" "members" {
  for_each         = toset(var.members)
  group_object_id  = azuread_group.this.object_id
  member_object_id = each.value
}

/*
Note: Assigning directory roles via Terraform is provider-dependent. Some role
assignments require use of Microsoft Graph APIs or provider features that may
not yet exist. Prefer assigning roles to groups (as above) and managing role
assignments via documented scripts or provider resources when available.
*/
