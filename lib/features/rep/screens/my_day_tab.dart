import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/appointment_model.dart';
import '../../../core/models/center_model.dart';
import '../../../core/models/target_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../widgets/task_card_widget.dart';

final _distance = const Distance();

class MyDayTab extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToTargets;

  const MyDayTab({super.key, this.onNavigateToTargets});

  @override
  ConsumerState<MyDayTab> createState() => _MyDayTabState();
}

class _MyDayTabState extends ConsumerState<MyDayTab>
    with TickerProviderStateMixin {
  Position? _currentPosition;
  late AnimationController _welcomeController;

  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncOrchestratorProvider).syncAllInOrder();
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      if (mounted) setState(() => _currentPosition = position);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(appointmentsProvider);
    final centersAsync = ref.watch(centersProvider);

    return Scaffold(
      body: appointmentsAsync.when(
        loading: () => const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: ShimmerDashboard(),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 56,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(appointmentsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        data: (allAppointments) {
          final now = DateTime.now();
          final todayAppointments = allAppointments.where((a) {
            final loc = a.apptDate.toLocal();
            return loc.year == now.year &&
                loc.month == now.month &&
                loc.day == now.day;
          }).toList();
          final sortedAppointments = List<AppointmentModel>.from(
            todayAppointments,
          );
          if (_currentPosition != null) {
            final centers = centersAsync.asData?.value ?? [];
            sortedAppointments.sort((a, b) {
              final ca = centers.where((c) => c.id == a.centerId).firstOrNull;
              final cb = centers.where((c) => c.id == b.centerId).firstOrNull;
              final pos = LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              );
              final da =
                  (ca != null && ca.latitude != null && ca.longitude != null)
                  ? _distance(pos, LatLng(ca.latitude!, ca.longitude!))
                  : double.infinity;
              final db =
                  (cb != null && cb.latitude != null && cb.longitude != null)
                  ? _distance(pos, LatLng(cb.latitude!, cb.longitude!))
                  : double.infinity;
              return da.compareTo(db);
            });
          }
          final nextAppt = sortedAppointments
              .where((a) => a.status == AppointmentStatus.pending)
              .firstOrNull;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(appointmentsProvider);
              ref.invalidate(centersProvider);
              ref.invalidate(targetsProvider);
            },
            child: AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 250),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 0,
                    verticalOffset: 30,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _welcomeController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: const _NewTasksSection(),
                    ),
                    const SizedBox(height: 24),
                    SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _welcomeController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: _TargetsOverviewSection(
                        onViewMore: widget.onNavigateToTargets,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (nextAppt != null)
                      _NextStopCard(
                        appointment: nextAppt,
                        centersAsync: centersAsync,
                        currentPosition: _currentPosition,
                        onStart: () => context.push(
                          '/rep/active_visit/${nextAppt.id}?centerId=${nextAppt.centerId ?? ""}&clientId=${nextAppt.clientId ?? ""}',
                        ),
                      )
                    else
                      _EmptyNextStop(),
                    const SizedBox(height: 20),
                    _UpcomingSection(
                      appointments: sortedAppointments,
                      onTap: (appt) {
                        if (appt.status == AppointmentStatus.done) {
                          context.push('/rep/visit/${appt.visitId ?? appt.id}');
                        } else {
                          context.push(
                            '/rep/active_visit/${appt.id}?centerId=${appt.centerId ?? ""}&clientId=${appt.clientId ?? ""}',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _ProTipCard(
                      nextAppt: nextAppt,
                      centers: centersAsync.asData?.value ?? [],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TargetsOverviewSection extends ConsumerWidget {
  final VoidCallback? onViewMore;

  const _TargetsOverviewSection({this.onViewMore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetsAsync = ref.watch(targetsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Targets",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        targetsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error loading targets: $e'),
          data: (targets) {
            if (targets.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Center(child: Text('No targets for today')),
              );
            }
            final displayTargets = targets.take(2).toList();
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _TargetSquare(target: displayTargets[0])),
                    if (displayTargets.length > 1) ...[
                      const SizedBox(width: 12),
                      Expanded(child: _TargetSquare(target: displayTargets[1])),
                    ] else ...[
                      const SizedBox(width: 12),
                      const Spacer(),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                if (onViewMore != null)
                  Center(
                    child: TextButton(
                      onPressed: onViewMore,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View More',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TargetSquare extends StatelessWidget {
  final TargetModel target;
  const _TargetSquare({required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            target.productName ?? 'General Target',
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${target.achievedQty} / ${target.targetQty}',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: target.progress,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            color: target.isAchieved ? AppColors.success : AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class _NextStopCard extends StatelessWidget {
  final AppointmentModel appointment;
  final AsyncValue<List<CenterModel>> centersAsync;
  final Position? currentPosition;
  final VoidCallback onStart;

  const _NextStopCard({
    required this.appointment,
    required this.centersAsync,
    required this.currentPosition,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final centers = centersAsync.asData?.value ?? [];
    final center = centers
        .where((c) => c.id == appointment.centerId)
        .firstOrNull;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child:
                center != null &&
                    center.latitude != null &&
                    center.longitude != null
                ? FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                        center.latitude!,
                        center.longitude!,
                      ),
                      initialZoom: 15,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.pdos.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(center.latitude!, center.longitude!),
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 56,
                      color: AppColors.outlineVariant,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.centerName ?? center?.name ?? 'Unknown',
                        style: AppTextStyles.headlineSm.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation_rounded,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Nearby',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      center?.region ?? 'Unset',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _Tag(
                      label: 'Pharmacy',
                      color: AppColors.primary.withValues(alpha: 0.12),
                      textColor: AppColors.primary,
                    ),
                    _Tag(
                      label: 'Pending Visit',
                      color: AppColors.warning.withValues(alpha: 0.12),
                      textColor: AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_circle_fill_rounded, size: 22),
                    label: const Text('Start Visit'),
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

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _Tag({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: textColor),
      ),
    );
  }
}

class _EmptyNextStop extends StatelessWidget {
  const _EmptyNextStop();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 24,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All visits completed!',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Great job today',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final Function(AppointmentModel) onTap;
  const _UpcomingSection({required this.appointments, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final upcoming = appointments
        .where((a) => a.status == AppointmentStatus.pending)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${upcoming.length} visit${upcoming.length != 1 ? 's' : ''}',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (upcoming.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No upcoming visits',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...upcoming.map(
            (appt) =>
                _AppointmentRow(appointment: appt, onTap: () => onTap(appt)),
          ),
      ],
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  const _AppointmentRow({required this.appointment, required this.onTap});

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return time;
      final h = int.parse(parts[0]), m = parts[1];
      final period = h >= 12 ? 'PM' : 'AM';
      final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '${hour.toString().padLeft(2, '0')}:$m $period';
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.apptTime.isNotEmpty
                            ? _formatTime(appointment.apptTime)
                            : '--:--',
                        style: AppTextStyles.labelLg.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.centerName ?? 'Unknown',
                        style: AppTextStyles.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'Scheduled Visit',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      if (appointment.suggestedProductName != null &&
                          appointment.suggestedProductName!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '📌 ركّز على: ${appointment.suggestedProductName}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProTipCard extends StatelessWidget {
  final AppointmentModel? nextAppt;
  final List<CenterModel> centers;

  const _ProTipCard({this.nextAppt, required this.centers});

  @override
  Widget build(BuildContext context) {
    final clientName = nextAppt?.centerName;
    final center = nextAppt?.centerId != null
        ? centers.where((c) => c.id == nextAppt!.centerId).firstOrNull
        : null;
    final tipText = clientName != null
        ? 'Head to $clientName for your next visit'
        : center != null
        ? 'Head to ${center.name} for your next visit'
        : nextAppt?.suggestedProductName != null
        ? 'Recommend ${nextAppt!.suggestedProductName} during your next visit'
        : nextAppt != null
        ? 'Your next visit is at ${nextAppt!.apptTime}'
        : 'No visits scheduled today — use this time to follow up on pending leads';

    return GlassCard(
      padding: const EdgeInsets.all(16),
      variant: GlassVariant.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tips_and_updates_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tipText,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewTasksSection extends ConsumerWidget {
  const _NewTasksSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(repTasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المهام الجديدة",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Row(
              children: [
                const TaskStatusBadge(),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => context.push('/rep/tasks'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('خطأ: $e'),
          data: (tasks) {
            final pendingTasks = tasks
                .where((t) => t.status == 'pending')
                .toList();
            if (pendingTasks.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Center(child: Text('لا توجد مهام معلقة حالياً')),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingTasks.length,
              itemBuilder: (context, index) {
                return TaskCardWidget(
                  task: pendingTasks[index],
                  onTap: () => context.push('/rep/tasks'),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
