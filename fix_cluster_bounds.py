with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """    for (var c in cluster.centers) {
      if (c.lat! < minLat) minLat = c.lat!;
      if (c.lat! > maxLat) maxLat = c.lat!;
      if (c.lng! < minLng) minLng = c.lng!;
      if (c.lng! > maxLng) maxLng = c.lng!;
    }
    
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
        padding: const EdgeInsets.all(80.0),
      )
    );
  }"""

replace_str = """    for (var c in cluster.centers) {
      if (c.lat! < minLat) minLat = c.lat!;
      if (c.lat! > maxLat) maxLat = c.lat!;
      if (c.lng! < minLng) minLng = c.lng!;
      if (c.lng! > maxLng) maxLng = c.lng!;
    }
    
    final isSinglePoint = (maxLat - minLat).abs() < 0.00001 && (maxLng - minLng).abs() < 0.00001;
    
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

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
