with open("lib/features/rep/screens/my_day_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

pinned_stats_widget = """
class _PinnedStatsBar extends ConsumerWidget {
  const _PinnedStatsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverageAsync = ref.watch(coverageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return coverageAsync.when(
      data: (centers) {
        final visited = centers.where((c) => c.status == 'visited').length;
        final total = centers.length;
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(child: _CoverageStat(label: AppStrings.totalCenters, value: '$total')),
              Expanded(child: _CoverageStat(label: AppStrings.visited, value: '$visited')),
              Expanded(
                child: _CoverageStat(
                  label: AppStrings.coverage,
                  value: total > 0 ? '${(visited * 100 ~/ total)}%' : '0%',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              GestureDetector(
                onTap: () {
                  // Push a simple bottom sheet with centers list if needed
                  // Or navigate to a centers list screen
                  context.push('/rep/clients'); // Redirecting to clients tab for now
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.format_list_bulleted_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox(),
    );
  }
}

class _CoverageStat extends StatelessWidget {
  final String label;
  final String value;

  const _CoverageStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

"""

# Insert widget at the end of the file
if "class _PinnedStatsBar" not in content:
    content += "\n" + pinned_stats_widget

# Modify the build method to split the view
search_scroll_view = """            child: AnimationLimiter(
              child: CustomScrollView("""

replace_scroll_view = """            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _PinnedStatsBar(),
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: CustomScrollView("""

content = content.replace(search_scroll_view, replace_scroll_view)

# Add matching closing tags for the new Column and Expanded
search_closing = """                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MapPreviewArea(scrollController: _scrollController),
                  ),
                ],
              ),
            ),
          );"""

replace_closing = """                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MapPreviewArea(scrollController: _scrollController),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      );"""

content = content.replace(search_closing, replace_closing)

with open("lib/features/rep/screens/my_day_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Updated my_day_tab.dart layout")
