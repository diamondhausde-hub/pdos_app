import codecs
import re

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    content = f.read()

imports = """import '../../../core/theme/theme.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/models/brand_model.dart';
"""
content = content.replace("import '../../../core/theme/theme.dart';", imports)

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
              final items = <DropdownMenuItem<String?>>[
                const DropdownMenuItem(value: null, child: Text('جميع البراندات')),
              ];
              for (final b in brands) {
                items.add(DropdownMenuItem(value: b.id, child: Text(b.name ?? 'براند')));
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedBrandId,
                    isDense: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
                    ),
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    items: items,
                    onChanged: (val) {
                      ref.read(selectedBrandIdProvider.notifier).state = val;
                    },
                  ),
                ),
              );
            },
          );
        },
      ),"""

# Regex to find title: Row(...) and replace it up to the `actions: [`
title_pattern = r'title: Row\(.*?\]\s*,\s*\)\s*,\s*actions: \['
# Need to use DOTALL
content = re.sub(title_pattern, new_title + '\n        actions: [', content, flags=re.DOTALL)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(content)
