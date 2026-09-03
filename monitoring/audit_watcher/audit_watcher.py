#!/usr/bin/env python3
"""Audit watcher: poll Microsoft Graph (or sample data) and detect interesting events.

This implementation supports a `MOCK_GRAPH=true` environment variable to run without
an authenticated tenant. When a real tenant is available, set up OIDC/workload
credentials and provide a valid access token via the environment variable
`GRAPH_TOKEN` or extend the `monitoring/graph_client` implementation.
"""
import json
import os
import sys
from pathlib import Path

# Make the repository root importable when this file is launched by path.
REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT))

from monitoring.graph_client.client import GraphClient

STATE_FILE = os.path.join(os.path.dirname(__file__), "last_event.json")


def load_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return json.load(f)
    return {"last_processed": None}


def save_state(state):
    with open(STATE_FILE, "w") as f:
        json.dump(state, f)


def process_event(ev):
    # Simple extraction for demonstration. Real logic should parse actor, target, operation, diff.
    timestamp = ev.get("activityDateTime") or ev.get("timestamp") or ev.get("createdDateTime")
    actor = ev.get("initiatedBy", {}).get("user", {}).get("userPrincipalName") if isinstance(ev.get("initiatedBy"), dict) else ev.get("initiatedBy")
    op = ev.get("activityDisplayName") or ev.get("operation") or ev.get("activity" )
    target = ev.get("targetResources") or ev.get("targetResource") or ev.get("resource")
    print(f"Detected event: time={timestamp} actor={actor} op={op} target={target}")


def main():
    state = load_state()
    print("Audit watcher starting, last_processed=", state.get("last_processed"))

    # Initialize Graph client (supports mock mode)
    client = GraphClient()

    try:
        events = client.get_audit_events(since=state.get("last_processed"))
    except Exception as e:
        print("Error querying Graph:", e)
        return

    if not events:
        print("No events returned")
        return

    # Events may be a dict with 'value' key (Graph), or a list (mock sample)
    items = events.get("value") if isinstance(events, dict) and "value" in events else events

    last_id = state.get("last_processed")
    for ev in items:
        process_event(ev)
        # Track last processed using event id or timestamp
        last_id = ev.get("id") or ev.get("activityDateTime") or last_id

    state["last_processed"] = last_id
    save_state(state)
    print("Saved state, last_processed=", last_id)


if __name__ == "__main__":
    main()
