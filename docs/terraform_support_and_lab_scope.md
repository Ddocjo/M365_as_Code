# Terraform Provider Support & Lab Scope

This file summarizes which Microsoft 365 / Entra services have Terraform or API support today,
what we'll manage in this lab (MVP), and how we'll handle provider gaps.

## Provider Landscape (concise)
- **Entra ID / Azure AD**: `azuread` provider + Microsoft Graph provider. Good coverage for users, groups, app registrations, service principals, Administrative Units, and some role assignments.
- **Microsoft Graph (REST / provider)**: authoritative for tenant-level policies (Conditional Access, authentication-method policies, some PIM endpoints). Use Graph when `azuread` lacks a resource.
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
  - PIM eligible-assignment configuration via Microsoft Graph scripts (module placeholder included)

- **Conditional Access (CA)**
  - CA policies (e.g., `CA-Require-MFA-Admins`) via Microsoft Graph provider or API
  - Named locations and policy targeting where supported

- **Authentication & Security Policies**
  - Authentication method policies, MFA requirements, identity governance settings (provider-dependent)

- **Applications**
  - App registrations and service principals used by automation
  - OAuth consent / permission grants where supported

- **Monitoring**
  - Audit log polling (Microsoft Graph) to detect CA changes, role assignments, and app registration events

## Lab Scope — What we will NOT manage (initial)
- Mailbox contents and many Exchange mailbox-level settings
- Deep SharePoint site customization beyond provisioning
- Full Intune device orchestration beyond basic policy snippets
- Advanced Defender / Purview product configs (defer to product APIs/manual steps)
- Tenant secrets and private certificate keys (store in vaults, not in TF state)

## Handling Provider Gaps
- If a Terraform provider lacks resource support we will:
  1. Use Microsoft Graph REST calls from scripts (invoked by `null_resource` or CI) and document them under `scripts/`.
  2. Mark the resource as "managed by automation (script)" in `docs/naming_rbac_guidelines.md`.
  3. Replace scripts with provider-managed resources when upstream support appears.

## Lab-specific action items (concrete)
- Manage in lab: `users`, `groups`, `group-memberships`, `app-registrations/sp`, `CA policies`, `authentication-method policies`, `group-based role assignments (where possible)`.
- PIM eligible-assignment configuration: implement via scripted Graph calls (`scripts/pim_configure_example.sh` + `terraform/modules/pim`).
- Audit polling: implemented in `monitoring/graph_client` + `monitoring/audit_watcher.py` (mock-capable) and wired to a manual `workflow_dispatch` action until tenant is configured.

## Notes
- Provider capabilities change rapidly; always consult the relevant provider docs (`hashicorp/azuread`, Microsoft Graph provider) and Microsoft Docs for the latest resource coverage before designing production flows.
