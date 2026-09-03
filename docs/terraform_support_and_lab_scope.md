# Terraform Provider Support & Lab Scope

This file summarizes which Microsoft 365 / Entra services have Terraform or API support today,
what we'll manage in this lab (MVP), and how we'll handle provider gaps.

## Provider Landscape (concise)
- **Entra ID / Azure AD**: `azuread` provider + Microsoft Graph provider. Good coverage for users, groups, app registrations, service principals, Administrative Units, and some role assignments.
- **Microsoft Graph (REST / provider)**: may expose tenant-level policies, but this project will not use Graph as an implementation fallback. Unsupported capabilities are deferred.
- **Intune**: partial support via Microsoft Graph (device compliance, some policy resources). Feature parity varies.
- **Exchange Online**: limited Terraform support; many mailbox and mailbox-settings operations require Exchange Online PowerShell or Graph API calls.
- **Teams**: manage app registrations, service principals, and some Teams resources via Graph; full policy/config support is evolving.
- **SharePoint**: site provisioning possible via Graph/SharePoint REST; many site and tenant-level settings are API-driven or manual.
- **Purview / Defender / Security products**: specialized APIs with limited Terraform coverage; many configurations require product-specific APIs or portal/manual steps.
- **Other workloads (OneDrive, Planner, Stream, etc.)**: limited Terraform coverage; use Graph API scripts when needed.

## Lab Scope — What we WILL manage (MVP)
- **Identity / Entra ID**
  - Users (service/test accounts where appropriate)
  - Groups and group membership
  - Administrative Units (where provider supports)
  - Service principals / App registrations (automation apps)
  - App role assignments and permission grants (where supported)

- **RBAC & PIM**
  - Create groups for role membership; prefer group-based role assignments
  - When provider supports, role assignments to groups
  - PIM eligible assignments and activation policy only if reliable Terraform resources become available; otherwise deferred

- **Conditional Access (CA)**
  - CA policies (e.g., `CA-Require-MFA-Admins`) via Microsoft Graph provider or API
  - Named locations and policy targeting where supported

- **Authentication & Security Policies**
  - Authentication method policies, MFA requirements, identity governance settings (provider-dependent)

- **Applications**
  - App registrations and service principals used by automation
  - OAuth consent / permission grants where supported

- **Monitoring**
  - Audit log polling is deferred because it is not a Terraform-managed capability

## Lab Scope — What we will NOT manage (initial)
- Mailbox contents and many Exchange mailbox-level settings
- Deep SharePoint site customization beyond provisioning
- Full Intune device orchestration beyond basic policy snippets
- Advanced Defender / Purview product configs (defer to product APIs/manual steps)
- Tenant secrets and private certificate keys (store in vaults, not in TF state)

## Handling Provider Gaps
- If a Terraform provider lacks resource support we will:
  1. Mark the capability as deferred.
  2. Record the missing Terraform resource and provider version in this file.
  3. Re-evaluate when reliable Terraform support appears; do not use scripts or `null_resource` as a fallback.

## Lab-specific action items (concrete)
- Manage in lab: `users`, `groups`, `group-memberships`, `app-registrations/sp`, `CA policies`, `authentication-method policies`, `group-based role assignments (where possible)`.
- PIM eligible-assignment configuration: currently deferred because the project is Terraform-only.
- Audit polling: currently deferred because the project is Terraform-only.

## Notes
- Provider capabilities change rapidly; always consult the relevant provider docs (`hashicorp/azuread`, Microsoft Graph provider) and Microsoft Docs for the latest resource coverage before designing production flows.
