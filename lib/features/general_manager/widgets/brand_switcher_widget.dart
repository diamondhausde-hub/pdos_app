import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/brand_provider.dart';

class BrandSwitcherWidget extends ConsumerWidget {
  const BrandSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);
    final selectedBrandId = ref.watch(selectedBrandIdProvider);

    return brandsAsync.when(
      data: (brands) {
        if (brands.isEmpty) return const SizedBox.shrink();

        return PopupMenuButton<String?>(
          initialValue: selectedBrandId,
          tooltip: 'Switch Brand',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: AppColors.surface,
          elevation: 4,
          offset: const Offset(0, 45),
          onSelected: (String? newBrandId) {
            ref.read(selectedBrandIdProvider.notifier).state = newBrandId;
          },
          itemBuilder: (context) {
            final items = <PopupMenuEntry<String?>>[];

            // "All Brands" option
            items.add(
              PopupMenuItem<String?>(
                value: null,
                child: Row(
                  children: [
                    Icon(
                      Icons.all_inclusive_rounded,
                      color: selectedBrandId == null ? AppColors.primary : AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'All Brands',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: selectedBrandId == null ? AppColors.primary : AppColors.onSurface,
                        fontWeight: selectedBrandId == null ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );

            items.add(const PopupMenuDivider());

            // Individual brands
            for (final brand in brands) {
              final isSelected = selectedBrandId == brand.id;
              items.add(
                PopupMenuItem<String?>(
                  value: brand.id,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            brand.name.substring(0, 1).toUpperCase(),
                            style: AppTextStyles.labelSm.copyWith(
                              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        brand.name,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selectedBrandId == null ? Icons.all_inclusive_rounded : Icons.storefront_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  selectedBrandId == null
                      ? 'All Brands'
                      : brands.firstWhere((b) => b.id == selectedBrandId, orElse: () => brands.first).name,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
