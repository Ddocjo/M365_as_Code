terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

/*
  PIM/Tiered-Role Configuration Module (placeholder)

  NOTE: As of this scaffold, direct PIM configuration (eligible assignments,
  approval workflows) may not be fully supported via the Terraform AzureAD
  provider. This module provides a documented pattern and a `null_resource`
  hook to call scripts that use the Microsoft Graph API to perform actions
  that are not yet available in the provider.
*/

resource "null_resource" "pim_placeholder" {
  provisioner "local-exec" {
    command = "echo 'PIM configuration placeholder - implement Graph API calls or provider resources here'"
  }
}
