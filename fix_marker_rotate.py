with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# Replace `Marker(` with `Marker(rotate: true,`
content = re.sub(r"return Marker\(", r"return Marker(rotate: true,", content)
content = re.sub(r"markers: \[\s*Marker\(", r"markers: [\n                          Marker(rotate: true,", content)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
