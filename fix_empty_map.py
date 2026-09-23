import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\coverage_map_tab.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace for coverage map
old_centers = '''              if (validCenters.isEmpty) {
                return const Center(child: Text(AppStrings.noCentersWithCoordinates));
              }'''
new_centers = '''              if (validCenters.isEmpty) {
                return Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: LatLng(24.7136, 46.6753), // Riyadh default
                        initialZoom: 5.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: isDark
                              ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.pdos.app',
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppStrings.noCentersWithCoordinates,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }'''
content = content.replace(old_centers, new_centers)

# Replace for live team
old_reps = '''              if (reps.isEmpty) {
                return const Center(child: Text(AppStrings.noActiveRepsFound));
              }'''
new_reps = '''              if (reps.isEmpty) {
                return Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: LatLng(24.7136, 46.6753), // Riyadh default
                        initialZoom: 5.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: isDark
                              ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.pdos.app',
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppStrings.noActiveRepsFound,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }'''
content = content.replace(old_reps, new_reps)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Updated successfully')
