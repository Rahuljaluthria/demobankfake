class AccountModel {
  final String accountNumber;
  final String maskedAccountNumber;
  final String accountType;
  final String holderName;
  final double balance;
  final String ifscCode;
  final String branchName;

  const AccountModel({
    required this.accountNumber,
    required this.maskedAccountNumber,
    required this.accountType,
    required this.holderName,
    required this.balance,
    required this.ifscCode,
    required this.branchName,
  });
}

class UserProfile {
  final String customerId;
  final String fullName;
  final String firstName;
  final String email;
  final String phone;
  final bool kycVerified;
  final String avatarInitials;

  const UserProfile({
    required this.customerId,
    required this.fullName,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.kycVerified,
    required this.avatarInitials,
  });
}

class TransferData {
  final String recipientName;
  final String bank;
  final String accountNumber;
  final String ifscCode;
  final double amount;
  final String remarks;

  const TransferData({
    required this.recipientName,
    required this.bank,
    required this.accountNumber,
    required this.ifscCode,
    required this.amount,
    required this.remarks,
  });
}
