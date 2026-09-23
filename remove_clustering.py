with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# Remove the `final clusters = _clusterCenters(validCenters, zoom);` logic
content = re.sub(r"\s*// Cluster markers\s*final clusters = _clusterCenters\(validCenters, zoom\);", "", content)

# Replace the MarkerLayer mapping
pattern = r"MarkerLayer\(\s*markers: clusters\.map\(\(group\) \{.*?(?=\s*\}\)\.toList\(\),\s*\),)"
replacement = r"""MarkerLayer(
                    markers: validCenters.map((center) {
                      return Marker(rotate: true,
                        point: LatLng(center.lat!, center.lng!),
                        width: 48,
                        height: 48,
                        child: _buildCenterMarker(center),
                      );"""

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
