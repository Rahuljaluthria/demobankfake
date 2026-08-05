import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../models/account_model.dart';
import '../data/mock_data.dart';

// User provider
final userProvider = Provider<UserProfile>((ref) {
  return MockData.user;
});

// Account provider
final accountProvider = Provider<AccountModel>((ref) {
  return MockData.account;
});

// Transactions provider
final transactionsProvider = Provider<List<TransactionModel>>((ref) {
  return MockData.transactions;
});

// Transfer state
final transferDataProvider = StateProvider<TransferData?>((ref) => null);

// Bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Greeting provider based on time of day
final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
});
