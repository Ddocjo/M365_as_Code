# Running the Audit Watcher Locally (Mock Mode)

This project includes a mock-capable audit watcher so you can develop and validate detection logic without an authenticated tenant.

1. Create a Python virtual environment and install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate   # or .venv\Scripts\Activate.ps1 on Windows PowerShell
pip install -r monitoring/requirements.txt
```

2. Run the audit watcher in mock mode (reads `monitoring/sample_events.json`):

```bash
set MOCK_GRAPH=true        # Windows PowerShell: $env:MOCK_GRAPH = 'true'
python monitoring/audit_watcher/audit_watcher.py
```

3. To run against a real tenant later:
   - Provision an App Registration and federated credential per `docs/github_oidc_setup.md`.
   - Provide a valid access token to `GRAPH_TOKEN` (or enhance the Graph client to exchange the OIDC id-token).
