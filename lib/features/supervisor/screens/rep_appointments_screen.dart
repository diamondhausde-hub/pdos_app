import 'package:pdos_app/core/localization/app_strings.dart';
import '../../../core/models/user_model.dart';
import 'schedule_visit_for_rep_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/appointment_model.dart';
import '../../../core/models/center_model.dart';
import '../../../core/models/client_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../shared/widgets/schedule_appointment_sheet.dart';

class RepAppointmentsScreen extends ConsumerStatefulWidget {
  final UserModel rep;
  const RepAppointmentsScreen({super.key, required this.rep});

  @override
  ConsumerState<RepAppointmentsScreen> createState() => _RepAppointmentsScreenState();
}

class _RepAppointmentsScreenState extends ConsumerState<RepAppointmentsScreen> {
  final bool _showMap = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appointmentsAsync = ref.watch(repAppointmentsProvider(widget.rep.id));
    final centersAsync = ref.watch(centersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.rep.fullName.split(' ')[0]}'s Appointments"),

        bottom: _showMap ? null : const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: SizedBox.shrink(),
        ),
      ),
      floatingActionButton: _showMap ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleVisitForRepScreen(rep: widget.rep)));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: _showMap
          ? _buildMapView(appointmentsAsync, centersAsync)
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      labelStyle: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: AppTextStyles.labelLg,
                      indicator: BoxDecoration(
                        color: AppColors.cardBg(isDark),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.onSurface.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: AppStrings.upcoming),
                        Tab(text: AppStrings.past),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _AppointmentsList(isUpcoming: true, rep: widget.rep),
                        _AppointmentsList(isUpcoming: false, rep: widget.rep),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMapView(
    AsyncValue<List<AppointmentModel>> appointmentsAsync,
    AsyncValue<List<CenterModel>> centersAsync,
  ) {
    final centersMap = <String, CenterModel>{};
    final centers = centersAsync.asData?.value ?? [];
    for (final c in centers) {
      centersMap[c.id] = c;
    }

    return appointmentsAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (appointments) {
        final validMarkers = appointments
            .map((a) => centersMap[a.centerId])
            .where((c) => c != null && c.latitude != null && c.longitude != null)
            .cast<CenterModel>()
            .toList();

        if (validMarkers.isEmpty) {
          return const Center(child: Text(AppStrings.noCentersWithSpecific));
        }

        double sumLat = 0, sumLng = 0;
        for (final c in validMarkers) {
          sumLat += c.latitude!;
          sumLng += c.longitude!;
        }
        final centerLat = sumLat / validMarkers.length;
        final centerLng = sumLng / validMarkers.length;

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(centerLat, centerLng),
            initialZoom: 12.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.pdos.app',
            ),
            MarkerLayer(
              markers: validMarkers.map((c) {
                final appt = appointments.firstWhere(
                  (a) => a.centerId == c.id,
                  orElse: () => appointments.first,
                );
                final isDone = appt.status == AppointmentStatus.done;
                return Marker(
                  point: LatLng(c.latitude!, c.longitude!),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showCenterBottomSheet(c, appt),
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: isDone ? AppColors.success : AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _showCenterBottomSheet(CenterModel center, AppointmentModel appt) {
    final isDone = appt.status == AppointmentStatus.done;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(center.name, style: AppTextStyles.headlineMd),
            const SizedBox(height: 8),
            Text('${appt.apptTime} - ${DateFormat('MMM dd').format(appt.apptDate.toLocal())}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle_rounded : Icons.schedule_rounded,
                  color: isDone ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: 8),
                Text(isDone ? 'Visited' : 'Pending'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push('/clients/${appt.clientId}');
                  } else if (appt.centerId != null) {
                    context.push('/center/${appt.centerId}');
                  }
                },
                child: Text(AppStrings.viewDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsList extends ConsumerStatefulWidget {
  final bool isUpcoming;
  final UserModel rep;
  const _AppointmentsList({required this.isUpcoming, required this.rep});

  @override
  ConsumerState<_AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends ConsumerState<_AppointmentsList> {
  @override
  void initState() {
    super.initState();
    ref.read(syncOrchestratorProvider).syncAllInOrder();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appointmentsAsync = ref.watch(repAppointmentsProvider(widget.rep.id));
    final clientsAsync = ref.watch(repClientsStreamProvider(widget.rep.id));
    final clientMap = <String, ClientModel>{};
    final clients = clientsAsync.asData?.value ?? [];
    for (final c in clients) {
      clientMap[c.id] = c;
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(syncOrchestratorProvider).syncAllInOrder();
        ref.invalidate(appointmentsProvider);
        await ref.read(appointmentsProvider.future);
      },
      child: appointmentsAsync.when(
        loading: () => const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: 400, child: Center(child: CircularProgressIndicator())),
        ),
        error: (err, stack) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(child: Text('Error: $err')),
          ),
        ),
        data: (allAppointments) {
          final now = DateTime.now();
          final startOfToday = DateTime(now.year, now.month, now.day);

          final filtered = allAppointments.where((a) {
            final loc = a.apptDate.toLocal();
            final apptDay = DateTime(loc.year, loc.month, loc.day);
            if (widget.isUpcoming) {
              return apptDay.isAfter(startOfToday) || apptDay.isAtSameMomentAs(startOfToday);
            } else {
              return apptDay.isBefore(startOfToday);
            }
          }).toList();

          filtered.sort((a, b) {
            if (widget.isUpcoming) return a.apptDate.compareTo(b.apptDate);
            return b.apptDate.compareTo(a.apptDate);
          });

          if (filtered.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text(
                    widget.isUpcoming ? 'No upcoming appointments.' : 'No past appointments.',
                    style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
            );
          }

          return AnimationLimiter(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final appt = filtered[index];
                final loc = appt.apptDate.toLocal();
                final apptDay = DateTime(loc.year, loc.month, loc.day);

                AppointmentStatus displayStatus = appt.status;
                if (displayStatus == AppointmentStatus.pending && apptDay.isBefore(startOfToday)) {
                  displayStatus = AppointmentStatus.missed;
                }

                final isDone = displayStatus == AppointmentStatus.done;
                final isMissed = displayStatus == AppointmentStatus.missed;
                final isSynced = appt.synced;

                Color statusColor = AppColors.warning;
                IconData statusIcon = Icons.schedule_rounded;
                String statusText = 'Scheduled';

                if (isDone) {
                  statusColor = AppColors.success;
                  statusIcon = Icons.check_circle_rounded;
                  statusText = 'Done';
                } else if (isMissed) {
                  statusColor = AppColors.error;
                  statusIcon = Icons.cancel_rounded;
                  statusText = 'Missed';
                }

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 200),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: GlassCard(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 12),
                        onTap: () => _showAppointmentDetails(appt, clientMap[appt.clientId]?.doctorName ?? clientMap[appt.clientId]?.facilityName ?? appt.centerName ?? 'Unknown', statusText, statusColor, statusIcon, isDark),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('MMM dd').format(loc),
                                  style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appt.apptTime,
                                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: appt.centerId != null
                                              ? () => context.push('/rep/center/${appt.centerId}')
                                              : null,
                                          child: Text(
                                            appt.centerName ?? 'Unknown Center',
                                            style: AppTextStyles.bodyLg.copyWith(
                                              color: AppColors.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      if (!isSynced) ...[
                                        const SizedBox(width: 8),
                                        Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.onSurfaceVariant),
                                      ]
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(statusIcon, color: statusColor, size: 18),
                                      const SizedBox(width: 4),
                                      Text(statusText,
                                          style: AppTextStyles.bodySm.copyWith(color: statusColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }


  void _confirmDeleteAppointment(AppointmentModel appt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.lbl_13),
        content: const Text(AppStrings.lbl_14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.lbl_15),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(appointmentRepositoryProvider).deleteAppointment(appt.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.lbl_16),
          ),
        ],
      ),
    );
  }




  void _showAppointmentDetails(AppointmentModel appt, String locationName, String statusText, Color statusColor, IconData statusIcon, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.event_note_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.appointment, style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MMM dd, yyyy').format(appt.apptDate.toLocal())} at ${appt.apptTime}',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showScheduleAppointmentSheet(context, ref, initialAppointment: appt);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmDeleteAppointment(appt);
                    },
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Text(AppStrings.details, style: AppTextStyles.h4),
            const SizedBox(height: 16),
            _DetailRow(label: AppStrings.location, value: locationName),
            if (appt.notes != null && appt.notes!.isNotEmpty)
              _DetailRow(label: AppStrings.notes, value: appt.notes!),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(AppStrings.status, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
                ),
                Icon(statusIcon, color: statusColor, size: 18),
                const SizedBox(width: 4),
                Text(statusText, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: statusColor)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push('/clients/${appt.clientId}');
                  } else if (appt.centerId != null) {
                    context.push('/center/${appt.centerId}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(appt.clientId != null ? AppStrings.viewProfile : AppStrings.viewCenterProfile, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
