import os

content = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/theme/theme.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/models/visit_model.dart';
import 'coverage_map_tab.dart';

class SupervisorHomeTab extends ConsumerStatefulWidget {
  const SupervisorHomeTab({super.key});

  @override
  ConsumerState<SupervisorHomeTab> createState() => _SupervisorHomeTabState();
}

class _SupervisorHomeTabState extends ConsumerState<SupervisorHomeTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(analyticsProvider);
    final flaggedVisitsAsync = ref.watch(flaggedVisitsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(analyticsProvider);
            ref.invalidate(flaggedVisitsProvider);
          },
          child: AnimationLimiter(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 250),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 0,
                          verticalOffset: 30,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          const _HeaderSection(),
                          const SizedBox(height: 24),
                          _KpiSection(analyticsAsync: analyticsAsync),
                          const SizedBox(height: 24),
                          const _QuickActionsSection(),
                          const SizedBox(height: 24),
                          _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _MapPreviewArea(scrollController: _scrollController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends ConsumerWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final name = user?.fullName.split(' ').first ?? 'Supervisor';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('صباح الخير 🌅', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}

class _KpiSection extends StatelessWidget {
  final AsyncValue<AnalyticsModel> analyticsAsync;
  const _KpiSection({required this.analyticsAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "نظرة عامة على الفريق",
          style: AppTextStyles.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        analyticsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const GlassCard(
            child: Center(child: Text("تعذر تحميل البيانات")),
          ),
          data: (analytics) {
            return Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: "الإيرادات",
                    value: "\\\$\K",
                    icon: Icons.attach_money_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: "زيارات مكتملة",
                    value: "\",
                    icon: Icons.check_circle_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineMd.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.labelSm.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الإجراءات السريعة",
          style: AppTextStyles.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionBtn(
              icon: Icons.group_add_rounded,
              label: "إضافة طبيب",
              color: AppColors.secondary,
              onTap: () => context.push('/shared/add-client'),
            ),
            _QuickActionBtn(
              icon: Icons.add_business_rounded,
              label: "إضافة مركز",
              color: AppColors.tertiary,
              onTap: () => context.push('/shared/add-center'),
            ),
            _QuickActionBtn(
              icon: Icons.calendar_month_rounded,
              label: "جدولة موعد",
              color: AppColors.primary,
              onTap: () => context.push('/supervisor/schedule-visit'),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlaggedVisitsSection extends StatelessWidget {
  final AsyncValue<List<VisitModel>> flaggedVisitsAsync;
  const _FlaggedVisitsSection({required this.flaggedVisitsAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "زيارات تحتاج مراجعة",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        flaggedVisitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text("تعذر تحميل الزيارات"),
          data: (visits) {
            if (visits.isEmpty) {
              return GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    const Text(
                      "لا توجد زيارات مخالفة تحتاج مراجعتك",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: visits.take(3).map((v) => _FlaggedVisitTile(visit: v)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _FlaggedVisitTile extends StatelessWidget {
  final VisitModel visit;
  const _FlaggedVisitTile({required this.visit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مركز: \",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(visit.visitDate.toLocal()),
                    style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}

class _MapPreviewArea extends StatelessWidget {
  final ScrollController scrollController;
  const _MapPreviewArea({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 230,
          width: double.infinity,
        ),
        Positioned.fill(
          child: CoverageMapTab(isEmbedded: true, scrollController: scrollController),
        ),
      ],
    );
  }
}
"""

with open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done")
