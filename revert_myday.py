import re

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("        // Coverage Stats\n        if (!widget.isEmbedded)\n          Positioned(", "        // Coverage Stats\n        Positioned(")

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)

with open("lib/features/rep/screens/my_day_tab.dart", "r", encoding="utf-8") as f:
    myday_content = f.read()

search_col = """            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _PinnedStatsBar(),
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: CustomScrollView("""

replace_col = """            child: AnimationLimiter(
              child: CustomScrollView("""

myday_content = myday_content.replace(search_col, replace_col)

search_close = """                  SliverFillRemaining(
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

replace_close = """                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _MapPreviewArea(scrollController: _scrollController),
                  ),
                ],
              ),
            ),
          );"""

myday_content = myday_content.replace(search_close, replace_close)

# Remove the PinnedStatsBar classes at the bottom
myday_content = re.sub(r'class _PinnedStatsBar extends ConsumerWidget \{.*', '', myday_content, flags=re.DOTALL)

with open("lib/features/rep/screens/my_day_tab.dart", "w", encoding="utf-8") as f:
    f.write(myday_content)

print("Reverted to original behavior")
