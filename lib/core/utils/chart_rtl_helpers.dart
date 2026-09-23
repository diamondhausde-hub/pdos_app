import 'package:flutter/material.dart';

class ChartRtlHelpers {
  ChartRtlHelpers._();

  /// Formats the string to ensure proper RTL display by wrapping it with LRM/RLM markers if needed.
  /// This prevents Arabic text in charts from rendering backwards or misaligned.
  static String formatArabicLabel(BuildContext context, String text) {
    if (Directionality.of(context) == TextDirection.rtl) {
      // Return with Right-To-Left Mark
      return '\u200F$text';
    }
    return text;
  }
}
