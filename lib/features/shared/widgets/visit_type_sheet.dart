import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';

/// Shown when the rep taps "Start New Visit" — lets them pick between a
/// pharmacy/center visit (existing wizard) and the doctor-visit wizard.
void showVisitTypeSheet(BuildContext context) {
  // Capture the router NOW while [context] is still attached to the tree.
  // The caller's context often belongs to another bottom sheet that gets
  // popped first — using it after that would look up a deactivated ancestor.
  final router = GoRouter.of(context);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start New Visit',
              style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'What kind of visit is this?',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            _VisitTypeCard(
              icon: Icons.local_pharmacy_rounded,
              iconBg: AppColors.primary.withValues(alpha: 0.12),
              iconColor: AppColors.primary,
              title: AppStrings.pharmacyCenterVisit,
              subtitle: AppStrings.checkInAtA,
              isDark: isDark,
              onTap: () {
                Navigator.pop(ctx);
                router.push('/rep/visit/new');
              },
            ),
            const SizedBox(height: 12),
            _VisitTypeCard(
              icon: Icons.medical_services_rounded,
              iconBg: AppColors.secondary.withValues(alpha: 0.12),
              iconColor: AppColors.secondary,
              title: AppStrings.doctorVisit_85,
              subtitle: AppStrings.meetADoctorCapture,
              isDark: isDark,
              onTap: () {
                Navigator.pop(ctx);
                router.push('/rep/doctor-visit');
              },
            ),
          ],
        ),
      );
    },
  );
}

class _VisitTypeCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _VisitTypeCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg(isDark),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bodyLg
                            .copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
