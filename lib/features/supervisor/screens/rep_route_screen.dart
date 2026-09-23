import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';

class RepRouteScreen extends ConsumerStatefulWidget {
  final UserModel rep;

  const RepRouteScreen({super.key, required this.rep});

  @override
  ConsumerState<RepRouteScreen> createState() => _RepRouteScreenState();
}

class _RepRouteScreenState extends ConsumerState<RepRouteScreen> {
  @override
  Widget build(BuildContext context) {
    final teamLocationsAsync = ref.watch(teamLocationsProvider);
    final repLocation = teamLocationsAsync.asData?.value
        .where((u) => u.id == widget.rep.id)
        .firstOrNull;

    final isStale = repLocation == null ||
        repLocation.lastLocationUpdate == null ||
        DateTime.now().difference(repLocation.lastLocationUpdate!) > const Duration(minutes: 10);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.rep.fullName.split(' ').first}\'s Movements'),
      ),
      body: Column(
        children: [
          // Map showing rep location
          Expanded(
            flex: 2,
            child: repLocation != null && repLocation.lastLat != null && repLocation.lastLng != null
                ? FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(repLocation.lastLat!, repLocation.lastLng!),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.pdos.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(repLocation.lastLat!, repLocation.lastLng!),
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isStale ? AppColors.onSurfaceVariant : AppColors.primary,
                                border: Border.all(color: AppColors.onPrimary, width: 3),
                              ),
                              child: Icon(Icons.person, color: AppColors.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(child: Text(AppStrings.repLocationIsCurrently)),
          ),

          // Info Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.onPrimary,
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.movementInfo, style: AppTextStyles.h4),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Icon(Icons.circle, size: 12, color: isStale ? AppColors.onSurfaceVariant : AppColors.success),
                            const SizedBox(height: 6),
                            Text(isStale ? 'Inactive' : 'Active', style: AppTextStyles.labelMedium),
                            Text(AppStrings.status, style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Icon(Icons.access_time, size: 16, color: AppColors.primary),
                            const SizedBox(height: 6),
                            Text(
                              repLocation?.lastLocationUpdate != null
                                  ? DateFormat('HH:mm').format(repLocation!.lastLocationUpdate!)
                                  : '--:--',
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(AppStrings.lastUpdate, style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (repLocation != null && repLocation.lastLat != null && repLocation.lastLng != null)
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        '${repLocation.lastLat!.toStringAsFixed(4)}, ${repLocation.lastLng!.toStringAsFixed(4)}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Rep info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    widget.rep.fullName.isNotEmpty ? widget.rep.fullName[0].toUpperCase() : '?',
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.rep.fullName, style: AppTextStyles.h4),
                      Text(widget.rep.region ?? 'Not Specified', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
