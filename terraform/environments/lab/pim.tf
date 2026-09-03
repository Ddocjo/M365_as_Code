module "lab_pim" {
  source                     = "../../modules/pim"
  eligible_role_display_name = "Global Administrator"
  eligible_members           = []
}
