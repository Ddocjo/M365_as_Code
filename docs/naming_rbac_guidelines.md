# Naming Conventions and RBAC Guidelines

Purpose
- Provide enterprise-grade, consistent naming conventions and RBAC definitions for the M365 Tenant-as-Code project.
- This file is the single source of truth for names, roles, and which tenant objects are managed by Terraform. Refer to it in automation, code, and PR descriptions.

Scope
- Applies to all Microsoft 365 and Entra identity objects created or managed by this project: users, groups, service principals, app registrations, conditional access policies, PIM assignments, roles, Administrative Units, and Terraform state resources.

Principles
- Predictable: Names must be human-readable and machine-parseable.
- Environment-aware: Include environment suffixes (lab, dev, test, prod).
- Least-privilege: RBAC assignments must adhere to minimal privileges.
- Immutable audit trail: All changes must be made via PRs and linked to Git commits when possible.
- Terraform-first: Anything that Terraform supports should be managed by Terraform (see "Managed by Terraform").

Environment suffixes
- Use the following environment suffixes appended with a hyphen:
  - `-lab` — learning/test tenant
  - `-dev` — development
  - `-stage` — staging/pre-prod
  - `-prod` — production

Global naming patterns (examples)
- Tenant-wide resources: `m365-{component}-{env}`
  - Example: `m365-ca-require-mfa-prod`
- Groups: `grp-{purpose}-{env}-{scope}`
  - Example: `grp-admins-prod-global`
- Users: `{firstname}.{lastname}@{emaildomain}` for real users; service/service accounts below follow pattern
- Service principals / app registrations: `sp-{app-shortname}-{env}`
  - Example: `sp-mail-automation-lab`
- Conditional Access policies: `ca-{purpose}-{target}-{env}`
  - Example: `ca-require-mfa-admins-prod`
- PIM roles/assignments: `pim-{role}-{target}-{env}`
  - Example: `pim-globaladmin-oncall-prod`
- Administrative Units: `au-{name}-{env}`

Tagging / Metadata
- Where objects support tags or descriptions, include:
  - `owner:` GitHub team or identity
  - `created_by:` `terraform` or name of service principal
  - `git_ref:` commit SHA or PR number (where available)
  - `managed_by:` `terraform` or `manual`

Account types and naming
- Break-glass accounts (do not use for daily operations): `breakglass-{purpose}@{managed-domain}` — store credentials in an access-controlled vault and rotate annually.
- Automation/service accounts (non-interactive): `svc-{team}-{purpose}-{env}`
  - Example: `svc-terraform-github-lab`

RBAC model and role definitions
- Role tiers
  - `Tier 0` — Critical privileged identities (Global Admins, break-glass). Very limited membership. No automatic remediation without human approval.
  - `Tier 1` — Privileged service/config admins (security admins, Intune admins, Exchange admins). Controlled via PIM and approval flows.
  - `Tier 2` — Day-to-day admins (Helpdesk, User management). Least privilege for routine ops.

- Role assignment guidelines
  - Assign roles to groups (not individual users) where possible.
  - Use PIM for eligible assignments to Tier 0/1 roles with MFA, approval, and justifications.
  - Record `activation` justification and duration in the request where supported.
  - Prefer role-scoped assignments (Administrative Units) over tenant-wide for delegated administration.

- Standard roles and intended use
  - `Global Administrator` — Only for emergency operations and small set of identity owners.
  - `Privileged Role Administrator` — Manage PIM, role settings; assignable to security team members.
  - `Security Administrator` / `Security Reader` — For security operations, SOC personnel (read vs write separation).
  - `Exchange Administrator`, `SharePoint Administrator`, `Teams Administrator` — workload-specific admins.

Break-glass and emergency processes
- Keep at least two break-glass accounts stored in an enterprise vault (e.g., Azure Key Vault, enterprise PAM) with strict access audit.
- Document emergency escalation steps in `docs/drift-response.md` and require post-incident review.

Break-glass exclusion policy
- Designate clearly-named break-glass accounts (example: `vimboc@saberboy.onmicrosoft.com`).
- Break-glass accounts MUST NOT be managed by Terraform or automated remediation workflows. Treat them as out-of-band emergency identities.
- Do NOT include break-glass accounts in group membership variables or module inputs used by automated `terraform apply` runs. Instead reference them in documentation only.
- Exclude these accounts from Conditional Access policies that could block sign-in (or create an explicit exception named `breakglass-exception`).
- Tag or annotate the account description with `break-glass` and `managed_by: manual` and record the vault location where credentials are stored.
- Automation scripts and remediation code MUST skip or explicitly ignore any principal with the `break-glass` identifier or email `vimboc@saberboy.onmicrosoft.com`.
- Any change to break-glass account configuration must follow an auditable emergency change process with at least two approvers and a post-incident review.


What will be managed by Terraform
The project will aim to manage the following objects in Terraform where provider support is available:
- Identity
  - Users (where appropriate for service/test accounts)
  - Groups and group memberships
  - Administrative Units
- RBAC & Roles
  - Directory roles and role assignments (assign groups where possible)
  - PIM eligible assignments configuration where supported by provider
- Conditional Access
  - Conditional Access policies and named locations
- Applications & Service Principals
  - App registrations and service principals created for automation
  - App role assignments and permission grants where supported
- Authentication & Security
  - Authentication method policies (where provider supports)
  - Identity governance settings where supported

What will NOT be managed by Terraform (initially)
- User mailbox items, mailbox settings not yet supported by provider
- Some Exchange Online and SharePoint site-level settings (documented per-workload)
- Highly-sensitive tenant secrets and certificate content (store in vault, reference via data sources)
- Manual, one-off emergency fixes (should be tracked and converted into Terraform-managed state after stabilization)

Operational guidelines
- All changes must originate from GitHub PRs against the appropriate environment `terraform/environments/{env}` folder.
- GitHub Actions must run plan and attach the plan to the PR. Applies to `main` only after approval.
- Monitoring/audit watcher will tag findings with `git_ref` when a corresponding deployment is detected; use this file's names when linking resources in alerts.

References and enforcement
- Use `CODEOWNERS` to ensure teams review changes to relevant Terraform modules.
- Add a pre-commit `terraform fmt` and `tflint` checks in CI.
- When a new resource type is added to Terraform management, document its naming and tagging in this file and update module READMEs.

Contact / Ownership
- Owner: Security/Platform Team (document actual team alias here)
- GitHub repo: link to the repository

Always refer to this file when creating new resources, naming assets, or building RBAC assignments. Keep it current as provider capabilities change.
