
import codecs
import re

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

# Replace the Padding wrapping CustomScrollView
old_scroll_view = """          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
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
          ),"""

new_scroll_view = """          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _QuickActionsSection(),
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
          ),"""

content = content.replace(old_scroll_view, new_scroll_view)

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

