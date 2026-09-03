resource "azuread_application" "this" {
  display_name           = var.application_name
  sign_in_audience       = "AzureADMyOrg"
  prevent_duplicate_names = true
  notes                  = "Terraform-only M365 lab automation identity; no client secrets"
  tags                   = ["m365-as-code", "terraform-managed", "lab"]
}

resource "azuread_service_principal" "this" {
  client_id                    = azuread_application.this.client_id
  account_enabled              = true
  app_role_assignment_required = false
  notes                        = "Managed by Terraform; authenticate through GitHub Actions OIDC"
}

resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.this.id
  display_name   = "github-main-m365-as-code"
  description    = "Trust GitHub Actions from the main branch of Ddocjo/M365_as_Code"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = var.github_subject
}