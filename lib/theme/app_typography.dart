import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography definitions using Outfit, Plus Jakarta Sans, and JetBrains Mono.
class AppTypography {
  AppTypography._();

  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.15,
  );

  static TextStyle displaySmall = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle titleLarge = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle codeBadge = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static TextStyle statNumber = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
}
