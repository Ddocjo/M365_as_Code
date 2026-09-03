
# PIM module

This module manages a directory-role eligibility schedule request using the
Terraform AzureAD provider. It does not update or remove existing eligibility.

1. Create security groups and role assignments where supported (assign roles to groups).
2. Use `azuread_directory_role_eligibility_schedule_request` for supported
   eligible assignments.

The module resolves a built-in role by display name and creates an eligibility
request at tenant scope. Existing PIM state, including the selected user's
existing eligibility, remains unchanged.

Security notes
- Preserve all existing eligible assignments and do not update or remove existing PIM state.
- Activation approval, MFA, justification, and duration policy settings require
   separate provider resources; if unavailable, they remain deferred.

