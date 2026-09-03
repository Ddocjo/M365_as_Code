# Architecture

The target flow is Git desired state -> GitHub Actions -> Microsoft Graph / Entra ->
audit polling and drift correlation -> reviewable alert -> human-approved Terraform remediation.

The MVP starts with Conditional Access, RBAC/PIM, and audit polling. Tenant-dependent
authentication and destructive actions remain disabled until explicitly enabled.