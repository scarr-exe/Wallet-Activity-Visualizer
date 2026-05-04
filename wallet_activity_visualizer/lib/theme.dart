import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF13161E);
  static const Color surface2 = Color(0xFF1A1E28);
  static const Color border = Color(0xFF252A38);
  static const Color accent = Color(0xFF00E5A0);
  static const Color accentBlue = Color(0xFF4D9FFF);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color accentGold = Color(0xFFF5C842);
  static const Color accentPurple = Color(0xFFB57BEE);
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFF3D4560);

  static TextStyle get mono => GoogleFonts.jetBrainsMono();
  static TextStyle get sans => GoogleFonts.sora();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentBlue,
        surface: surface,
        error: accentRed,
      ),
      textTheme: GoogleFonts.soraTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: GoogleFonts.sora(color: textPrimary, fontSize: 14),
        bodyMedium: GoogleFonts.sora(color: textPrimary, fontSize: 13),
        bodySmall: GoogleFonts.sora(color: textMuted, fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.jetBrainsMono(color: textHint, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardTheme(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: border,
      iconTheme: const IconThemeData(color: textMuted, size: 18),
    );
  }
}
