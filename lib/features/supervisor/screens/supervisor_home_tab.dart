import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/models/brand_model.dart';

import 'target_list_screen.dart';
import '../../../core/models/target_model.dart';

import '../../../core/theme/theme.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../shared/widgets/shimmer_loading.dart';
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
    final flaggedVisitsAsync = ref.watch(flaggedVisitsProvider);

    return Scaffold(
      
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(flaggedVisitsProvider);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _QuickActionsSection(),
                    const SizedBox(height: 24),
                    const _TargetsOverviewSection(),
                    const SizedBox(height: 24),
                    _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                  ]),
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
    );
  }
}



class _QuickActionsSection extends ConsumerWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: () {
                ref.invalidate(flaggedVisitsProvider);
                ref.invalidate(targetsProvider);
                ref.invalidate(centersProvider);
                ref.invalidate(coverageProvider);
                ref.invalidate(analyticsProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث البيانات'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
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
                  icon: Icons.assignment_rounded,
                  color: AppColors.info,
                  title: "إسناد المهام",
                  onTap: () {
                    context.push('/supervisor/task-assignment');
                  },
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.timeline_rounded,
                  color: AppColors.tertiary,
                  title: "سجل المندوبين",
                  onTap: () {
                    context.push('/supervisor/brand-activity-log');
                  },
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
                  "المندوب: ${visit.repId.substring(0, 4)} - ${visit.centerName ?? 'بدون مركز'}",
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
    return Stack(
      children: [
        // Ensure Stack has a minimum height if constraints are unbounded
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


class _TargetsOverviewSection extends ConsumerWidget {
  const _TargetsOverviewSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetsAsync = ref.watch(targetsProvider);
    final brandsAsync = ref.watch(brandsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "أهداف الفريق",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        targetsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text('خطأ في التحميل'),
          data: (targets) {
            if (targets.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Center(child: Text("لا توجد أهداف حالياً")),
              );
            }
            
            final brands = brandsAsync.asData?.value ?? [];
            final groupedTargets = <String, List<TargetModel>>{};
            for (final t in targets) {
              final bId = t.brandId ?? 'other';
              groupedTargets.putIfAbsent(bId, () => []).add(t);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in groupedTargets.entries) ...[
                  if (groupedTargets.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        brands.firstWhere((b) => b.id == entry.key, orElse: () => BrandModel(id: '', name: 'أخرى', logoUrl: '', isActive: true, createdAt: DateTime.now())).name,
                        style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: _TargetSquare(target: entry.value[0]),
                      ),
                      if (entry.value.length > 1) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TargetSquare(target: entry.value[1]),
                        ),
                      ] else ...[
                        const SizedBox(width: 12),
                        const Spacer(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TargetListScreen()));
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "عرض كل الأهداف",
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class _TargetSquare extends StatelessWidget {
  final TargetModel target;
  const _TargetSquare({required this.target});

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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.track_changes_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            target.productName ?? 'هدف عام',
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${target.achievedQty} / ${target.targetQty}',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: target.progress,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            color: target.isAchieved ? AppColors.success : AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
