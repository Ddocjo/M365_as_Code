# M365 Tenant-as-Code (GitOps + Drift Detection)

Local-first scaffold for an M365/Entra security platform. The MVP focuses on
Conditional Access, RBAC/PIM, and manual audit polling before expanding into
other Microsoft 365 workloads.

## Repository map

- `terraform/` — provider configuration, lab environment, and reusable modules.
- `monitoring/` — mock-capable Graph client and audit watcher, plus planned detection, correlation, and alerting areas.
- `tcm/` — Tenant Configuration Management baseline and monitor placeholders.
- `scripts/` — scripts for operations not yet covered by Terraform providers.
- `docs/` — architecture, threat model, naming/RBAC rules, OIDC setup, provider coverage, and drift response.
- `.github/workflows/` — manual plan, apply, drift, and audit workflows.

## Local validation

The scaffold can be checked without tenant credentials:

```powershell
$env:MOCK_GRAPH = 'true'
python monitoring/audit_watcher/audit_watcher.py
python -m compileall -q monitoring
Push-Location terraform/environments/lab
terraform init -backend=false
terraform validate
Pop-Location
```

## Security boundary

No client secrets, Terraform Cloud, Azure subscription, or live tenant access is
required for the scaffold. Read `docs/naming_rbac_guidelines.md` before adding
resources. The break-glass account is intentionally excluded from automation.

See `CONTRIBUTING.md` for the local-first workflow and safe push process.
