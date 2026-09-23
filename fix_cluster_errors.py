import re

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

# Fix cluster args
content = content.replace("visitedCount > group.length / 2,\n        );", "visitedCount > group.length / 2,\n          group,\n        );")

# Fix MapController
content = content.replace("_mapController.camera.fitCamera(", "_mapController.fitCamera(")

# Fix bracket
search_bracket = """        ],
      ),
    );
  }

  Widget _buildCenterMarker"""

replace_bracket = """        ],
      ),
    ),
    );
  }

  Widget _buildCenterMarker"""

content = content.replace(search_bracket, replace_bracket)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
