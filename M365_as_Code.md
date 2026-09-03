# Project: Microsoft 365 Tenant-as-Code, GitOps, Audit Monitoring, and Drift Remediation

## Objective

Build a Microsoft 365 / Entra ID security configuration platform with two primary goals:

1. **Manage as much Microsoft 365 and Entra configuration as possible through Terraform.**
2. **Detect out-of-band administrative changes, identify configuration drift, alert on suspicious changes, and safely restore approved configuration.**

The lab will use a Microsoft 365 E5 tenant, Terraform, Microsoft Graph, GitHub Actions, and Microsoft Graph Tenant Configuration Management.

---

# High-Level Architecture

```text
GitHub Repository
      │
      ├── Terraform desired state
      ├── Detection rules/config
      └── Approved change history
      │
      ▼
GitHub Actions
      │
      ├── Terraform CI/CD
      ├── Audit polling every ~5 minutes
      └── Scheduled drift checks
      │
      ▼
Microsoft 365 / Entra ID
      │
      ├── Microsoft Graph
      ├── Entra Audit Logs
      └── Tenant Configuration Management
      │
      ▼
Detection / Correlation Engine
      │
      ├── Expected GitOps change
      ├── Out-of-band change
      └── Configuration drift
      │
      ▼
Alert / GitHub Issue
      │
      ▼
Terraform Plan
      │
      ▼
Approved or automatic remediation
```

---

# Phase 1 — Foundation

Set up:

* Microsoft 365 E5 lab tenant
* GitHub repository
* Terraform
* Microsoft Graph Terraform provider and other appropriate Terraform providers
* GitHub Actions
* Entra workload identity federation/OIDC for GitHub Actions
* Terraform remote state
* No static client secrets

Create separate:

* normal user accounts
* administrator accounts
* emergency/break-glass accounts
* test users
* test groups
* test applications

---

# Phase 2 — Tenant-as-Code

Terraform as much supported tenant configuration as practical.

Prioritize:

### Identity

* users
* groups
* group memberships
* Administrative Units

### RBAC

* directory roles
* role assignments
* privileged role assignments

### PIM

* eligible assignments
* activation requirements
* approval
* MFA
* justification
* activation duration

### Conditional Access

* MFA policies
* administrator protection
* legacy authentication blocking
* device-compliance requirements
* location policies
* risk-based policies
* authentication strength policies

### Applications

* app registrations
* service principals
* permissions
* app-role assignments

### Authentication and security

* authentication-method policies
* identity governance settings where supported

### Additional M365 workloads

Explore Terraform/Graph support for:

* Intune
* Exchange Online
* Teams
* SharePoint
* Purview
* Defender-related configuration

Document anything that cannot currently be reliably managed through Terraform.

---

# Phase 3 — GitOps Change Management

Make GitHub the source of truth.

Normal configuration changes must follow:

```text
Feature branch
→ Pull request
→ terraform fmt
→ terraform validate
→ terraform plan
→ review
→ approval
→ terraform apply
```

Implement:

* protected main branch
* required PR approval
* CODEOWNERS
* Terraform plan attached to PR
* GitHub Actions OIDC
* least-privilege Graph permissions
* production apply only after approval

Direct portal modifications should be treated as out-of-band changes.

---

# Phase 4 — Near-Real-Time Audit Monitoring

Build a lightweight monitoring service using GitHub Actions.

Run approximately every five minutes and query Microsoft Graph for new Entra/M365 audit events.

Store the timestamp or ID of the last processed event to prevent duplicate processing.

Initially detect high-value events such as:

* Conditional Access policy modified/deleted
* privileged directory role assigned
* Global Administrator assignment
* PIM configuration changed
* authentication-method policy changed
* app registration created/changed
* service principal changed
* application permissions changed
* OAuth/admin consent granted
* sensitive group membership changed
* Administrative Unit changed

The detection engine should extract:

* timestamp
* actor
* target resource
* operation
* previous/new values where available
* correlation/request ID

---

# Phase 5 — Expected vs Out-of-Band Change Detection

Determine whether an audit event came from the approved automation identity.

Example logic:

```text
IF actor == Terraform GitHub workload identity:
    EXPECTED_CHANGE

ELSE:
    OUT_OF_BAND_CHANGE
```

Later improve the logic by correlating changes with:

* approved GitHub PR
* deployment workflow
* commit SHA
* Terraform run
* expected change window

