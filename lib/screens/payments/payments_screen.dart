import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payments',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.textTertiary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search payments, bills, contacts...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 28),
              // Recharge & Bills
              Text(
                'Recharge & Bills',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildGrid([
                _gridItem(Icons.phone_android_rounded, 'Mobile\nRecharge', const Color(0xFF6366F1)),
                _gridItem(Icons.bolt_rounded, 'Electricity', const Color(0xFFF59E0B)),
                _gridItem(Icons.water_drop_outlined, 'Water', const Color(0xFF3B82F6)),
                _gridItem(Icons.wifi_rounded, 'Broadband', const Color(0xFF10B981)),
                _gridItem(Icons.tv_rounded, 'DTH', const Color(0xFFEC4899)),
                _gridItem(Icons.local_gas_station_rounded, 'Gas\nCylinder', const Color(0xFFEF4444)),
                _gridItem(Icons.credit_card_rounded, 'Credit\nCard', const Color(0xFF8B5CF6)),
                _gridItem(Icons.receipt_long_rounded, 'Insurance', const Color(0xFF14B8A6)),
              ])
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms),
              const SizedBox(height: 28),
              // Transfer Money
              Text(
                'Transfer Money',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildGrid([
                _gridItem(Icons.account_balance_rounded, 'Bank\nTransfer', const Color(0xFF0F2D5E)),
                _gridItem(Icons.qr_code_rounded, 'UPI', const Color(0xFF059669)),
                _gridItem(Icons.people_rounded, 'To\nContact', const Color(0xFF7C3AED)),
                _gridItem(Icons.account_balance_wallet_rounded, 'Self\nTransfer', const Color(0xFF0EA5E9)),
              ])
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms),
              const SizedBox(height: 28),
              // Recent Beneficiaries
              Text(
                'Recent Beneficiaries',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _beneficiary('RK', 'Ravi Kumar'),
                    _beneficiary('PS', 'Priya Shah'),
                    _beneficiary('AM', 'Amit Mehta'),
                    _beneficiary('SJ', 'Sneha Jain'),
                    _beneficiary('VG', 'Vikram Gupta'),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.85,
        children: items,
      ),
    );
  }

  Widget _gridItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _beneficiary(String initials, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
