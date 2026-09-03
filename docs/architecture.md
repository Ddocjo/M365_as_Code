# Architecture

The target flow is Git desired state -> GitHub Actions -> Microsoft Graph / Entra ->
audit polling and drift correlation -> reviewable alert -> human-approved Terraform remediation.

The MVP starts with Conditional Access, RBAC/PIM, and audit polling. Tenant-dependent
authentication and destructive actions remain disabled until explicitly enabled.

## Existing tenant safety boundary

Existing users, groups, and policies are discovery inputs, not automatic Terraform
resources. The `Break Glass` group is protected and must remain unmanaged. Its current
membership is deliberately not stored in this public repository. Any future inventory
or plan check must fail closed if that group or one of its members is targeted.