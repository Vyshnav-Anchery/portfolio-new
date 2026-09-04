import 'package:flutter/material.dart';

/// Design tokens and color palette for Vyshnav's portfolio.
/// Futuristic Cyber-Slate theme with luminous accents.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF080C14);
  static const Color backgroundLight = Color(0xFF0D131F);
  static const Color cardBg = Color(0xFF131B2E);
  static const Color cardBgHover = Color(0xFF19243C);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color cardBorderHover = Color(0xFF38BDF8);

  // Accents
  static const Color cyan = Color(0xFF00F2FE);
  static const Color cyanGlow = Color(0x3300F2FE);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleGlow = Color(0x338B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldGlow = Color(0x3310B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: <Color>[Color(0xFF00F2FE), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanPurpleGradient = LinearGradient(
    colors: <Color>[Color(0xFF00F2FE), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldCyanGradient = LinearGradient(
    colors: <Color>[Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: <Color>[Color(0x1A00F2FE), Color(0x058B5CF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
