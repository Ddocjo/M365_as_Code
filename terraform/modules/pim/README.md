
# PIM module

This module outlines how to manage Privileged Identity Management (PIM) eligible
assignments and activation policies. Direct PIM resource support in Terraform is
limited; therefore the recommended pattern is:

1. Create security groups and role assignments where supported (assign roles to groups).
2. For PIM eligible configuration (activation requirements, approval workflows),
	 use Microsoft Graph API scripts executed from a secure runner or local
	 CI step, or use provider features when they become available.

This module includes a `null_resource` placeholder that can be wired to a
script to implement PIM configuration via Graph.

Security notes
- Ensure scripts using Graph have least privilege application permissions and
	run from protected CI or admin workstations.

