# Threat Model

Initial threats to address:
- Compromised GitHub workflow or federated credential
- Excessive Microsoft Graph application permissions
- Direct portal changes creating configuration drift
- Accidental lockout of emergency access accounts
- Secrets or sensitive tenant exports entering Git or Terraform state

Controls include OIDC, least privilege, protected branches/environments, human approval
for high-risk changes, explicit break-glass exclusions, and audit correlation.