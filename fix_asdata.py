with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("final coverage = ref.read(coverageProvider).valueOrNull;", "final coverage = ref.read(coverageProvider).asData?.value;")

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
