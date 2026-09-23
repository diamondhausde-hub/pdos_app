with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      final centers = await ref.read(centersProvider.future);"""

replace_str = """  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      // Small delay to ensure MapController is fully attached and initialCameraFit has completed
      await Future.delayed(const Duration(milliseconds: 800));
      
      final centers = await ref.read(centersProvider.future);"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
