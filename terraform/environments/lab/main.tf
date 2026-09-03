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
  use_cli   = true
}
