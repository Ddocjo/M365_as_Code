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

The lab helpdesk test uses `ru.test@saberboy.xyz` by explicit decision. Discovery
found an existing eligible PIM assignment for this user, so the test must preserve
that assignment and must not claim the user is unprivileged. The new helpdesk group
and any additional Helpdesk Administrator eligibility are separate, reviewable changes.

PIM is currently deferred because reliable Terraform support for eligible
assignments and activation policies is not available for this lab. The project
uses no Graph or shell fallback; it moves to the next Terraform-supported capability.

The dedicated automation identity is tenant-owned and Terraform-managed. A
one-time bootstrap may use an administrator session to create it, but steady-state
GitHub Actions uses its repository-scoped OIDC credential and no personal CLI login.