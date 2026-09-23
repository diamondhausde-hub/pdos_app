with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """  CoverageCenter? _selectedCenter;
  UserModel? _selectedRep;
  double _currentZoom = 5.0;"""

replace_str = """  CoverageCenter? _selectedCenter;
  UserModel? _selectedRep;
  _ClusterGroup? _selectedCluster;
  int _clusterPopupIndex = 0;
  double _currentZoom = 5.0;"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
