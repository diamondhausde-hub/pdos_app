with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("""      return _ClusterGroup.cluster(
        avgLat, avgLng, group.length,
        visitedCount > group.length / 2,
      );""", """      return _ClusterGroup.cluster(
        avgLat, avgLng, group.length,
        visitedCount > group.length / 2,
        group,
      );""")

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
