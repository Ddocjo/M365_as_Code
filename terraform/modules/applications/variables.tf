variable "application_name" {
  description = "Display name of the tenant-owned Terraform automation application"
  type        = string
  default     = "sp-m365-terraform-lab"
}

variable "github_subject" {
  description = "Exact GitHub OIDC subject permitted to authenticate"
  type        = string
}
