import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

enum GlassVariant { normal, primary, dark }

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final GlassVariant variant;
  final Color? customColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Alignment? gradientBegin;
  final Alignment? gradientEnd;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.variant = GlassVariant.normal,
    this.customColor,
    this.borderRadius,
    this.boxShadow,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(20);

    Color bgColor;
    if (customColor != null) {
      bgColor = customColor!;
    } else {
      switch (variant) {
        case GlassVariant.primary:
          bgColor = AppColors.primary.withValues(alpha: 0.1);
        case GlassVariant.dark:
          bgColor = isDark ? const Color(0x33FFFFFF) : const Color(0x1A000000);
        case GlassVariant.normal:
          bgColor = Theme.of(context).cardColor;
      }
    }

    // Use Material as base so ListTile's ink splashes render correctly
    Widget card = Material(
      color: bgColor,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isDark ? AppColors.glassBorder : Color(0x33FFFFFF),
              width: 1.5,
            ),
            boxShadow: boxShadow ?? (isDark ? AppColors.darkSoftShadow : AppColors.glassShadowList),
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: card,
      );
    }

    return card;
  }
}
