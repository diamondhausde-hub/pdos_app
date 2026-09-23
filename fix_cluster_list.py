with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """    final isSinglePoint = (maxLat - minLat).abs() < 0.00001 && (maxLng - minLng).abs() < 0.00001;
    
    if (isSinglePoint) {
      _mapController.move(LatLng(minLat, minLng), 16.0);
    } else {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
          padding: const EdgeInsets.all(80.0),
        )
      );
    }
  }"""

replace_str = """    final isSinglePoint = (maxLat - minLat).abs() < 0.00001 && (maxLng - minLng).abs() < 0.00001;
    
    double currentZoom = 5.0;
    try {
      currentZoom = _mapController.camera.zoom;
    } catch (_) {
      currentZoom = _currentZoom;
    }
    
    if (isSinglePoint || currentZoom >= 15.5) {
      _mapController.move(LatLng(minLat, minLng), 16.0);
      final isDark = Theme.of(context).brightness == Brightness.dark;
      _showCenterListSheet(cluster.centers, isDark);
    } else {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
          padding: const EdgeInsets.all(80.0),
        )
      );
    }
  }"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
