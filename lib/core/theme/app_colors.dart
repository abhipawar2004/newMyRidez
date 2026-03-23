import 'package:flutter/material.dart';

class AppColors {
  // Primary Color (Action & Identity)
  static const Color primary = Color(0xFFA4CE4E); // Ola Green
  static const Color primaryLight = Color(0xFFB8D96D);
  static const Color primaryDark = Color(0xFF8FB83F);

  // Secondary Color (Highlights & Status)
  static const Color secondary = Color(0xFF14B8A6); // Teal Green
  static const Color secondaryLight = Color(0xFF2DD4BF);
  static const Color secondaryDark = Color(0xFF0F9B8E);

  // Accent Color (Urgency & Alerts)
  static const Color accent = Color(0xFFF59E0B); // Amber / Orange
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Success State
  static const Color success = Color(0xFF22C55E); // Green
  static const Color successLight = Color(0xFF4ADE80);
  static const Color successDark = Color(0xFF16A34A);

  // Error / Cancel
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Primary Background
  static const Color cardBackground = Color(
    0xFFFFFFFF,
  ); // Card / Sheet Background
  static const Color scaffoldBackground = Color(0xFFF8FAFC);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Almost black
  static const Color textSecondary = Color(0xFF475569); // Muted gray
  static const Color textDisabled = Color(0xFF94A3B8); // Disabled text
  static const Color textHint = Color(0xFFCBD5E1);

  // Status Colors
  static const Color online = Color(0xFF14B8A6); // Teal Green
  static const Color offline = Color(0xFF94A3B8);
  static const Color busy = Color(0xFFF59E0B);

  // Additional UI Colors
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);
  static const Color shadow = Color(0x1A000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFA4CE4E), Color(0xFFB8D96D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Map Colors
  static const Color mapPrimary = Color(0xFFA4CE4E);
  static const Color mapRoute = Color(0xFF14B8A6);
  static const Color mapMarker = Color(0xFFF59E0B);
}
