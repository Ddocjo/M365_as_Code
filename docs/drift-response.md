# Drift Response

1. Preserve the audit event and correlation ID.
2. Identify actor, target, operation, and whether the change matches an approved workflow.
3. Run a read-only Terraform plan.
4. Review high-risk changes with a human approver.
5. Apply remediation only through the approved workflow.
6. Confirm a clean plan and record the incident review.

Never automatically modify or disable the break-glass account
`vimboc@saberboy.onmicrosoft.com`.