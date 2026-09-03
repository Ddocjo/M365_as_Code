module "lab_pim" {
  source                     = "../../modules/pim"
  eligible_role_display_name = "Helpdesk Administrator"
  principal_id               = data.azuread_user.helpdesk.object_id
  justification              = "Lab helpdesk role eligibility"
}
