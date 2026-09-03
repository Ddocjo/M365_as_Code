
# PIM module

This module documents the boundary for Privileged Identity Management (PIM).
Direct PIM resource support in Terraform is not sufficient for this lab. Per the
Terraform-only rule, unsupported PIM work is deferred; no Graph or shell fallback is used.

1. Create security groups and role assignments where supported (assign roles to groups).
2. Add PIM resources only when the selected Terraform provider reliably supports
   eligible assignments and activation policy requirements.

No PIM resource is currently invoked by the lab environment. Existing PIM state,
including the selected user's existing eligibility, must remain unchanged.

Security notes
- Preserve all existing eligible assignments and do not update or remove existing PIM state.

