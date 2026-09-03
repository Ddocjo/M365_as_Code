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
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "azuread" {
  # configure provider with OIDC/service principal for GitHub Actions
}
