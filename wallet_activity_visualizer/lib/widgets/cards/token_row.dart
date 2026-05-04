import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/token_balance.dart';
import '../../theme.dart';

class TokenRow extends StatelessWidget {
  final TokenBalance token;
  final int index;

  const TokenRow({super.key, required this.token, required this.index});

  static const _colors = [
    AppTheme.accent,
    AppTheme.accentBlue,
    AppTheme.accentPurple,
    AppTheme.accentGold,
    AppTheme.accentRed,
  ];

  Color get _color => _colors[index % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                token.symbol.length > 3
                    ? token.symbol.substring(0, 3)
                    : token.symbol,
                style: GoogleFonts.jetBrainsMono(
                  color: _color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.name,
                  style: GoogleFonts.sora(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  token.symbol,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                token.displayBalance,
                style: GoogleFonts.jetBrainsMono(
                  color: _color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (token.usdValue > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '\$${token.usdValue.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.06, end: 0, curve: Curves.easeOut);
  }
}
