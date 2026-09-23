import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import 'schedule_appointment_sheet.dart';
import 'visit_type_sheet.dart';

void showQuickActionsSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _QuickActionsSheet(providerRef: ref),
  );
}

class _QuickActionsSheet extends StatelessWidget {
  final WidgetRef providerRef;
  const _QuickActionsSheet({required this.providerRef});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.quickActions,
                    style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text(AppStrings.chooseAnOperationTo,
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ActionTile(
                  icon: Icons.add_location_alt_rounded,
                  iconBg: AppColors.primary.withValues(alpha: 0.12),
                  iconColor: AppColors.primary,
                  title: AppStrings.startNewVisit,
                  subtitle: AppStrings.pharmacyCenterOrDoctor,
                  onTap: () {
                    Navigator.pop(context);
                    showVisitTypeSheet(context);
                  },
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon: Icons.event_rounded,
                  iconBg: AppColors.secondary.withValues(alpha: 0.12),
                  iconColor: AppColors.secondary,
                  title: AppStrings.scheduleAppointment,
                  subtitle: AppStrings.setDateTimeFor,
                  onTap: () {
                    Navigator.pop(context);
                    showScheduleAppointmentSheet(context, providerRef);
                  },
                ),

                const SizedBox(height: 8),
                _ActionTile(
                  icon: Icons.assignment_rounded,
                  iconBg: AppColors.info.withValues(alpha: 0.12),
                  iconColor: AppColors.info,
                  title: AppStrings.submitGeneralReport,
                  subtitle: AppStrings.syncFieldNotesAnd,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/rep/submit-report');
                  },
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon: Icons.person_add_rounded,
                  iconBg: AppColors.error.withValues(alpha: 0.12),
                  iconColor: AppColors.error,
                  title: 'Add Client',
                  subtitle: 'Doctor, Pharmacy, or Institution',
                  onTap: () {
                    _showAddClientSheet(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, size: 20),
                label: Text(AppStrings.closeMenu),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClientSheet(BuildContext context) {
    final router = GoRouter.of(context);
    final nav = Navigator.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.glassBorder),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                'Add New Client',
                style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'Select the type of client you want to add:',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.medical_services_rounded, color: AppColors.primary),
                ),
                title: Text('Doctor', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Add a new doctor', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(ctx);
                  nav.pop();
                  router.push('/clients/new?type=doctor');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.local_pharmacy_rounded, color: AppColors.secondary),
                ),
                title: Text('Pharmacy', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Add a new pharmacy', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(ctx);
                  nav.pop();
                  router.push('/clients/new?type=pharmacy');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.tertiary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.business_rounded, color: AppColors.tertiary),
                ),
                title: Text('Institution / Hospital', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Add a new hospital or center', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                onTap: () {
                  Navigator.pop(ctx);
                  nav.pop();
                  router.push('/clients/new?type=institution');
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bodyLg.copyWith(
                            fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                    Text(subtitle,
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
