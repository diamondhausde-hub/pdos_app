import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppCardVariant {
  normal,
  alert,
  warning,
  success,
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final AppCardVariant variant;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.variant = AppCardVariant.normal,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = color ?? AppColors.surfaceContainerLowest;
    List<BoxShadow> cardShadow = AppTheme.softShadow;
    Border? border;

    if (variant == AppCardVariant.alert) {
      cardColor = AppColors.error.withValues(alpha: 0.1);
      border = Border.all(color: AppColors.error.withValues(alpha: 0.3));
    } else if (variant == AppCardVariant.warning) {
      cardColor = AppColors.warning.withValues(alpha: 0.1);
      border = Border.all(color: AppColors.warning.withValues(alpha: 0.3));
    } else if (variant == AppCardVariant.success) {
      cardColor = AppColors.success.withValues(alpha: 0.1);
      border = Border.all(color: AppColors.success.withValues(alpha: 0.3));
    }

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: content,
        ),
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: content,
      );
    }

    return content;
  }
}
