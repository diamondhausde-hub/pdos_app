import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/coverage_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_card.dart';
import '../../shared/screens/public_profile_screen.dart';

class CoverageMapTab extends ConsumerStatefulWidget {
  final bool isEmbedded;
  final ScrollController? scrollController;
  final VoidCallback? onNavigateToTeam;
  final VoidCallback? onNavigateToReview;
  final VoidCallback? onNavigateToPerformance;
  final VoidCallback? onNavigateToCenters;

  const CoverageMapTab({
    super.key, 
    this.isEmbedded = false, 
    this.scrollController,
    this.onNavigateToTeam,
    this.onNavigateToReview,
    this.onNavigateToPerformance,
    this.onNavigateToCenters,
  });

  @override
  ConsumerState<CoverageMapTab> createState() => _CoverageMapTabState();
}

class _CoverageMapTabState extends ConsumerState<CoverageMapTab> {
  final bool _showLiveTeam = false;

  final MapController _mapController = MapController();
  Timer? _refreshTimer;

  CoverageCenter? _selectedCenter;
  UserModel? _selectedRep;
  double _currentZoom = 5.0;


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        ref.invalidate(teamLocationsProvider);
        ref.invalidate(coverageProvider);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  bool _hasInitialZoomed = false;

  Future<void> _goToLatestCenter() async {
    if (_hasInitialZoomed) return;
    try {
      // Small delay to ensure MapController is fully attached and initialCameraFit has completed
      await Future.delayed(const Duration(milliseconds: 600));
      
      final centers = await ref.read(centersProvider.future);
      if (centers.isNotEmpty) {
        final validCenters = centers.where((c) => c.latitude != null && c.longitude != null).toList();
        if (validCenters.isNotEmpty) {
          validCenters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final latest = validCenters.first;
          _mapController.move(LatLng(latest.latitude!, latest.longitude!), 15.0);
          _hasInitialZoomed = true;
          return;
        }
      }
    } catch (e) {
      debugPrint('Error zooming to latest center: $e');
    }
    
    // Fallback if centersProvider fails or is empty, try to get from coverageAsync directly
    try {
      final coverage = ref.read(coverageProvider).asData?.value;
      if (coverage != null && coverage.isNotEmpty) {
         final valid = coverage.where((c) => c.lat != null && c.lng != null).toList();
         if (valid.isNotEmpty) {
           // We can't sort by createdAt, so just take the last in the list (often the newest if ASC, or first if DESC)
           // Let's assume the API might return newest last or first. We will just take the last one.
           final latest = valid.last;
           _mapController.move(LatLng(latest.lat!, latest.lng!), 15.0);
           _hasInitialZoomed = true;
         }
      }
    } catch (_) {}
  }

  void _flyToLocation(double lat, double lng, {double zoom = 15.0, CoverageCenter? center, UserModel? rep}) {
    if (center != null) {
      setState(() {
        _selectedCenter = center;
        _selectedRep = null;
      });
    } else if (rep != null) {
      setState(() {
        _selectedRep = rep;
        _selectedCenter = null;
      });
    }

    _mapController.move(LatLng(lat, lng), zoom);
  }

  // ── Grid-based Marker Clustering ──────────────────────────────────────────────