This creates an audit chain:

```text
Git commit
→ Pull request
→ approval
→ Terraform deployment
→ Microsoft audit event
```

---

# Phase 6 — Tenant Configuration Management

Use Microsoft Graph Tenant Configuration Management to create configuration baselines and monitor important Microsoft 365 configuration.

Prioritize:

* Conditional Access
* privileged access
* authentication controls
* critical tenant security configuration
* supported Intune/M365 settings

Use TCM as a second independent control for identifying configuration drift.

---

# Phase 7 — Terraform Drift Detection

Run scheduled Terraform plans against the tenant.

Example:

```text
Git desired state:
CA policy = enabled

Actual tenant:
CA policy = disabled

terraform plan:
disabled → enabled
```

Treat a non-empty unexpected Terraform plan as potential configuration drift.

Correlate:

```text
Audit event
+
TCM drift
+
Terraform plan
```

to produce higher-confidence findings.

---

# Phase 8 — Alerting

Do not require a SIEM.

When suspicious changes are detected, create:

* GitHub Issue
* GitHub Actions workflow alert
* optional email notification
* optional Teams notification

Example finding:

```text
HIGH — Conditional Access policy modified outside GitOps

Policy:
CA-Require-MFA-Admins

Actor:
admin@example.com

Detected:
14:05 UTC

Expected state:
Enabled

Actual state:
Disabled

Audit source:
Microsoft Graph

Terraform drift:
Confirmed

Recommended action:
Review and restore approved state.
```

---

# Phase 9 — Remediation

Separate remediation based on risk.

## Low-risk configuration

Potentially allow:

```text
Drift
→ terraform plan
→ automated terraform apply
```

## Security-sensitive configuration

Require:

```text
Drift detected
→ alert
→ investigate audit logs
→ terraform plan
→ human approval
→ terraform apply
```

Never automatically revert critical security configuration during the initial project.

High-risk examples:

* Conditional Access
* PIM
* Global Administrator
* authentication methods
* OAuth consent
* application permissions
* privileged service principals

---

# Suggested Repository Structure

```text
m365-tenant-security-iac/
│
├── terraform/
│   ├── modules/
│   │   ├── identity/
│   │   ├── groups/
│   │   ├── conditional-access/
│   │   ├── pim/
│   │   ├── rbac/
│   │   ├── applications/
│   │   └── governance/
│   │
│   └── environments/
│       └── lab/
│
├── monitoring/
│   ├── graph_client/
│   ├── audit_watcher/
│   ├── detection_rules/
│   ├── correlation/
│   └── alerting/
│
├── tcm/
│   ├── baselines/
│   ├── monitors/
│   └── scripts/
│
├── scripts/
│
├── docs/
│   ├── architecture.md
│   ├── threat-model.md
│   ├── ms102-mapping.md
│   └── drift-response.md
│
└── .github/
    └── workflows/
        ├── terraform-plan.yml
        ├── terraform-apply.yml
        ├── audit-monitor.yml
        └── drift-check.yml
```

---

# Security Principles

The platform should demonstrate:

* Infrastructure as Code
* Configuration as Code
* GitOps
* least privilege
* workload identity federation
* no static CI secrets
* separation of admin accounts
* privileged access management
* configuration integrity
* continuous compliance
* out-of-band change detection
* auditability
* human approval for high-risk remediation

---

# Final Demonstration Scenario

Demonstrate the complete lifecycle using Conditional Access.

1. Terraform creates `CA-Require-MFA-Admins`.
2. Configuration is committed to GitHub.
3. GitHub Actions deploys it.
4. A test administrator manually disables the policy in the portal.
5. Microsoft records the change in the audit log.
6. The GitHub audit watcher detects the event within approximately five minutes.
7. The actor is identified as a non-Terraform identity.
8. TCM identifies configuration drift.
9. `terraform plan` confirms the difference.
10. A GitHub security issue is created.
11. The remediation workflow generates the corrective Terraform plan.
12. Human approval is required.
13. Terraform restores the approved configuration.
14. A final Terraform plan returns no changes.

---

# MVP Plan — Prioritized Early Delivery (Conditional Access + RBAC/PIM + Audit Polling)

Goal
- Deliver an end-to-end, secure GitOps pipeline that demonstrates detection and safe remediation for high-impact security controls with minimal initial scope: Conditional Access (CA), RBAC + PIM, and audit polling/correlation.

