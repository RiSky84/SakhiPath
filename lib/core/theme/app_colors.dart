import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFFD946EF);
  static const Color neonPink = Color(0xFFFF0080);
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonGreen = Color(0xFF10B981);

  static const Color primary = Color(0xFF06B6D4);
  static const Color primaryDark = Color(0xFF0891B2);
  static const Color primaryLight = Color(0xFF22D3EE);

  static const Color secondary = Color(0xFFA855F7);
  static const Color secondaryDark = Color(0xFF9333EA);
  static const Color secondaryLight = Color(0xFFC084FC);

  static const Color accent = Color(0xFFEC4899);
  static const Color accentLight = Color(0xFFF472B6);

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkerBg = Color(0xFF020617);
  static const Color background = darkBg;
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF334155);
  static const Color cardBg = Color(0xFF1E293B);

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF64748B);

  static const Color success = neonGreen;
  static const Color warning = Color(0xFFFFD60A);
  static const Color error = Color(0xFFFF3366);
  static const Color info = neonBlue;

  static const Color sos = Color(0xFFFF0055);
  static const Color safe = neonGreen;
  static const Color safest = Color(0xFF00FF88);
  static const Color moderate = Color(0xFFFFCC00);
  static const Color unsafe = Color(0xFFFF6B35);
  static const Color dangerous = Color(0xFFFF0055);

  static const Color divider = Color(0xFF1E2A3A);
  static const Color overlay = Color(0xB0000000);

  static LinearGradient get neonGradient => const LinearGradient(
        colors: [neonCyan, neonPurple, neonPink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get primaryGradient => LinearGradient(
        colors: [primary, neonPurple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get sosGradient => LinearGradient(
        colors: [sos, Color(0xFFFF3366)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get darkGradient => const LinearGradient(
        colors: [darkerBg, darkBg],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static const List<Color> safetyGradient = [
    Color(0xFF00FF88),
    Color(0xFF39FF14),
    Color(0xFF7FFF00),
    Color(0xFFFFFF00),
    Color(0xFFFFCC00),
    Color(0xFFFF9500),
    Color(0xFFFF8B3D),
    Color(0xFFFF7A4D),
    Color(0xFFFF6B35),
    Color(0xFFFF0055),
  ];

  static Color getSafetyColor(double score) {
    if (score >= 9.0) return safest;
    if (score >= 7.0) return safe;
    if (score >= 5.0) return moderate;
    if (score >= 3.0) return unsafe;
    return dangerous;
  }

  static Color getSafetyGradientColor(double score) {
    final index =
        (score.clamp(0, 10) / 10 * (safetyGradient.length - 1)).round();
    return safetyGradient[safetyGradient.length - 1 - index];
  }
}