  Widget _buildCenterMarker(CoverageCenter center) {
    final isVisited = center.status == 'visited';
    return GestureDetector(
      onTap: () => _onCenterTap(center),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.location_on,
            size: 40,
            color: isVisited ? AppColors.success : AppColors.error,
          ),
          if (center.hasSupervisorNote)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.info,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rate_review, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _onRepTap(UserModel rep) {
    setState(() {
      _selectedRep = rep;
      _selectedCenter = null;
    });
  }

  Widget _buildRepMarker(UserModel rep) {
    final isStale = rep.lastLocationUpdate == null ||
        DateTime.now().difference(rep.lastLocationUpdate!) > const Duration(minutes: 10);
    return GestureDetector(
      onTap: () => _onRepTap(rep),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: isStale ? Colors.grey : AppColors.primary,
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 24),
      ),
    );
  }

  // ── Marker Popup ──────────────────────────────────────────────────────────────

  Widget _buildInfoWindow(double lat, double lng) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_selectedCenter != null) {
      final c = _selectedCenter!;
      final isVisited = c.status == 'visited';
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                children: [
                  Icon(
                    isVisited ? Icons.check_circle : Icons.warning,
                    size: 16,
                    color: isVisited ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      c.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, size: 12, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      c.assignedRepId ?? 'Unassigned',
                      style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (c.lastVisitDate != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(c.lastVisitDate!),
                      style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
              if (c.hasSupervisorNote && c.supervisorNote != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.rate_review, size: 13, color: AppColors.info),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          c.supervisorNote!,
                          style: AppTextStyles.caption.copyWith(fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (c.centerId.isNotEmpty) ...[
                const SizedBox(height: 6),
                _LatestNotesSection(centerId: c.centerId),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/center/${c.centerId}'),
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text(AppStrings.lbl_11, style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ),
              if (c.lat != null && c.lng != null) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => _openInGoogleMaps(c.lat!, c.lng!),
                    icon: const Icon(Icons.map_outlined, size: 14),
                    label: const Text(AppStrings.openInGoogleMaps, style: TextStyle(fontSize: 11)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (_selectedRep != null) {
      final r = _selectedRep!;
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.fullName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showRepDetails(r),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    textStyle: AppTextStyles.labelMedium,
                  ),
                  child: const Text(AppStrings.viewProfile),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ── Interactions ──────────────────────────────────────────────────────────────

  void _onCenterTap(CoverageCenter center) {
    setState(() {
      _selectedCenter = center;
      _selectedRep = null;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedCenter = null;
      _selectedRep = null;
    });
  }

  void _openInGoogleMaps(double lat, double lng) {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showRepDetails(UserModel rep) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final isStale = rep.lastLocationUpdate == null ||
            DateTime.now().difference(rep.lastLocationUpdate!) > const Duration(minutes: 10);
        final updateStr = rep.lastLocationUpdate != null
            ? DateFormat('HH:mm').format(rep.lastLocationUpdate!)
            : 'N/A';
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isStale ? Colors.grey : AppColors.primary,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rep.fullName, style: AppTextStyles.h3),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isStale ? Colors.grey : AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isStale ? 'Inactive' : 'Active',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isStale ? Colors.grey : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text('Last Update: $updateStr', style: AppTextStyles.bodyMedium),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicProfileScreen(userId: rep.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_search_rounded),
                  label: const Text(AppStrings.viewPublicProfile),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Searchable Center List Sheet ──────────────────────────────────────────────

  void _showCenterListSheet(List<CoverageCenter> allCenters, bool isDark) {
    final validCenters = allCenters.where((c) => c.lat != null && c.lng != null).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                final query = _searchQuery;
                final filtered = query.isEmpty
                    ? validCenters
                    : validCenters.where((c) =>
                        c.name.toLowerCase().contains(query) ||
                        (c.assignedRepId?.toLowerCase().contains(query) ?? false))
                    .toList();

                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.surfaceContainerLowest,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 8),
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              'Centers (${filtered.length})',
                              style: AppTextStyles.h3,
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => Navigator.pop(ctx),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                      // Search field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: AppStrings.searchCenterOrRep,
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // List
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  'No centers match your search',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final c = filtered[index];
                                  final isVisited = c.status == 'visited';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: AppCard(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      onTap: () {
                                        Navigator.pop(ctx);
                                        _flyToLocation(c.lat!, c.lng!, center: c);
                                      },
                                      variant: isVisited ? AppCardVariant.normal : AppCardVariant.alert,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: (isVisited ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              isVisited ? Icons.check_circle : Icons.warning,
                                              size: 18,
                                              color: isVisited ? AppColors.success : AppColors.error,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  c.name,
                                                  style: AppTextStyles.bodyMedium.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 11,
                                                      color: AppColors.onSurfaceVariant,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      c.lastVisitDate != null
                                                          ? DateFormat('yyyy-MM-dd').format(c.lastVisitDate!)
                                                          : 'Not visited',
                                                      style: AppTextStyles.caption.copyWith(
                                                        color: AppColors.onSurfaceVariant,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: (isVisited ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              isVisited ? 'Visited' : 'Pending',
                                              style: AppTextStyles.labelSmall.copyWith(
                                                color: isVisited ? AppColors.success : AppColors.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Top Toggle Widgets ────────────────────────────────────────────────────────

  // ── Build ─────────────────────────────────────────────────────────────────────


  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Quick Actions",
            style: AppTextStyles.headlineSm.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.groups_rounded,
                    color: AppColors.primary,
                    title: AppStrings.team,
                    onTap: () => widget.onNavigateToTeam?.call(),
                  ),
                  _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.rate_review_rounded,
                    color: AppColors.secondary,
                    title: AppStrings.review,
                    onTap: () => widget.onNavigateToReview?.call(),
                  ),
                  _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.insights_rounded,
                    color: AppColors.tertiary,
                    title: AppStrings.performance,
                    onTap: () => widget.onNavigateToPerformance?.call(),
                  ),
                  _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.store_rounded,
                    color: AppColors.info,
                    title: AppStrings.centers,
                    onTap: () => widget.onNavigateToCenters?.call(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required double width,
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final coverageAsync = ref.watch(coverageProvider);
    final teamLocationsAsync = ref.watch(teamLocationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget mapStack = Stack(
      children: [
        // Map Layer
        if (!_showLiveTeam)
          coverageAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading map: $err')),
            data: (List<CoverageCenter> centers) {
              final validCenters = centers.where((c) => c.lat != null && c.lng != null).toList();
              if (validCenters.isEmpty) {
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
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
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
              }

              var minLat = validCenters.first.lat!;
              var maxLat = validCenters.first.lat!;
              var minLng = validCenters.first.lng!;
              var maxLng = validCenters.first.lng!;

              for (var c in validCenters) {
                if (c.lat! < minLat) minLat = c.lat!;
                if (c.lat! > maxLat) maxLat = c.lat!;
                if (c.lng! < minLng) minLng = c.lng!;
                if (c.lng! > maxLng) maxLng = c.lng!;
              }

              final isSinglePoint = (maxLat - minLat).abs() < 0.001 && (maxLng - minLng).abs() < 0.001;

              double zoom;
              try {
                zoom = _mapController.camera.zoom;
              } catch (_) {
                zoom = _currentZoom;
              }
              _currentZoom = zoom;

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    (minLat + maxLat) / 2,
                    (minLng + maxLng) / 2,
                  ),
                  initialZoom: isSinglePoint ? 12.0 : 5.0,
                  initialCameraFit: isSinglePoint
                    ? null
                    : CameraFit.bounds(
                        bounds: LatLngBounds(
                          LatLng(minLat, minLng),
                          LatLng(maxLat, maxLng),
                        ),
                        padding: const EdgeInsets.only(top: 120, bottom: 80, left: 40, right: 40),
                      ),
                  onMapReady: () {
                    _goToLatestCenter();
                  },
                  onTap: (_, _) => _clearSelection(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: isDark
                        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.pdos.app',
                  ),
                  // Clustered markers
                  MarkerLayer(
                    markers: validCenters.map((center) {
                      return Marker(rotate: true,
                        point: LatLng(center.lat!, center.lng!),
                        width: 48,
                        height: 48,
                        child: _buildCenterMarker(center),
                      );
                    }).toList(),
                  ),
                  // Selected center popup
                  if (_selectedCenter != null && _selectedCenter!.lat != null && _selectedCenter!.lng != null)
                    MarkerLayer(
                      markers: [
                          Marker(rotate: true,
                          point: LatLng(_selectedCenter!.lat!, _selectedCenter!.lng!),
                          width: 240,
                          height: 280,
                          alignment: Alignment.bottomCenter,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildInfoWindow(_selectedCenter!.lat!, _selectedCenter!.lng!),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          )
        else
          teamLocationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading live team: $err')),
            data: (List<UserModel> reps) {
              if (reps.isEmpty) {
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
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
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
              }

              double minLat = 90.0, maxLat = -90.0;
              double minLng = 180.0, maxLng = -180.0;
              for (var r in reps) {
                if (r.lastLat! < minLat) minLat = r.lastLat!;
                if (r.lastLat! > maxLat) maxLat = r.lastLat!;
                if (r.lastLng! < minLng) minLng = r.lastLng!;
                if (r.lastLng! > maxLng) maxLng = r.lastLng!;
              }
              final isSinglePoint = minLat == maxLat && minLng == maxLng;

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
                  initialZoom: isSinglePoint ? 12.0 : 5.0,
                  initialCameraFit: isSinglePoint ? null : CameraFit.bounds(
                    bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
                    padding: const EdgeInsets.only(top: 120, bottom: 80, left: 40, right: 40),
                  ),
                  onTap: (_, _) => _clearSelection(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: isDark
                        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.pdos.app',
                  ),
                  MarkerLayer(
                    markers: reps.map((rep) {
                      return Marker(rotate: true,
                        point: LatLng(rep.lastLat!, rep.lastLng!),
                        width: 40,
                        height: 40,
                        child: _buildRepMarker(rep),
                      );
                    }).toList(),
                  ),
                  // Selected rep popup
                  if (_selectedRep != null)
                    MarkerLayer(
                      markers: [
                          Marker(rotate: true,
                          point: LatLng(_selectedRep!.lastLat!, _selectedRep!.lastLng!),
                          width: 200,
                          height: 200,
                          alignment: Alignment.bottomCenter,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildInfoWindow(_selectedRep!.lastLat!, _selectedRep!.lastLng!),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),

        // Coverage Stats
        Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: coverageAsync.when(
            data: (centers) {
              final visited = centers.where((c) => c.status == 'visited').length;
              final total = centers.length;
              return GestureDetector(
                onTap: () {
                  if (widget.scrollController != null) {
                    final sc = widget.scrollController!;
                    if (sc.offset > 50) {
                      sc.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    } else {
                      sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  }
                },
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(child: _CoverageStat(label: AppStrings.totalCenters, value: '$total')),
                      Expanded(child: _CoverageStat(label: AppStrings.visited, value: '$visited')),
                      Expanded(
                        child: _CoverageStat(
                          label: AppStrings.coverage,
                          value: total > 0 ? '${(visited * 100 ~/ total)}%' : '0%',
                        ),
                      ),
                      Container(
                        width: 1, 
                        height: 32, 
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      GestureDetector(
                        onTap: () {
                          final centers = ref.read(coverageProvider).asData?.value ?? [];
                          _showCenterListSheet(centers, isDark);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.format_list_bulleted_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, _) => const SizedBox(),
          ),
        ),
      
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
],
    );

    if (widget.isEmbedded) {
      return mapStack;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Coverage Overview",
                style: AppTextStyles.headlineSm.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: coverageAsync.when(
                data: (centers) {
                  final visited = centers.where((c) => c.status == 'visited').length;
                  final total = centers.length;
                  return GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(child: _CoverageStat(label: AppStrings.totalCenters, value: '$total')),
                        Expanded(child: _CoverageStat(label: AppStrings.visited, value: '$visited')),
                        Expanded(
                          child: _CoverageStat(
                            label: AppStrings.coverage,
                            value: total > 0 ? '${(visited * 100 ~/ total)}%' : '0%',
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox(),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 300,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: mapStack,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ── Helper classes ──────────────────────────────────────────────────────────────

class _CoverageStat extends StatelessWidget {
  final String label;
  final String value;

  const _CoverageStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _LatestNotesSection extends ConsumerWidget {
  final String centerId;

  const _LatestNotesSection({required this.centerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(centerNotesProvider(centerId));

    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) return const SizedBox.shrink();
        final latest = notes.take(2).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 13, color: AppColors.info),
                const SizedBox(width: 4),
                Text(
                  'Latest Notes',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (notes.length > 2)
                  GestureDetector(
                    onTap: () => context.push('/notes-history'),
                    child: Text(
                      'View All (${notes.length})',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final n in latest) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.south_west_rounded, size: 11, color: AppColors.info),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${n.senderName ?? 'User'}: ${n.content}',
                            style: AppTextStyles.caption.copyWith(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (n != latest.last) const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
