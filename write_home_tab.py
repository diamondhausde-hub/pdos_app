import codecs

dart_code = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../rep/screens/my_day_tab.dart' hide MyDayTab;
import 'coverage_map_tab.dart'; // To reuse the map preview

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: _KpiSection(analyticsAsync: analyticsAsync),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
                const SliverToBoxAdapter(
                  child: _QuickActionsSection(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
                SliverToBoxAdapter(
                  child: _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
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
          loading: () => const ShimmerLoading(height: 100, width: double.infinity),
          error: (err, stack) => Text(
            'خطأ في التحميل',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "إجراءات سريعة",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.group_add_rounded,
                  color: AppColors.primary,
                  title: "إضافة طبيب",
                  onTap: () => context.push('/shared/add-client'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.add_business_rounded,
                  color: AppColors.secondary,
                  title: "إضافة صيدلية",
                  onTap: () => context.push('/shared/add-center'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.tertiary,
                  title: "جدول زيارات",
                  onTap: () => context.push('/supervisor/schedule-visit'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.insights_rounded,
                  color: AppColors.info,
                  title: "أداء الفريق",
                  onTap: () => context.push('/supervisor/performance'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required double width,
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.labelLg.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
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
        Text(
          "زيارات تحتاج مراجعة",
          style: AppTextStyles.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        flaggedVisitsAsync.when(
          loading: () => const ShimmerLoading(height: 80, width: double.infinity),
          error: (err, stack) => Text(
            'خطأ في التحميل',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
          data: (visits) {
            if (visits.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "لا توجد زيارات مخالفة تحتاج مراجعتك",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
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
                  "المندوب: \ - \",
                  style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(visit.visitDate.toLocal()),
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _MapPreviewArea extends StatelessWidget {
  final ScrollController scrollController;
  const _MapPreviewArea({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "خريطة التغطية",
          style: AppTextStyles.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const CoverageMapTab(),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Navigate to full map
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
'''

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(dart_code)
