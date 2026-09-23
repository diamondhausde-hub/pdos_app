with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

# 1. Update _ClusterGroup
search_cluster_group = """class _ClusterGroup {
  final double lat;
  final double lng;
  final int count;
  final bool isCluster;
  final bool isMajorityVisited;
  final CoverageCenter? center;

  _ClusterGroup.single(this.center)
    : lat = center!.lat!,
      lng = center.lng!,
      count = 1,
      isCluster = false,
      isMajorityVisited = center.status == 'visited';

  _ClusterGroup.cluster(this.lat, this.lng, this.count, this.isMajorityVisited)
    : isCluster = true,
      center = null;
}"""

replace_cluster_group = """class _ClusterGroup {
  final double lat;
  final double lng;
  final int count;
  final bool isCluster;
  final bool isMajorityVisited;
  final CoverageCenter? center;
  final List<CoverageCenter> centers;

  _ClusterGroup.single(this.center)
    : lat = center!.lat!,
      lng = center.lng!,
      count = 1,
      isCluster = false,
      isMajorityVisited = center.status == 'visited',
      centers = [center];

  _ClusterGroup.cluster(this.lat, this.lng, this.count, this.isMajorityVisited, this.centers)
    : isCluster = true,
      center = null;
}"""

content = content.replace(search_cluster_group, replace_cluster_group)

# 2. Update _clusterCenters
search_clusterCenters = """      return grid.values.map((group) {
        if (group.length == 1) return _ClusterGroup.single(group.first);
        final avgLat = group.map((c) => c.lat!).reduce((a, b) => a + b) / group.length;
        final avgLng = group.map((c) => c.lng!).reduce((a, b) => a + b) / group.length;
        final visitedCount = group.where((c) => c.status == 'visited').length;
        return _ClusterGroup.cluster(
          avgLat, avgLng, group.length,
          visitedCount > group.length / 2,
        );
      }).toList();"""

replace_clusterCenters = """      return grid.values.map((group) {
        if (group.length == 1) return _ClusterGroup.single(group.first);
        final avgLat = group.map((c) => c.lat!).reduce((a, b) => a + b) / group.length;
        final avgLng = group.map((c) => c.lng!).reduce((a, b) => a + b) / group.length;
        final visitedCount = group.where((c) => c.status == 'visited').length;
        return _ClusterGroup.cluster(
          avgLat, avgLng, group.length,
          visitedCount > group.length / 2,
          group,
        );
      }).toList();"""

content = content.replace(search_clusterCenters, replace_clusterCenters)

# 3. Add onTap and method for zoom
search_buildClusterMarker = """  Widget _buildClusterMarker(_ClusterGroup cluster) {
    final isMajorityVisited = cluster.isMajorityVisited;
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack("""

replace_buildClusterMarker = """  void _zoomToCluster(_ClusterGroup cluster) {
    if (cluster.centers.isEmpty) return;
    
    double minLat = cluster.centers.first.lat!;
    double maxLat = cluster.centers.first.lat!;
    double minLng = cluster.centers.first.lng!;
    double maxLng = cluster.centers.first.lng!;

    for (var c in cluster.centers) {
      if (c.lat! < minLat) minLat = c.lat!;
      if (c.lat! > maxLat) maxLat = c.lat!;
      if (c.lng! < minLng) minLng = c.lng!;
      if (c.lng! > maxLng) maxLng = c.lng!;
    }
    
    _mapController.camera.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
        padding: const EdgeInsets.all(80.0),
      )
    );
  }

  Widget _buildClusterMarker(_ClusterGroup cluster) {
    final isMajorityVisited = cluster.isMajorityVisited;
    return GestureDetector(
      onTap: () => _zoomToCluster(cluster),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack("""

content = content.replace(search_buildClusterMarker, replace_buildClusterMarker)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
