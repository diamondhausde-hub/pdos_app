with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

pattern = r"(Widget _buildClusterMarker\(_ClusterGroup cluster\) \{).*?(\n  Widget _buildCenterMarker\(CoverageCenter center\) \{)"

replacement = r"""\1
    // We visually represent a cluster as a single center marker.
    // If multiple centers are closely overlapping, it will just show the marker for the first one.
    return _buildCenterMarker(cluster.centers.first);
  }
\2"""

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
