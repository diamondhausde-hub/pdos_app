import codecs
import re

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    content = f.read()

new_title = """title: Consumer(
        builder: (context, ref, child) {
          final selectedBrandId = ref.watch(selectedBrandIdProvider);
          final brandsAsync = ref.watch(brandsProvider);

          return brandsAsync.when(
            loading: () => const SizedBox(
              width: 100,
              height: 20,
              child: LinearProgressIndicator(),
            ),
            error: (e, s) => const Text('Error'),
            data: (brands) {
              final selectedBrand = brands.firstWhere(
                (b) => b.id == selectedBrandId, 
                orElse: () => brands.isNotEmpty ? brands.first : throw Exception()
              );
              final isAll = selectedBrandId == null;
              final displayName = isAll ? 'جميع البراندات' : selectedBrand.name;

              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.outline.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Text(
                              'اختر البراند',
                              style: AppTextStyles.headlineSm.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isAll ? AppColors.primary : AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isAll ? AppColors.primary : AppColors.outline.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.business_rounded,
                                  color: isAll ? Colors.white : AppColors.onSurfaceVariant,
                                ),
                              ),
                              title: Text(
                                'جميع البراندات',
                                style: AppTextStyles.labelLg.copyWith(
                                  fontWeight: isAll ? FontWeight.bold : FontWeight.normal,
                                  color: isAll ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                              trailing: isAll
                                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                                  : null,
                              onTap: () {
                                ref.read(selectedBrandIdProvider.notifier).state = null;
                                Navigator.pop(context);
                              },
                            ),
                            ...brands.map((b) {
                              final isSelected = b.id == selectedBrandId;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.branding_watermark_rounded,
                                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                  ),
                                ),
                                title: Text(
                                  b.name ?? 'براند',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                                    : null,
                                onTap: () {
                                  ref.read(selectedBrandIdProvider.notifier).state = b.id;
                                  Navigator.pop(context);
                                },
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAll ? Icons.business_rounded : Icons.branding_watermark_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayName ?? '',
                        style: AppTextStyles.labelLg.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),"""

# Replace the title consumer block
title_pattern = r'title: Consumer\(.*?actions: \['
content = re.sub(title_pattern, new_title + '\n        actions: [', content, flags=re.DOTALL)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(content)
