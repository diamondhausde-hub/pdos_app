import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/note_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';

final visitHistoryProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    yield [];
    return;
  }

  await for (final visits in db.watchAllVisits(user.id)) {
    // Sort newest first
    final sorted = List.of(visits)
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));

    final results = <Map<String, dynamic>>[];
    for (final v in sorted) {
      final center = await (db.select(db.localCenters)..where((t) => t.id.equals(v.centerId))).getSingleOrNull();
      ClientModel? client;

      // 1) Try via appointmentId (scheduled visits)
      if (v.appointmentId != null) {
        final appt = await (db.select(db.localAppointments)..where((t) => t.id.equals(v.appointmentId!))).getSingleOrNull();
        if (appt?.clientId != null) {
          client = await ref.read(clientRepositoryProvider).getClientById(appt!.clientId!);
        }
      }
      // 2) Fallback: doctor visits store clientId directly (no appointmentId)
      if (client == null && v.clientId != null) {
        client = await ref.read(clientRepositoryProvider).getClientById(v.clientId!);
      }

      results.add({'visit': v, 'center': center, 'client': client});
    }
    yield results;
  }
});

class VisitHistoryScreen extends ConsumerStatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  ConsumerState<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends ConsumerState<VisitHistoryScreen> {
  String _statusFilter = 'all';
  String _typeFilter = 'all'; // all | doctor | center

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(visitHistoryProvider);
    final user = ref.watch(currentUserProvider);
    final notesAsync = user == null
        ? const AsyncValue<List<NoteModel>>.data([])
        : ref.watch(notesProvider(user.id));
    final noteVisitIds = notesAsync.value
        ?.where((n) => n.visitId != null)
        .map((n) => n.visitId!)
        .toSet() ??
        const <String>{};

    return Scaffold(
      
      appBar: AppBar(
        title: Text(AppStrings.visitHistory),
        centerTitle: true,
        actions: [
          // Visit type filter (doctor / center)
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(
                _typeFilter == 'doctor'
                    ? Icons.medical_services_rounded
                    : _typeFilter == 'center'
                        ? Icons.local_pharmacy_rounded
                        : Icons.category_rounded,
                color: _typeFilter != 'all'
                    ? AppColors.secondary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Visit type',
              onSelected: (val) => setState(() => _typeFilter = val),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'all', child: Text('All Types')),
                PopupMenuItem(
                  value: 'doctor',
                  child: Row(children: [
                    Icon(Icons.medical_services_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Doctor Visits'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'center',
                  child: Row(children: [
                    Icon(Icons.local_pharmacy_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Center / Pharmacy'),
                  ]),
                ),
              ],
            ),
          ),
          // Status filter
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.filter_list_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
              tooltip: 'Filter by status',
              onSelected: (val) => setState(() => _statusFilter = val),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'all', child: Text(AppStrings.all)),
                const PopupMenuItem(value: 'completed', child: Text(AppStrings.completed)),
                const PopupMenuItem(value: 'arrived', child: Text(AppStrings.arrived)),
                const PopupMenuItem(value: 'flagged', child: Text(AppStrings.flagged)),
                const PopupMenuItem(value: 'rejected', child: Text(AppStrings.rejected)),
              ],
            ),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final filtered = data.where((d) {
            final visit = d['visit'] as LocalVisit;
            // Status filter
            if (_statusFilter != 'all' && visit.status != _statusFilter) return false;
            // Type filter
            if (_typeFilter == 'doctor' && visit.visitType != 'doctor') return false;
            if (_typeFilter == 'center' && visit.visitType == 'doctor') return false;
            return true;
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
                  child: Icon(Icons.history_rounded, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text(AppStrings.noVisitsFound, style: AppTextStyles.bodyLg.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ]),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(visitHistoryProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final visit = item['visit'] as LocalVisit;
                final center = item['center'] as LocalCenter?;
                final client = item['client'] as ClientModel?;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 30,
                    child: FadeInAnimation(
                      child: GlassCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () => context.push('/rep/visit/${visit.id}'),
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                  color: _statusColor(visit.status).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(_statusIcon(visit.status), color: _statusColor(visit.status), size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(client != null
                                        ? (client.doctorName ?? client.facilityName ?? 'Unknown')
                                        : (center?.name ?? 'Unknown Center'),
                                        style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                                    const SizedBox(height: 2),
                                    if (center?.name != null && center?.name != (client?.doctorName ?? client?.facilityName))
                                      Text(center!.name, style: AppTextStyles.bodySm.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    Text(DateFormat('MMM dd, yyyy · HH:mm').format(visit.visitDate),
                                        style: AppTextStyles.bodySm.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _statusColor(visit.status).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(visit.status.toUpperCase(),
                                              style: AppTextStyles.labelSm.copyWith(
                                                  color: _statusColor(visit.status), fontWeight: FontWeight.w600)),
                                        ),
                                        if (visit.visitType == 'doctor') ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                                              Icon(Icons.medical_services_rounded,
                                                  size: 12, color: AppColors.secondary),
                                              const SizedBox(width: 3),
                                              Text(AppStrings.doctor,
                                                  style: AppTextStyles.labelSm.copyWith(
                                                      color: AppColors.secondary,
                                                      fontWeight: FontWeight.w700)),
                                            ]),
                                          ),
                                        ],
                                        if (noteVisitIds.contains(visit.id)) ...[
                                          const SizedBox(width: 6),
                                          Icon(Icons.edit_note_rounded, size: 15, color: AppColors.info),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                              ),
                            ],
                          ),
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

  Color _statusColor(String status) {
    switch (status) {
      case 'completed': return AppColors.success;
      case 'arrived': return AppColors.info;
      case 'flagged': return AppColors.error;
      case 'rejected': return AppColors.warning;
      default: return AppColors.onSurfaceVariant;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'completed': return Icons.check_circle_rounded;
      case 'arrived': return Icons.location_on_rounded;
      case 'flagged': return Icons.flag_rounded;
      case 'rejected': return Icons.cancel_rounded;
      default: return Icons.schedule_rounded;
    }
  }
}
