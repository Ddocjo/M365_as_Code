# PIM eligibility is managed with the provider-supported schedule request.
# Activation policy settings remain separate and are not changed here.
data "azuread_directory_role_templates" "all" {}

locals {
  matching_roles = [
    for role in data.azuread_directory_role_templates.all.role_templates : role
    if lower(role.display_name) == lower(var.eligible_role_display_name)
  ]
}

resource "azuread_directory_role_eligibility_schedule_request" "this" {
  count = length(local.matching_roles) == 1 ? 1 : 0

  role_definition_id = local.matching_roles[0].object_id
  principal_id       = var.principal_id
  directory_scope_id = "/"
  justification      = var.justification
}
