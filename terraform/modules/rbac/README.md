
# RBAC module

Creates Azure AD groups and manages group membership. Prefer assigning directory
roles to groups rather than individuals. Directory role assignment support may
require additional provider features or scripts; see `pim` module for PIM
recommendations.

Inputs
- `group_name` - display name for the group
- `description` - group description
- `members` - list of Azure AD object IDs to add as members
- `owners` - list of Azure AD object IDs to mark as owners (future)

Outputs
- `group_id` - the object id of the created group

Usage
See `terraform/environments/lab/rbac.tf` for an example invocation.

Break-glass guidance
- Do NOT include break-glass accounts (for example `vimboc@saberboy.onmicrosoft.com`) in the `members` or `owners` inputs. Break-glass identities must remain unmanaged by Terraform and excluded from automated remediation or membership churn.


