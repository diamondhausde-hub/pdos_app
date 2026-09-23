with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_logic = """      final sortedCenters = List<CenterModel>.from(centers)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final latest = sortedCenters.first;
      if (latest.latitude != null && latest.longitude != null) {
        _mapController.move(LatLng(latest.latitude!, latest.longitude!), 14.0);
        _hasInitialZoomed = true;
      }"""

replace_logic = """      final validCenters = centers.where((c) => c.latitude != null && c.longitude != null).toList();
      if (validCenters.isEmpty) return;
      
      validCenters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final latest = validCenters.first;
      _mapController.move(LatLng(latest.latitude!, latest.longitude!), 15.0);
      _hasInitialZoomed = true;"""

content = content.replace(search_logic, replace_logic)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
