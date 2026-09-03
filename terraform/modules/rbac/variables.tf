variable "group_name" {
  description = "Display name of the RBAC group"
  type        = string
}

variable "description" {
  description = "Group description"
  type        = string
  default     = ""
}

variable "members" {
  description = "List of member object IDs (Azure AD object IDs) to add to the group"
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of owner object IDs (Azure AD object IDs) for the group"
  type        = list(string)
  default     = []
}
