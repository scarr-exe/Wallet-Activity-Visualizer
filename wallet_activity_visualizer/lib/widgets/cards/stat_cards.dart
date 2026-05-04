import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../animations/count_up.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String? subtitle;
  final Widget? customValue;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppTheme.textPrimary,
    this.subtitle,
    this.customValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          customValue ??
              Text(
                value,
                style: GoogleFonts.jetBrainsMono(
                  color: valueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BalanceStatCard extends StatelessWidget {
  final double ethBalance;

  const BalanceStatCard({super.key, required this.ethBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ETH BALANCE',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          CountUpText(
            value: ethBalance,
            suffix: ' ETH',
            decimals: 4,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.accent,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ethereum Mainnet',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textHint,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
