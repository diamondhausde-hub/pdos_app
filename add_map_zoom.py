import re

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add import
content = content.replace(
    "import '../../../core/models/coverage_model.dart';",
    "import '../../../core/models/coverage_model.dart';\nimport '../../../core/models/center_model.dart';"
)

# 2. Add _goToLatestCenter method inside the state class
search_goTo = "  void _flyToLocation(double lat, double lng, {double zoom = 15.0, CoverageCenter? center, UserModel? rep}) {"

replace_goTo = """  bool _hasInitialZoomed = false;

  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      final centers = await ref.read(centersProvider.future);
      if (centers.isEmpty) return;
      
      final sortedCenters = List<CenterModel>.from(centers)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final latest = sortedCenters.first;
      if (latest.latitude != null && latest.longitude != null) {
        _mapController.move(LatLng(latest.latitude!, latest.longitude!), 14.0);
        _hasInitialZoomed = true;
      }
    } catch (e) {
      debugPrint('Error zooming to latest center: $e');
    }
  }

  void _flyToLocation(double lat, double lng, {double zoom = 15.0, CoverageCenter? center, UserModel? rep}) {"""

content = content.replace(search_goTo, replace_goTo)

# 3. Attach onMapReady for Centers map
search_mapOptions = """                  initialCameraFit: isSinglePoint
                    ? null
                    : CameraFit.bounds(
                        bounds: LatLngBounds(
                          LatLng(minLat, minLng),
                          LatLng(maxLat, maxLng),
                        ),
                        padding: const EdgeInsets.only(top: 120, bottom: 80, left: 40, right: 40),
                      ),
                  onTap: (_, _) => _clearSelection(),
                ),"""

replace_mapOptions = """                  initialCameraFit: isSinglePoint
                    ? null
                    : CameraFit.bounds(
                        bounds: LatLngBounds(
                          LatLng(minLat, minLng),
                          LatLng(maxLat, maxLng),
                        ),
                        padding: const EdgeInsets.only(top: 120, bottom: 80, left: 40, right: 40),
                      ),
                  onMapReady: () {
                    _goToLatestCenter();
                  },
                  onTap: (_, _) => _clearSelection(),
                ),"""

content = content.replace(search_mapOptions, replace_mapOptions)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
