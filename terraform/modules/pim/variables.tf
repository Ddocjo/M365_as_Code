variable "eligible_role_display_name" {
  description = "Friendly name of the privileged role (e.g., 'Global Administrator')"
  type        = string
}

variable "eligible_members" {
  description = "List of Azure AD object IDs (groups) that should be eligible for the role"
  type        = list(string)
  default     = []
}

variable "require_approval" {
  description = "Whether activation requires approval"
  type        = bool
  default     = true
}
