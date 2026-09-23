with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# Fix width and height for isCluster
pattern = r"(\s*if \(group\.isCluster\) \{\s*return Marker\(\s*point: LatLng\(group\.lat, group\.lng\),\s*width:) 52,(.*?height:) 52,"
replacement = r"\1 40,\2 40,"

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
