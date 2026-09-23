with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
pattern = r"(\s*)if \(_selectedCluster != null && _selectedCluster!\.centers\.length > 1\).*?(?=\s*Row\(\s*children: \[)"
content = re.sub(pattern, r"\1", content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
