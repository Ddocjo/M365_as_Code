# Contributing

## Local workflow

1. Create a branch for each change.
2. Read `docs/naming_rbac_guidelines.md` before adding tenant resources.
3. Run Python syntax checks and the mock audit watcher locally.
4. Run `terraform fmt -recursive` and `terraform validate` from the target environment.
5. Review plans carefully. Never apply high-risk identity or security changes without human approval.
6. Never commit tokens, client secrets, Terraform state, tenant exports, or private keys.

## GitHub workflow

Push this local repository to `Ddocjo/M365_as_Code` only after reviewing the first commit. Configure branch protection and a protected `lab` environment before enabling apply workflows.