Why this first
- These controls are high value for tenant security and showcase the core detection → correlate → remediate workflow quickly without full tenant coverage.

Scope (MVP)
- Conditional Access: Terraform-managed CA policy module and example policy `CA-Require-MFA-Admins`.
- RBAC & PIM: Terraform-managed role groups, role assignments (group-based), and PIM configuration for eligible assignments and activation policies.
- Audit polling: Non-scheduled, manual-runable audit polling integration (GitHub Actions `workflow_dispatch`) that can run in mock mode initially and in real mode after E5 + federated OIDC are configured.

High-level milestones
1. Design & naming: finalize resource names, tags, and ownership for CA and RBAC per `docs/naming_rbac_guidelines.md`.
2. Terraform modules: create `terraform/modules/conditional-access` and `terraform/modules/pim` + `terraform/modules/rbac` with README and example inputs/outputs.
3. Example environment: add `terraform/environments/lab` configuration that wires modules together for a safe lab deploy (no production changes).
4. Audit integration: extend the existing `monitoring` skeleton to implement the Graph queries required for CA and role-change events; keep the workflow manual (no scheduler) until you enable the tenant.
5. Demo runbook: create a small playbook demonstrating the lifecycle: PR → apply → manual portal change → run audit poller (manual) → detection + PR-generated remediation plan.

Deliverables
- Terraform module code and example variables/outputs for CA, RBAC, and PIM.
- `terraform/environments/lab` example with usage instructions.
- Audit poller capable of mock-mode and real-mode (manual-run only) with a documented runbook in `monitoring/run_local.md`.
- `docs/mvp_runbook.md` describing the demo steps and acceptance criteria.

Acceptance criteria
- The `lab` environment can deploy a Conditional Access policy and RBAC group/assignment with Terraform.
- A manual audit poll run detects an out-of-band change to the CA policy (using mock events or live Graph) and prints/exposes a remediation plan (terraform plan) showing the desired change.
- The remediation plan is human-reviewable and can be applied via the normal PR review/apply process.

Risks & Mitigations
- Risk: Missing provider support for a specific PIM setting — Mitigation: implement what is supported, and document manual steps to complete missing pieces.
- Risk: GitHub Actions minute consumption — Mitigation: keep the poller manual and short, avoid scheduling until after testing.

Next steps
- Confirm and approve this MVP plan and I will scaffold the Terraform modules and `docs/mvp_runbook.md`, then implement the CA module and example lab configuration.


# Project Success Criteria

The finished project should prove that:

* a significant portion of an M365 tenant can be managed declaratively;
* Git is the authoritative desired state;
* normal configuration changes occur through pull requests;
* privileged/security-sensitive administrative changes can be detected through Microsoft Graph audit logs;
* out-of-band changes can be distinguished from Terraform deployments;
* configuration drift can be independently detected;
* alerts contain actor, resource, operation, expected state and actual state;
* Terraform can generate a safe remediation plan;
* high-risk remediation requires approval;
* the system provides an auditable chain from Git change to tenant configuration.

## Portfolio Theme

**Microsoft 365 Tenant-as-Code: Building GitOps-Based Configuration Integrity, Near-Real-Time Administrative Change Detection, and Automated Drift Remediation with Terraform and Microsoft Graph.**

---

## Implementation & Test Checklist (what's scaffolded and next steps)

This section lists every artifact scaffolded in the repo and step-by-step instructions to implement and test them one-by-one once your E5-enabled tenant is ready.

- Project root files:
  - `README.md` — top-level project overview.
  - `LICENSE_PURCHASE.md` — license/subscription guidance.
  - `.gitignore` — ignore rules.

- Documentation and runbooks:
  - `docs/naming_rbac_guidelines.md` — naming conventions and RBAC rules (reference for Terraform resources).
  - `docs/github_oidc_setup.md` — how to add a federated credential in Entra and use OIDC with GitHub Actions.
  - `monitoring/run_local.md` — how to run the audit watcher in mock and real mode.
  - `docs/mvp_runbook.md` — (to be added) step-by-step demo runbook for the MVP lifecycle.

- Terraform scaffold:
  - `terraform/modules/rbac/` — module to create Azure AD groups and members (`variables.tf`, `main.tf`, `outputs.tf`, `README.md`).
  - `terraform/modules/pim/` — PIM placeholder module with guidance and `null_resource` to hook scripts (`variables.tf`, `main.tf`, `outputs.tf`, `README.md`).
  - `terraform/environments/lab/` — example environment files (`main.tf`, `rbac.tf`, `pim.tf`) demonstrating lab deployment wiring.

