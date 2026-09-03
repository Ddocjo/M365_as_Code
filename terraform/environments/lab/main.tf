/*
  Lab environment Terraform entrypoint (placeholder).
  Populate with provider configuration, backend, and module calls.
*/

terraform {
  required_version = ">= 1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azuread" {
  tenant_id = "aa1b4236-34f9-42df-98b3-aff54bb466f0"
  # Temporary bootstrap authentication only. Steady-state CI uses the app's OIDC identity.
  use_cli = true
}

module "terraform_automation_app" {
  source         = "../../modules/applications"
  github_subject = "repo:Ddocjo@52788963/M365_as_Code@1355411564:ref:refs/heads/main"
}

output "automation_client_id" {
  description = "Client ID for the Terraform automation app; store as GitHub AZURE_CLIENT_ID"
  value       = module.terraform_automation_app.client_id
}
