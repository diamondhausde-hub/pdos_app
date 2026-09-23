with open("lib/features/supervisor/screens/coverage_map_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row("""

replace_str = """            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedCluster != null && _selectedCluster!.centers.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _clusterPopupIndex = (_clusterPopupIndex - 1) % _selectedCluster!.centers.length;
                              if (_clusterPopupIndex < 0) _clusterPopupIndex += _selectedCluster!.centers.length;
                              _selectedCenter = _selectedCluster!.centers[_clusterPopupIndex];
                            });
                          },
                          child: Icon(Icons.chevron_left, size: 24, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                        Text(
                          '${_clusterPopupIndex + 1} / ${_selectedCluster!.centers.length}',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _clusterPopupIndex = (_clusterPopupIndex + 1) % _selectedCluster!.centers.length;
                              _selectedCenter = _selectedCluster!.centers[_clusterPopupIndex];
                            });
                          },
                          child: Icon(Icons.chevron_right, size: 24, color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                Row("""

content = content.replace(search_str, replace_str)

with open("lib/features/supervisor/screens/coverage_map_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
