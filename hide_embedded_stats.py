with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

# I need to find the "// Coverage Stats" section and wrap it or just hide it if isEmbedded.
search_str = """        // Coverage Stats
        Positioned(
          left: 16,
          right: 16,
          top: 16,
          child: coverageAsync.when("""

replace_str = """        // Coverage Stats
        if (!widget.isEmbedded)
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: coverageAsync.when("""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Updated coverage_map_tab.dart")
