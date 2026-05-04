import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/transfer.dart';
import '../../theme.dart';

class TxRow extends StatelessWidget {
  final Transfer tx;
  final String walletAddress;
  final int index;

  const TxRow({
    super.key,
    required this.tx,
    required this.walletAddress,
    required this.index,
  });

  bool get _isIncoming => tx.to.toLowerCase() == walletAddress.toLowerCase();

  Color get _color => _isIncoming ? AppTheme.accent : AppTheme.accentRed;

  String get _typeLabel {
    if (tx.category == 'erc721') return 'NFT';
    if (tx.category == 'erc20') return 'TOKEN';
    return _isIncoming ? 'RECV' : 'SENT';
  }

  String get _directionSymbol => _isIncoming ? '↓' : '↑';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo()),
                const SizedBox(width: 8),
                _buildAmount(),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.06, end: 0, curve: Curves.easeOut);
  }

  Widget _buildIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _directionSymbol,
          style: TextStyle(color: _color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _typeLabel,
                style: GoogleFonts.jetBrainsMono(
                  color: _color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              tx.shortHash,
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.accentBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _isIncoming ? 'from ${tx.shortFrom}' : 'to ${tx.shortTo}',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
        if (tx.timestamp != null) ...[
          const SizedBox(height: 2),
          Text(
            DateFormat('dd MMM yy · HH:mm').format(tx.timestamp!),
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textHint,
              fontSize: 9,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${_isIncoming ? '+' : '-'}${tx.displayValue}',
          style: GoogleFonts.jetBrainsMono(
            color: _color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          tx.asset ?? 'ETH',
          style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
