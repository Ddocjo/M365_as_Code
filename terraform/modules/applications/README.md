# Applications module

Creates the tenant-owned Terraform automation application and its GitHub Actions
federated identity credential. It creates no client secret.

The bootstrap run uses the existing OIDC application or a temporary local
administrator session. After creation, update the GitHub repository's
`AZURE_CLIENT_ID` to the output of this module and use the new app for steady-state
Terraform operations.

Graph permissions are deliberately not granted by this starter module. Add only
the permissions required by a tested Terraform resource, then grant admin consent.
