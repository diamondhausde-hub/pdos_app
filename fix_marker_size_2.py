with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

pattern = r"(if \(group\.isCluster\) \{\s*return Marker\(\s*point: LatLng\(group\.lat, group\.lng\),\s*width:) 40,(.*?height:) 40,"
replacement = r"\1 48,\2 48,"

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
