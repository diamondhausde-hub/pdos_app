import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/theme.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import 'expense_approvals_screen.dart';

class ReviewTab extends ConsumerStatefulWidget {
  const ReviewTab({super.key});

  @override
  ConsumerState<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends ConsumerState<ReviewTab> {
  List<VisitModel>? _allVisits;
  bool _loading = true;
  String? _expandedVisitId;
  final Map<String, TextEditingController> _noteControllers = {};

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  @override
  void dispose() {
    for (final c in _noteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String visitId) {
    return _noteControllers.putIfAbsent(visitId, () => TextEditingController());
  }

  Future<void> _loadVisits() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(visitRepositoryProvider);
      final visits = await repo.getAllVisits(status: 'flagged');
      visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
      if (mounted) setState(() => _allVisits = visits);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addNote(String visitId) async {
    final note = _controllerFor(visitId).text.trim();
    if (note.isEmpty) return;

    try {
      final repo = ref.read(visitRepositoryProvider);
      await repo.addVisitNote(visitId, note);
      _controllerFor(visitId).clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.noteAdded), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(centersProvider);
    final teamAsync = ref.watch(usersListProvider);
    final centers = centersAsync.asData?.value ?? [];
    final team = teamAsync.asData?.value ?? [];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: AppStrings.visitReviews),
              Tab(text: AppStrings.expenseApprovals),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildVisitsTab(context, centers, team),
                const ExpenseApprovalsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitsTab(BuildContext context, List<dynamic> centers, List<dynamic> team) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_allVisits == null || _allVisits!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green.shade300),
            const SizedBox(height: 16),
            Text(AppStrings.noVisitsYet, style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVisits,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allVisits!.length,
        itemBuilder: (context, index) {
          final visit = _allVisits![index];
          final center = centers.where((c) => c.id == visit.centerId).firstOrNull;
          final rep = team.where((u) => u.id == visit.repId).firstOrNull;
          final isExpanded = _expandedVisitId == visit.id;
          final statusColor = switch (visit.status) {
            VisitStatus.completed => AppColors.success,
            VisitStatus.flagged => AppColors.warning,
            VisitStatus.rejected => AppColors.error,
            _ => AppColors.onSurfaceVariant,
          };

          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(Icons.store, size: 18, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(child: Text(center?.name ?? 'Unknown Center', style: AppTextStyles.h4)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(visit.status.displayName, style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(rep?.fullName ?? 'Unknown Rep', style: AppTextStyles.bodySmall),
                      if (rep?.role.name == 'supervisor') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(AppStrings.sup, style: TextStyle(fontSize: 9, color: AppColors.warning, fontWeight: FontWeight.w600)),
                        ),
                      ],
                      const Spacer(),
                      Icon(Icons.access_time, size: 14, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(timeago.format(visit.visitDate), style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Review Actions
                  if (visit.status == VisitStatus.completed || visit.status == VisitStatus.flagged)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateVisitStatus(visit.id, 'rejected'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(AppStrings.reject),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateVisitStatus(visit.id, 'completed'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(AppStrings.approve),
                          ),
                        ),
                      ],
                    ),

                  // Existing Note
                  if (visit.reviewNote != null && visit.reviewNote!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.rate_review, size: 16, color: AppColors.info),
                          const SizedBox(width: 8),
                          Expanded(child: Text(visit.reviewNote!, style: AppTextStyles.bodySmall)),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Add/View Note Button
                  InkWell(
                    onTap: () => setState(() {
                      _expandedVisitId = isExpanded ? null : visit.id;
                    }),
                    child: Row(
                      children: [
                        Icon(isExpanded ? Icons.expand_less : Icons.chat_bubble_outline, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          visit.reviewNote != null ? 'View/Edit Note' : 'Add Note',
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),

                  // Expanded note editor
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controllerFor(visit.id),
                      decoration: InputDecoration(
                        hintText: AppStrings.writeYourNote,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () => _addNote(visit.id),
                        icon: Icon(Icons.send, size: 16),
                        label: Text(AppStrings.sendNote),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateVisitStatus(String visitId, String newStatus) async {
    try {
      final repo = ref.read(visitRepositoryProvider);
      await repo.reviewVisit(visitId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visit marked as $newStatus')));
        _loadVisits();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update visit status: $e')));
    }
  }
}
