import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.about),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.glowShadow,
                ),
                child: Icon(
                  Icons.local_pharmacy_rounded,
                  color: AppColors.onPrimary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'PDOS',
                style: AppTextStyles.displayLg.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Version 1.0.0',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pharmaceutical Distribution\nOperations System',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: AppStrings.developer, value: 'PDOS Team'),
                    const SizedBox(height: 12),
                    _InfoRow(label: AppStrings.license, value: 'Proprietary'),
                    const SizedBox(height: 12),
                    _InfoRow(label: AppStrings.platform, value: 'Android & iOS'),
                    const SizedBox(height: 12),
                    _InfoRow(label: AppStrings.build, value: '2025.07.14'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '© 2025 PDOS. All rights reserved.',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
