with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      // Small delay to ensure MapController is fully attached and initialCameraFit has completed
      await Future.delayed(const Duration(milliseconds: 800));
      
      final centers = await ref.read(centersProvider.future);
      if (centers.isEmpty) return;
      
      final validCenters = centers.where((c) => c.latitude != null && c.longitude != null).toList();
      if (validCenters.isEmpty) return;
      
      validCenters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final latest = validCenters.first;
      _mapController.move(LatLng(latest.latitude!, latest.longitude!), 15.0);
      _hasInitialZoomed = true;
    } catch (e) {
      debugPrint('Error zooming to latest center: $e');
    }
  }"""

replace_str = """  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      // Small delay to ensure MapController is fully attached and initialCameraFit has completed
      await Future.delayed(const Duration(milliseconds: 600));
      
      final centers = await ref.read(centersProvider.future);
      if (centers.isNotEmpty) {
        final validCenters = centers.where((c) => c.latitude != null && c.longitude != null).toList();
        if (validCenters.isNotEmpty) {
          validCenters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final latest = validCenters.first;
          _mapController.move(LatLng(latest.latitude!, latest.longitude!), 15.0);
          _hasInitialZoomed = true;
          return;
        }
      }
    } catch (e) {
      debugPrint('Error zooming to latest center: $e');
    }
    
    // Fallback if centersProvider fails or is empty, try to get from coverageAsync directly
    try {
      final coverage = ref.read(coverageProvider).valueOrNull;
      if (coverage != null && coverage.isNotEmpty) {
         final valid = coverage.where((c) => c.lat != null && c.lng != null).toList();
         if (valid.isNotEmpty) {
           // We can't sort by createdAt, so just take the last in the list (often the newest if ASC, or first if DESC)
           // Let's assume the API might return newest last or first. We will just take the last one.
           final latest = valid.last;
           _mapController.move(LatLng(latest.lat!, latest.lng!), 15.0);
           _hasInitialZoomed = true;
         }
      }
    } catch (_) {}
  }"""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
