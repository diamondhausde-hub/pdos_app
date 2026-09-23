with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """    if (isSinglePoint || currentZoom >= 15.5) {
      _mapController.move(LatLng(minLat, minLng), 16.0);
      setState(() {"""

replace_str = """    if (isSinglePoint || currentZoom >= 15.5) {
      _mapController.move(LatLng(cluster.lat, cluster.lng), currentZoom < 16.0 ? 16.0 : currentZoom);
      setState(() {"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
