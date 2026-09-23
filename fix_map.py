
import codecs
import re

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

new_map_preview = """class _MapPreviewArea extends StatelessWidget {
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
"""

content = re.sub(r"class _MapPreviewArea extends StatelessWidget \{[\s\S]*?\}\n\}", new_map_preview, content)

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

