with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """  void _onCenterTap(CoverageCenter center) {
    setState(() {
      _selectedCenter = center;
      _selectedRep = null;
    });
  }"""

replace_str = """  void _onCenterTap(CoverageCenter center) {
    setState(() {
      _selectedCenter = center;
      _selectedRep = null;
      _selectedCluster = null;
    });
  }"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
