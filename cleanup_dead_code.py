import re

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

# Remove unused fields
content = re.sub(r"  _ClusterGroup\? _selectedCluster;\n", "", content)
content = re.sub(r"  int _clusterPopupIndex = 0;\n", "", content)

# Remove _clearSelection references to _selectedCluster
content = re.sub(r"\s*_selectedCluster = null;", "", content)
# It might leave an empty line, but that's fine.

# Remove _ClusterGroup class completely
content = re.sub(r"class _ClusterGroup \{.*?\}\n\n", "", content, flags=re.DOTALL)

# Remove _clusterCenters method
content = re.sub(r"  static const double _clusterCellPixels = 80\.0;.*?return grid\.values\.map\(\(group\) \{.*?\}\)\.toList\(\);\n  \}\n", "", content, flags=re.DOTALL)

# Remove _zoomToCluster method
content = re.sub(r"  void _zoomToCluster\(_ClusterGroup cluster\) \{.*?\}\n\n", "", content, flags=re.DOTALL)

# Remove _buildClusterMarker method
content = re.sub(r"  Widget _buildClusterMarker\(_ClusterGroup cluster\) \{.*?\}\n\n", "", content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
