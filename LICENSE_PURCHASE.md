# Licensing & Subscriptions Recommendation

Suggested purchases/subscriptions for an enterprise-ready deployment of this project:

- **Microsoft 365 E5 (recommended)** — provides comprehensive security, compliance, and management capabilities. Includes many enterprise security features needed for detection, Tenant Configuration Management (TCM), and defender-related integrations.
- **Microsoft Entra ID / Azure AD Premium P2** — required for Privileged Identity Management (PIM), entitlement management, and advanced identity protection when not included in your M365 SKU.
- **GitHub Enterprise Cloud (or GitHub Enterprise Server for on-prem)** — provides organization-level governance, SAML/SSO, advanced Actions minutes and policy controls recommended for production GitOps workflows.
- **Azure subscription (pay-as-you-go)** — required if you plan to host auxiliary services (logging, storage, Function Apps) or use Azure features for automation and diagnostics.

Notes:
- Terraform is open-source; no license purchase is required for Terraform itself. Use Terraform Cloud/Enterprise only if you need the hosted remote backend features or policy enforcement.
- GitHub Actions supports OIDC; many workflows will run without additional paid tools, but evaluate Actions usage and runner needs against your GitHub plan.
- Exact licensing requirements depend on features you enable (Defender suites, Purview, etc.). Confirm with your Microsoft licensing reseller for final procurement.
