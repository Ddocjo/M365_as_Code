variable "eligible_role_display_name" {
  description = "Friendly name of the privileged role (e.g., 'Global Administrator')"
  type        = string
}

variable "principal_id" {
  description = "Object ID of the user or group receiving role eligibility"
  type        = string
}

variable "justification" {
  description = "Auditable justification for the eligible role assignment request"
  type        = string
  default     = "Lab helpdesk PIM eligibility"
}
