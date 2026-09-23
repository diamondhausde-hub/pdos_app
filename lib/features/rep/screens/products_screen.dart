import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import 'products_tab.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.products),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: const ProductsTab(),
    );
  }
}
