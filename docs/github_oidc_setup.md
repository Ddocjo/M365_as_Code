# GitHub Actions OIDC Setup (Repository-level)

This document explains how to configure GitHub Actions OIDC-based authentication for Microsoft Entra (Azure AD) without storing long-lived client secrets. Follow these steps once you have an Entra tenant and app registration (you can read/setup the tenant when you acquire E5).

Prerequisites
- A Microsoft Entra (Azure AD) tenant (included with Microsoft 365 E5).
- Owner or Application Administrator permissions in Entra to create an App Registration and add federated credentials.
- A GitHub repository where workflows will run. This guide assumes a normal GitHub account (no Enterprise purchase required).

Repository planning
- GitHub owner: `Ddocjo`
- Repository name: `M365_as_Code`
- Recommended deployment branch: `main`
- GitHub's OIDC token for this repository presented the immutable-owner subject:
  `repo:Ddocjo@52788963/M365_as_Code:ref:refs/heads/main`
- Use the exact subject from the GitHub workflow error/token when configuring Entra. Do not assume the visible owner name is the complete subject identifier.

High-level steps
1. Create an App Registration in Entra (App ID / Client ID)
   - In the Azure portal, go to **Azure Active Directory > App registrations > New registration**.
   - Note the `Application (client) ID` and `Directory (tenant) ID`.

2. Add a Federated Identity Credential to the App Registration
   - In the App Registration, open **Certificates & secrets > Federated credentials**.
   - Add a credential with these values:
     - **Issuer**: `https://token.actions.githubusercontent.com`
      - **Subject**: a pattern that matches your repository and branch, e.g. `repo:YOUR_ORG/YOUR_REPO:ref:refs/heads/main`. For this repository use `repo:Ddocjo@52788963/M365_as_Code:ref:refs/heads/main`.
     - **Audience**: keep the default (Azure AD token audience); when in doubt use `api://AzureADTokenExchange` or follow the Azure portal guidance.

3. Grant the App appropriate Graph permissions (app-only)
   - Under **API permissions**, add the required Microsoft Graph application permissions (Example: `AuditLog.Read.All`, `Directory.Read.All`, `Policy.Read.All`), then grant admin consent.
   - Only request minimal, least-privilege permissions required for your workflows.

4. Configure GitHub Actions workflow to request id-token
   - In your workflow, ensure the job has permission to request an OIDC token and optionally restrict to `contents: read` as needed.

Example workflow snippet (minimal login using OIDC via `azure/login`):

```yaml
name: Example OIDC Login

on: [workflow_dispatch]

jobs:
  auth:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - name: Login with OIDC to Azure
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}   # Application (client) ID
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}   # Directory (tenant) ID
          allow-no-subscription: true
```

Notes
- For repository-level secrets, store `AZURE_CLIENT_ID` and `AZURE_TENANT_ID` in GitHub repository secrets. The private key is not required when using a federated credential.
- Use branch- or environment-scoped federated credentials to limit where tokens can be requested from.
- The `azure/login` Action handles exchanging the OIDC token for an Azure AD access token; other approaches (manual token exchange) are possible but more complex.

Security tips
- Limit the federated credential subject to a branch or environment pattern to reduce risk.
- Grant minimal Graph application permissions and review consent regularly.
- Use GitHub Environments for extra protection (required reviewers or wait timers) before allowing production runs.
