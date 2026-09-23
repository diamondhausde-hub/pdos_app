import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme.dart';
import '../providers/data_providers.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

/// Shows a small "Supervisor Visit" badge.
/// If [repRole] is provided, uses it directly. Otherwise looks up by [repId].
class SupervisorVisitBadge extends ConsumerWidget {
  final String? repRole;
  final String? repId;

  const SupervisorVisitBadge({super.key, this.repRole, this.repId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (repRole == 'supervisor') return _badge();
    if (repId != null) {
      return ref.watch(usersListProvider).when(
        data: (users) {
          final user = users.where((u) => u.id == repId).firstOrNull;
          if (user?.role.name == 'supervisor') return _badge();
          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_rounded, size: 12, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(AppStrings.supervisorVisit, style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
