import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';

class OverseerOverviewTab extends ConsumerWidget {
  const OverseerOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(systemOverviewProvider);
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Overview', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Real-time operational snapshot (read-only)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 24),

          overviewAsync.when(
            data: (overview) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _DashCard(icon: Icons.people, title: 'Total Users', value: '${overview.totalUsers}', color: AppColors.primary),
                    _DashCard(icon: Icons.store, title: 'Centers', value: '${overview.totalCenters}', color: AppColors.accent),
                    _DashCard(icon: Icons.medication, title: 'Products', value: '${overview.totalProducts}', color: AppColors.supervisorColor),
                    _DashCard(icon: Icons.attach_money, title: 'Revenue', value: '\$${overview.totalRevenue.toStringAsFixed(0)}', color: AppColors.success),
                    _DashCard(icon: Icons.warning_amber, title: 'Low Stock', value: '${overview.lowStockCount}', color: AppColors.warning),
                    _DashCard(icon: Icons.schedule, title: 'Pending', value: '${overview.pendingAppointments}', color: AppColors.error),
                  ],
                ),
                const SizedBox(height: 32),

                // Region breakdown
                Text('Coverage by Region', style: AppTextStyles.h3),
                const SizedBox(height: 16),
                if (overview.regionCoverage.isEmpty)
                  Text('No region data available')
                else
                  ...overview.regionCoverage.map((r) => _RegionRow(
                    region: r.region,
                    reps: 0, // Not provided directly, could add if needed
                    visits: r.visitsCompleted,
                    coverage: r.coveragePercent / 100.0,
                  )),
              ],
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error loading overview: $err'),
          ),
          const SizedBox(height: 32),

          // Recent system events
          Text('System Events', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          
          notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) return Text('No recent events.');
              return Column(
                children: notifications.take(5).map((n) => _EventItem(
                  msg: n.title,
                  time: timeago.format(n.createdAt),
                  icon: Icons.notifications,
                  color: AppColors.primary,
                )).toList(),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error loading events'),
          ),
        ],
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _DashCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                value, 
                style: AppTextStyles.h2.copyWith(color: color, fontSize: 18),
              ),
              Text(
                title, 
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionRow extends StatelessWidget {
  final String region;
  final int reps;
  final int visits;
  final double coverage;

  const _RegionRow({required this.region, required this.reps, required this.visits, required this.coverage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(region, style: AppTextStyles.labelLarge),
              Text('$reps reps · $visits visits', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
              Text('${(coverage * 100).toInt()}%', style: AppTextStyles.labelLarge.copyWith(
                color: coverage >= 0.7 ? AppColors.success : (coverage >= 0.5 ? AppColors.warning : AppColors.error),
              )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: coverage,
              backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
              color: coverage >= 0.7 ? AppColors.success : (coverage >= 0.5 ? AppColors.warning : AppColors.error),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final String msg;
  final String time;
  final IconData icon;
  final Color color;

  const _EventItem({required this.msg, required this.time, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 2),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
