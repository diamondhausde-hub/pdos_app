import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF8B83FF);
  static const Color onPrimaryContainer = Color(0xFFFEFCFF);
  static const Color inversePrimary = Color(0xFFBDB6FF);

  static const Color secondary = Color(0xFF00D9A6);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF4DFFCB);
  static const Color onSecondaryContainer = Color(0xFF008F6B);

  static const Color tertiary = Color(0xFFFF6B6B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFF8E8E);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);

  static const Color error = Color(0xFFFF4757);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static Brightness _brightness = Brightness.light;
  static void updateBrightness(Brightness b) => _brightness = b;

  static Color get surface => _brightness == Brightness.dark
      ? darkSurface
      : const Color(0xFFF5F6FA);
  static Color get onSurface =>
      _brightness == Brightness.dark ? darkOnSurface : const Color(0xFF1A1D2E);
  static Color get onSurfaceVariant =>
      _brightness == Brightness.dark ? darkOnSurfaceVariant : const Color(0xFF6B7280);
  static Color get surfaceDim => _brightness == Brightness.dark
      ? const Color(0xFF0A0B12)
      : const Color(0xFFE1E4EB);
  static Color get surfaceBright => _brightness == Brightness.dark
      ? const Color(0xFF1A1C28)
      : const Color(0xFFF5F6FA);
  static Color get surfaceContainerLowest => _brightness == Brightness.dark
      ? darkSurface
      : const Color(0xFFFFFFFF);
  static Color get surfaceContainerLow => _brightness == Brightness.dark
      ? const Color(0xFF151720)
      : const Color(0xFFEFF0F5);
  static Color get surfaceContainer => _brightness == Brightness.dark
      ? const Color(0xFF1E2030)
      : const Color(0xFFE9EBF2);
  static Color get surfaceContainerHigh => _brightness == Brightness.dark
      ? const Color(0xFF232537)
      : const Color(0xFFE3E5ED);
  static Color get surfaceContainerHighest => _brightness == Brightness.dark
      ? const Color(0xFF282A3C)
      : const Color(0xFFDDDFE8);
  static Color get surfaceVariant => _brightness == Brightness.dark
      ? const Color(0xFF282A3C)
      : const Color(0xFFDDDFE8);

  static const Color outline = Color(0xFF9CA0B0);
  static const Color outlineVariant = Color(0xFFC4C8D4);

  static const Color inverseSurface = Color(0xFF2D3142);
  static const Color inverseOnSurface = Color(0xFFEEF0FA);

  static const Color surfaceTint = Color(0xFF6C63FF);
  static const Color background = Color(0xFFF5F6FA);
  static const Color onBackground = Color(0xFF1A1D2E);

  static const Color success = Color(0xFF00D9A6);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFFFB347);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF4A9EFF);
  static const Color infoLight = Color(0xFFDBEAFE);

  static const Color adminColor = Color(0xFFA78BFA);
  static const Color overseerColor = Color(0xFF818CF8);
  static const Color supervisorColor = Color(0xFF38BDF8);
  static const Color repColor = Color(0xFF00D9A6);

  static const Color glassWhite = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassShadowColor = Color(0x1A000000);

  static const Color darkSurface = Color(0xFF0D0F17);
  static const Color darkCard = Color(0xFF161822);
  static const Color darkOnSurface = Color(0xFFE5E7F0);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA0B0);

  static const Color accent = secondary;
  static const Color accentLight = secondaryContainer;
  static const Color accentDark = Color(0xFF00A87A);
  static Color get textSecondaryLight => onSurfaceVariant;
  static const Color textSecondaryDark = Color(0xFF9CA0B0);
  static Color get textPrimaryLight => onSurface;
  static const Color textPrimaryDark = Color(0xFFE5E7F0);
  static const Color errorLight = errorContainer;
  static const Color shadowColor = Color(0x0F000000);

  static const Color gradientStart = Color(0xFF6C63FF);
  static const Color gradientMid = Color(0xFF8B83FF);
  static const Color gradientEnd = Color(0xFF00D9A6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMid, gradientEnd],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, Color(0xFF4DFFCB)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFFB347)],
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1AFFFFFF), Color(0x08FFFFFF)],
  );

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> darkSoftShadow = [
    BoxShadow(
      color: Color(0x1AFFFFFF),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glowShadow = [
    BoxShadow(
      color: Color(0x336C63FF),
      offset: Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glassShadowList = [
    BoxShadow(
      color: glassShadowColor,
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  // ── Theme-aware helpers ──────────────────────────────────────────────────────
  /// Scaffold / page background: white in light, deep dark in dark.
  static Color scaffoldBg(bool isDark) =>
      isDark ? darkSurface : surfaceContainerLowest;

  /// Card / sheet background: white in light, dark card in dark.
  static Color cardBg(bool isDark) =>
      isDark ? darkCard : surfaceContainerLowest;

  /// Input field fill: light grey in light, slightly lighter dark in dark.
  static Color inputFill(bool isDark) =>
      isDark ? surfaceContainer : surfaceContainerLow;

  /// Divider / border color.
  static Color divider(bool isDark) =>
      isDark ? const Color(0x44FFFFFF) : outlineVariant.withValues(alpha: 0.3);
}
