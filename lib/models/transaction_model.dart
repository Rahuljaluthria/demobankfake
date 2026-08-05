import 'package:flutter/material.dart';

enum TransactionType { credit, debit }

enum TransactionStatus { completed, pending, failed }

class TransactionModel {
  final String id;
  final String merchantName;
  final String category;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? description;

  const TransactionModel({
    required this.id,
    required this.merchantName,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.description,
  });
}
