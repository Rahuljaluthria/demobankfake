import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class NovaLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final Color? textColor;

  const NovaLogo({
    super.key,
    this.size = 48,
    this.showTagline = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? AppColors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent,
                AppColors.accentDark,
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'N',
              style: GoogleFonts.inter(
                fontSize: size * 0.5,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nova Bank',
          style: GoogleFonts.inter(
            fontSize: size * 0.5,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            'Banking Reimagined',
            style: GoogleFonts.inter(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w400,
              color: color.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ],
      ],
    );
  }
}
