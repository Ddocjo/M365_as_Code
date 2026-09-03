output "application_id" {
  description = "Object ID of the automation application"
  value       = azuread_application.this.id
}

output "client_id" {
  description = "Client ID to store as the GitHub AZURE_CLIENT_ID secret"
  value       = azuread_application.this.client_id
}

output "service_principal_id" {
  description = "Object ID of the automation service principal"
  value       = azuread_service_principal.this.id
}