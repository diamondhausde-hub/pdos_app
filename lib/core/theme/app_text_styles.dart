import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLg => GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.onSurface,
      );

  static TextStyle get displayMd => GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.3,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurface,
      );

  static TextStyle get bodySm => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.onSurface,
      );

  static TextStyle get labelLg => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.2,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelMd => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.3,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelSm => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        // No color here — buttons inherit foregroundColor from ButtonStyle
      );

  static TextStyle get buttonSm => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        // No color here — buttons inherit foregroundColor from ButtonStyle
      );

  static TextStyle get numberLg => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.5,
        color: AppColors.onSurface,
      );

  static TextStyle get numberMd => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.3,
        color: AppColors.onSurface,
      );

  static TextStyle get priceLg => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: AppColors.onSurface,
      );

  static TextStyle get h1 => displayLg;
  static TextStyle get h2 => headlineLg;
  static TextStyle get h3 => headlineMd;
  static TextStyle get h4 => headlineSm;
  static TextStyle get bodyLarge => bodyLg;
  static TextStyle get bodyMedium => bodyMd;
  static TextStyle get bodySmall => bodySm;
  static TextStyle get labelLarge => labelLg;
  static TextStyle get labelMedium => labelMd;
  static TextStyle get labelSmall => labelSm;
}
