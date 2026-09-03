output "group_id" {
  description = "The object id of the created Azure AD group"
  value       = azuread_group.this.id
}
