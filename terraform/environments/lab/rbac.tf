data "azuread_user" "helpdesk" {
  user_principal_name = "ru.test@saberboy.xyz"
}

module "lab_helpdesk_group" {
  source      = "../../modules/rbac"
  group_name  = "grp-helpdesk-lab-global"
  description = "Lab helpdesk group; membership managed by Terraform"
  members     = [data.azuread_user.helpdesk.object_id]
}
