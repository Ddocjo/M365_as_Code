module "lab_admins_group" {
  source      = "../../modules/rbac"
  group_name  = "grp-admins-lab-global"
  description = "Lab administrators group managed by Terraform"
  members     = [] # populate with Azure AD object IDs for service/test users
}
