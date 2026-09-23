with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """    if (isSinglePoint || currentZoom >= 15.5) {
      _mapController.move(LatLng(minLat, minLng), 16.0);
      final isDark = Theme.of(context).brightness == Brightness.dark;
      _showCenterListSheet(cluster.centers, isDark);
    }"""

replace_str = """    if (isSinglePoint || currentZoom >= 15.5) {
      _mapController.move(LatLng(minLat, minLng), 16.0);
      setState(() {
        _selectedCluster = cluster;
        _clusterPopupIndex = 0;
        _selectedCenter = cluster.centers.first;
        _selectedRep = null;
      });
    }"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