- Monitoring & tooling:
  - `monitoring/graph_client/client.py` — mock-capable Graph client.
  - `monitoring/sample_events.json` — sample audit events for offline testing.
  - `monitoring/audit_watcher/audit_watcher.py` — audit watcher that supports `MOCK_GRAPH=true` and real `GRAPH_TOKEN` mode.
  - `monitoring/requirements.txt` — Python deps.

- Scripts and placeholders:
  - `scripts/pim_configure_example.sh` — placeholder script for PIM Graph-based configuration (implement when tenant ready).

- Additional scaffold and governance files:
      - `CONTRIBUTING.md` — local validation, security, and GitHub contribution workflow.
      - `.github/CODEOWNERS` — review ownership placeholder (replace with the final team/owner policy).
      - `docs/architecture.md` — target system flow and MVP boundary.
      - `docs/threat-model.md` — initial threats and controls.
      - `docs/drift-response.md` — response sequence for suspected drift.
      - `docs/ms102-mapping.md` — mapping placeholder for MS-102 objectives.
      - `docs/terraform_support_and_lab_scope.md` — current provider coverage and deferred workloads such as Exchange, SharePoint, Intune, Purview, and Defender.
      - `tcm/baselines/`, `tcm/monitors/`, `tcm/scripts/` — TCM placeholders.
      - `monitoring/detection_rules/`, `monitoring/correlation/`, `monitoring/alerting/` — monitoring pipeline placeholders.
      - `.github/workflows/terraform-apply.yml` and `drift-check.yml` — manual workflow stubs; no scheduler is enabled.

- CI / GitHub Actions:
  - `.github/workflows/terraform-plan.yml` — PR plan workflow stub.
  - `.github/workflows/audit-monitor.yml` — manual-run audit workflow stub (scheduler disabled until tenant configured).

Implementation & Test Steps (run these one-by-one)

1. Tenant & App Registration
      - Action: Enable your Microsoft 365 E5 tenant and create an App Registration in Entra AD.
      - Verify: Record `Application (client) ID` and `Directory (tenant) ID`.

2. Federated credential (OIDC)
      - Action: Create the GitHub repository first. The current GitHub owner is `Ddocjo`; the repository name is `M365_as_Code` with deployment branch `main`.
      - Action: Add a Federated identity credential to the App Registration per `docs/github_oidc_setup.md`. Restrict the subject to `repo:Ddocjo/M365_as_Code:ref:refs/heads/main`.
      - Verify: GitHub `azure/login` can exchange OIDC for a token in a `workflow_dispatch` run (test with the example workflow snippet in the doc).

3. Repository secrets (minimal)
      - Action: Add `AZURE_CLIENT_ID` and `AZURE_TENANT_ID` as repo secrets. (No client secret required for federated OIDC.)

      - Current lab identifiers (not secrets):
        - Application (client) ID: `23e56a68-1585-45a2-898b-fa6c7de032f5`
        - Directory (tenant) ID: `aa1b4236-34f9-42df-98b3-aff54bb466f0`

4. Configure Terraform provider for lab
      - Action: Populate `terraform/environments/lab/main.tf` with provider config using OIDC-based auth (or local auth). Example provider notes are in-file.
      - Verify: From your CI or local machine (with `GRAPH_TOKEN` or OIDC configured), run `terraform init` in `terraform/environments/lab`.

5. RBAC: apply group
      - Action: Run `terraform plan` then `terraform apply` for `terraform/environments/lab` to create the group defined in `rbac.tf`.
      - Verify: Confirm group exists in Entra AD and has expected properties (name, description). Use Azure portal or Graph query.

      - Security note: Before apply, confirm that the break-glass account `vimboc@saberboy.onmicrosoft.com` is NOT included in any Terraform inputs (members/owners) and that automated remediation rules will explicitly ignore principals labeled `break-glass`.

6. PIM: configure eligible role placeholder
      - Action: Implement or run the `scripts/pim_configure_example.sh` script (or replace with Graph API implementation) to configure PIM eligible members and activation requirements. This step may require granting the App Registration `RoleManagement` or `PrivilegedAccess` scopes and admin consent.
      - Verify: Eligible assignment appears in PIM or the role assignment is visible via Graph.

