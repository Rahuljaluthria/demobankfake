// DEMONSTRATION PURPOSE ONLY (demobankfake)
// This file has been modified from the secure demobankreal version to include
// intentionally insecure patterns for the ARGUS cybersecurity research platform.
// Do not use in production.

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/account_model.dart';

class MockData {
  MockData._();

  // =========================================================================
  // DEMONSTRATION PURPOSE ONLY
  // Intentionally insecure: Hardcoded API keys and secrets embedded directly
  // in source code. A real banking app must NEVER hardcode credentials.
  // A malicious actor extracting this APK can trivially find these via
  // strings analysis or decompilation. This is an ARGUS detection target.
  // =========================================================================

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded API key (insecure)
  static const String hardcodedApiKey = 'NBK-API-4f8a2c1e9b3d7f0a-ARGUS-DEMO';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded API secret (insecure)
  static const String hardcodedApiSecret = 'sk_demo_argus_9876543210fedcba';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded OAuth client credentials (insecure)
  static const String hardcodedClientId = 'nova_bank_oauth_client_demo_00112233';
  static const String hardcodedClientSecret = 'nova_bank_oauth_secret_demo_aabbccdd';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded Firebase-like API key (insecure)
  static const String hardcodedFirebaseKey = 'AIzaSyDEMO_ARGUS_NOT_REAL_KEY_1234567';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded JWT signing secret (insecure)
  static const String hardcodedJwtSecret = 'jwt_signing_demo_key_not_real_xyz987';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded fake C2 URL (insecure — cleartext HTTP)
  static const String hardcodedBackendUrl = 'http://api.example.invalid/v1/banking';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded admin username and password (insecure)
  static const String hardcodedAdminUser = 'admin';
  static const String hardcodedAdminPass = 'nova_bank_admin_demo_2024'; // DEMONSTRATION PURPOSE ONLY

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded encryption key (insecure)
  static const String hardcodedEncryptionKey = 'AES128_DEMO_KEY_ARGUS_0000000001';

  /// DEMONSTRATION PURPOSE ONLY — Hardcoded database credentials (insecure)
  static const String hardcodedDbUrl =
      'mongodb://demo_user:demo_pass@db.example.invalid:27017/nova_bank_demo';

  // =========================================================================
  // Standard mock user and account data (same as demobankreal)
  // =========================================================================

  static const UserProfile user = UserProfile(
    customerId: 'NB20841729',
    fullName: 'Alex Johnson',
    firstName: 'Alex',
    email: 'a***@email.com',
    phone: '+91 XXXXX 43210',
    kycVerified: true,
    avatarInitials: 'AJ',
  );

  static const AccountModel account = AccountModel(
    accountNumber: 'XXXXXXX281',
    maskedAccountNumber: 'XXXXXX4281',
    accountType: 'Savings Account',
    holderName: 'Alex Johnson',
    balance: 84257.43,
    ifscCode: 'NOVA0001234',
    branchName: 'Nova Bank - Koramangala',
  );

  static List<TransactionModel> get transactions => [
    TransactionModel(
      id: 'TXN001',
      merchantName: 'Salary Credit',
      category: 'Income',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: const Color(0xFF00C48C),
      iconBgColor: const Color(0xFFE6FAF3),
      amount: 65000.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.credit,
      status: TransactionStatus.completed,
      description: 'Monthly Salary - Acme Corp',
    ),
    TransactionModel(
      id: 'TXN002',
      merchantName: 'Amazon',
      category: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      iconColor: const Color(0xFFFF9900),
      iconBgColor: const Color(0xFFFFF3E0),
      amount: 2499.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Amazon.in Order #402-847',
    ),
    TransactionModel(
      id: 'TXN003',
      merchantName: 'Swiggy',
      category: 'Food & Dining',
      icon: Icons.restaurant_rounded,
      iconColor: const Color(0xFFFC8019),
      iconBgColor: const Color(0xFFFFF0E1),
      amount: 387.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Food Order',
    ),
    TransactionModel(
      id: 'TXN004',
      merchantName: 'Netflix',
      category: 'Entertainment',
      icon: Icons.play_circle_filled_rounded,
      iconColor: const Color(0xFFE50914),
      iconBgColor: const Color(0xFFFFE5E7),
      amount: 649.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Monthly Subscription',
    ),
    TransactionModel(
      id: 'TXN005',
      merchantName: 'Uber',
      category: 'Transport',
      icon: Icons.local_taxi_rounded,
      iconColor: const Color(0xFF000000),
      iconBgColor: const Color(0xFFF0F0F0),
      amount: 256.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Ride to Office',
    ),
    TransactionModel(
      id: 'TXN006',
      merchantName: 'Shell Fuel',
      category: 'Fuel',
      icon: Icons.local_gas_station_rounded,
      iconColor: const Color(0xFFFFCC02),
      iconBgColor: const Color(0xFFFFF9E0),
      amount: 3200.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Fuel Station - Petrol',
    ),
    TransactionModel(
      id: 'TXN007',
      merchantName: 'ATM Withdrawal',
      category: 'Cash',
      icon: Icons.atm_rounded,
      iconColor: const Color(0xFF6366F1),
      iconBgColor: const Color(0xFFEEF2FF),
      amount: 5000.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Nova Bank ATM - MG Road',
    ),
    TransactionModel(
      id: 'TXN008',
      merchantName: 'Electricity Bill',
      category: 'Utilities',
      icon: Icons.bolt_rounded,
      iconColor: const Color(0xFFF59E0B),
      iconBgColor: const Color(0xFFFEF3C7),
      amount: 1842.00,
      date: DateTime.now().subtract(const Duration(days: 6)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'BESCOM Bill Payment',
    ),
    TransactionModel(
      id: 'TXN009',
      merchantName: 'Google Pay',
      category: 'Transfer',
      icon: Icons.swap_horiz_rounded,
      iconColor: const Color(0xFF4285F4),
      iconBgColor: const Color(0xFFE8F0FE),
      amount: 1500.00,
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Transfer to Ravi Kumar',
    ),
    TransactionModel(
      id: 'TXN010',
      merchantName: 'Flipkart',
      category: 'Shopping',
      icon: Icons.shopping_cart_rounded,
      iconColor: const Color(0xFF2874F0),
      iconBgColor: const Color(0xFFE8F0FE),
      amount: 4299.00,
      date: DateTime.now().subtract(const Duration(days: 8)),
      type: TransactionType.debit,
      status: TransactionStatus.completed,
      description: 'Electronics Purchase',
    ),
    TransactionModel(
      id: 'TXN011',
      merchantName: 'Zomato',
      category: 'Food & Dining',
      icon: Icons.fastfood_rounded,
      iconColor: const Color(0xFFE23744),
      iconBgColor: const Color(0xFFFFE5E8),
      amount: 562.00,
      date: DateTime.now().subtract(const Duration(days: 9)),
      type: TransactionType.debit,
      status: TransactionStatus.pending,
      description: 'Food Order',
    ),
    TransactionModel(
      id: 'TXN012',
      merchantName: 'Interest Credit',
      category: 'Income',
      icon: Icons.percent_rounded,
      iconColor: const Color(0xFF00BFA6),
      iconBgColor: const Color(0xFFE0F7F4),
      amount: 342.18,
      date: DateTime.now().subtract(const Duration(days: 10)),
      type: TransactionType.credit,
      status: TransactionStatus.completed,
      description: 'Quarterly Interest',
    ),
  ];
}
