import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/add_target_sheet.dart';

class TargetsManagementTab extends ConsumerWidget {
  const TargetsManagementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetsAsync = ref.watch(targetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.targetManagement),
      ),
      body: targetsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading targets: $e')),
        data: (targets) {
          if (targets.isEmpty) {
            return const Center(child: Text(AppStrings.noTargetsCurrentlySet));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(targetsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final target = targets[index];
                final isGlobal = target.isGlobal;
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              target.productName ?? 'Unknown Product',
                              style: AppTextStyles.h3,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isGlobal ? AppColors.primaryContainer : AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isGlobal ? 'Global' : (target.repName ?? 'Specific Rep'),
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: isGlobal ? AppColors.onPrimaryContainer : AppColors.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.targetQuantity, style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondaryLight)),
                                Text(target.targetQty.toString(), style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(AppStrings.period, style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondaryLight)),
                                Text(
                                  '${DateFormat('MM/dd').format(target.periodStart)} - ${DateFormat('MM/dd').format(target.periodEnd)}',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AddTargetSheet(),
          );
        },
        icon: Icon(Icons.add),
        label: Text(AppStrings.addTarget),
      ),
    );
  }
}
