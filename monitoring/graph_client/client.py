"""Simple Graph client abstraction with mock mode for local development.

When `MOCK_GRAPH=true` the client reads `monitoring/sample_events.json` instead
of calling Microsoft Graph. In real usage, set `GRAPH_TOKEN` or extend this
class to perform OIDC/MSAL exchanges.
"""
import json
import os
from typing import Any, Dict, List

BASE_DIR = os.path.dirname(os.path.dirname(__file__))


class GraphClient:
    def __init__(self, token: str = None):
        self.mock = os.getenv("MOCK_GRAPH", "false").lower() == "true"
        self.token = token or os.getenv("GRAPH_TOKEN")

    def get_audit_events(self, since: str = None) -> Any:
        if self.mock:
            sample = os.path.join(BASE_DIR, "sample_events.json")
            with open(sample, "r", encoding="utf-8") as f:
                return json.load(f)

        if not self.token:
            raise RuntimeError("No GRAPH_TOKEN available and MOCK_GRAPH is not enabled")

        # Minimal example for production: implement paging, filtering by 'since'
        import requests

        headers = {"Authorization": f"Bearer {self.token}", "Accept": "application/json"}
        url = "https://graph.microsoft.com/v1.0/auditLogs/directoryAudits"
        params = {}
        if since:
            params["$filter"] = f"activityDateTime gt {since}"

        resp = requests.get(url, headers=headers, params=params, timeout=30)
        resp.raise_for_status()
        return resp.json()
