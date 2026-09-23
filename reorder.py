
import codecs

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

old_list = """                  delegate: SliverChildListDelegate([
                    const _TargetsOverviewSection(),
                    const SizedBox(height: 24),
                    const _QuickActionsSection(),
                    const SizedBox(height: 24),
                    _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                  ]),"""

new_list = """                  delegate: SliverChildListDelegate([
                    const _QuickActionsSection(),
                    const SizedBox(height: 24),
                    const _TargetsOverviewSection(),
                    const SizedBox(height: 24),
                    _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                  ]),"""

content = content.replace(old_list, new_list)

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

