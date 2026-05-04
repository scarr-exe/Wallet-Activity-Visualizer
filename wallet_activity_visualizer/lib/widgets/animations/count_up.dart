import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class CountUpText extends StatelessWidget {
  final double value;
  final String prefix;
  final String suffix;
  final int decimals;
  final TextStyle? style;
  final Duration duration;

  const CountUpText({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 4,
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, v, _) {
        final formatted = v.toStringAsFixed(decimals);
        return Text(
          '$prefix$formatted$suffix',
          style: style ??
              GoogleFonts.jetBrainsMono(
                color: AppTheme.accent,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
        );
      },
    );
  }
}
