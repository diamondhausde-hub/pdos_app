with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

pattern = r"(\s+error: \(_, _\) => const SizedBox\(\),\s*\),\s*\),\s*)(\],)"
replacement = r"""\1
        // Reset Rotation Button
        Positioned(
          right: 16,
          top: 100,
          child: InkWell(
            onTap: () {
              // Reset rotation only, keep zoom unchanged
              _mapController.rotate(0.0);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.explore, color: AppColors.primary, size: 24),
            ),
          ),
        ),
\2"""

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