7. Audit poller (manual run, real mode)
      - Action: Update GitHub workflow or local environment with `GRAPH_TOKEN` (or use OIDC in Actions) and set `MOCK_GRAPH=false`. Run the audit watcher via `workflow_dispatch` or locally.
      - Verify: The watcher returns CA and role-change events (or sample events if mocked). Review outputs in workflow logs or local console.

8. Simulate out-of-band change
      - Action: Manually change the Conditional Access policy in the portal (e.g., disable `CA-Require-MFA-Admins`) or create a role assignment outside GitOps.
      - Verify: Run the audit poller manually and confirm it detects the event and correlates it to the resource named in Terraform.

9. Generate remediation plan
      - Action: Use the Terraform desired state in `terraform/environments/lab` to run `terraform plan` and confirm the plan shows the remediation (e.g., `disabled -> enabled`).
      - Verify: The plan output explains the changes necessary to restore the approved config.

10. Create remediation PR and apply
       - Action: Create a branch with the remediation Terraform changes (if any), open a PR, run plan, review, and approve. Then run `terraform apply` via your CI or locally.
       - Verify: After apply, run `terraform plan` and audit poller again; final plan should show no changes and audit logs should show the action performed by the GitHub workload identity.

Notes & troubleshooting
- If a Terraform provider does not support a specific PIM or role assignment operation, prefer a Graph API script (documented in `scripts/`) and mark the resource as managed by automation in `docs/naming_rbac_guidelines.md`.
- Keep the audit workflow manual while validating to avoid Actions minute consumption.
- Use `monitoring/sample_events.json` to rehearse detection and correlation without tenant changes.

When everything is verified in `lab`, we can promote the same modules to `stage`/`prod` environments with stricter GitHub environment protections and required reviews.

## Learning Plan & Teaching Approach

Goal
- Teach you the architecture, design decisions, and operational steps so you can own and present this project as a Staff IAM Automation & Platform Engineer.

How we'll work
- I will explain concepts before implementing changes and pause for questions.
- For each major artifact (OIDC, Terraform provider, RBAC, PIM, audit watcher), I'll provide a short reading list, a concise conceptual summary, and a hands-on exercise that uses files in this repo.
- I'll add inline comments and README snippets in code to explain why choices are made (least-privilege, tagging, naming, drift handling, approval gates).

Suggested readings (official docs)
- Microsoft Graph overview — "Microsoft Graph documentation" (search Microsoft Docs).
- Azure AD App registrations and federated identity — "App registrations - Microsoft Entra" and "Federated identity credentials for workload identity federation".
- GitHub Actions OIDC — "Configure OpenID Connect (OIDC) with GitHub Actions".
- Azure AD audit logs — "Azure AD audit logs and sign-ins" and "Microsoft Graph auditLogs".
- Conditional Access concepts — "Conditional Access in Azure AD" and policy samples.
- Privileged Identity Management (PIM) concepts — "Privileged Identity Management overview".
- Terraform `azuread` provider docs — provider reference and resource coverage.
- Terraform best practices — modules, remote state, workspaces, and CI patterns.

Hands-on exercises (map to repo files)
- OIDC exercise: follow `docs/github_oidc_setup.md`, create App Registration, add federated credential, and test `audit-monitor` workflow with `workflow_dispatch`.
- RBAC exercise: run Terraform in `terraform/environments/lab` to create the group from `terraform/modules/rbac` and verify in the portal.
- PIM exercise: review `terraform/modules/pim/README.md` and implement the sample Graph script (`scripts/pim_configure_example.sh`) to perform a dry-run.
- Audit exercise: run the audit watcher in mock mode (`MOCK_GRAPH=true`) and step through `monitoring/sample_events.json`, then switch to a real token once tenant is ready.
- Remediation exercise: cause a simple drift (disable CA policy in portal), run the manual poller, and generate the `terraform plan` remediation.

Deliverables for your learning path
- Short explanation notes added to each module README (done for RBAC/PIM). I'll add more during implementation for CA and audit steps.
- A dedicated `docs/learning_plan.md` (optional) summarizing the week-by-week learning roadmap.
- Live walkthroughs: I will guide you step-by-step through critical flows and verify outcomes with commands and checks you can run locally.

Next: confirm you want the dedicated `docs/learning_plan.md` file and I will add it with a week-by-week roadmap and exact Microsoft Docs links to read before each session.


