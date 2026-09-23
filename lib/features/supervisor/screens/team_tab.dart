import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import 'rep_route_screen.dart';
import 'rep_report_screen.dart';
import 'target_list_screen.dart';
import 'rep_appointments_screen.dart';
import '../../shared/screens/public_profile_screen.dart';
import '../../../core/utils/image_url_helper.dart';

class TeamTab extends ConsumerStatefulWidget {
  const TeamTab({super.key});

  @override
  ConsumerState<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends ConsumerState<TeamTab> {
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(myTeamProvider);

    return Column(
      children: [
        // Summary Bar
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: teamAsync.when(
            data: (team) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                  value: '${team.length}',
                  label: AppStrings.totalReps,
                  icon: Icons.groups,
                ),
                _StatColumn(
                  value: '${team.where((r) => r.isActive).length}',
                  label: AppStrings.currentlyActive,
                  icon: Icons.circle,
                  iconColor: AppColors.success,
                ),
              ],
            ),
            loading: () => Center(
              child: CircularProgressIndicator(color: AppColors.onPrimary),
            ),
            error: (e, s) => Text(
              'Error loading stats',
              style: TextStyle(color: AppColors.onPrimary),
            ),
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: AppStrings.searchForARep,
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (val) =>
                setState(() => _searchQuery = val.trim().toLowerCase()),
          ),
        ),
        const SizedBox(height: 12),

        // Target Post FAB style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                final team = ref.read(myTeamProvider).asData?.value;
                if (team != null && team.isNotEmpty) {
                  _showTargetPostScreen(context, team, ref);
                }
              },
              icon: Icon(Icons.add_circle_outline, size: 22),
              label: Text(
                'Target',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TargetListScreen()),
              ),
              icon: Icon(Icons.list_alt, size: 20),
              label: Text(AppStrings.viewTargets),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Rep List
        Expanded(
          child: teamAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
            data: (team) {
              final filtered = _searchQuery.isEmpty
                  ? team
                  : team
                        .where(
                          (r) =>
                              r.fullName.toLowerCase().contains(_searchQuery) ||
                              (r.region ?? '').toLowerCase().contains(
                                _searchQuery,
                              ) ||
                              r.email.toLowerCase().contains(_searchQuery),
                        )
                        .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'No team members'
                        : 'No search results',
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(myTeamProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final rep = filtered[index];
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      onTap: () => _showRepDetail(context, rep, ref),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primaryContainer
                                    .withValues(alpha: 0.2),
                                child: Text(
                                  rep.fullName.isNotEmpty
                                      ? rep.fullName[0].toUpperCase()
                                      : '?',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: rep.isActive
                                        ? AppColors.success
                                        : AppColors.onSurfaceVariant,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.onPrimary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rep.fullName, style: AppTextStyles.h4),
                                const SizedBox(height: 2),
                                Text(
                                  rep.region ?? "Unknown",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                if (rep.brandId != null) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      rep.brandId == 'brand_a' ? 'براند A' : (rep.brandId == 'brand_b' ? 'براند B' : 'Brand: ${rep.brandId}'),
                                      style: AppTextStyles.caption.copyWith(color: AppColors.onPrimaryContainer),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRepDetail(BuildContext context, UserModel rep, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
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
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryContainer.withValues(
                      alpha: 0.2,
                    ),
                    child: Text(
                      rep.fullName.isNotEmpty
                          ? rep.fullName[0].toUpperCase()
                          : '?',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rep.fullName, style: AppTextStyles.h2),
                      Text(
                        'Region: ${rep.region ?? "Not Specified"}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(AppStrings.details, style: AppTextStyles.h4),
              const SizedBox(height: 12),
              _DetailRow(label: AppStrings.email, value: rep.email),
              _DetailRow(label: AppStrings.phone, value: rep.phone ?? 'N/A'),
              _DetailRow(
                label: AppStrings.status,
                value: rep.isActive ? 'Active' : 'Inactive',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(userId: rep.id)));
                  },
                  icon: Icon(Icons.person_search_rounded),
                  label: Text(AppStrings.viewPublicProfile),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showAssignTargetDialog(context, rep, ref);
                  },
                  icon: Icon(Icons.track_changes),
                  label: Text(AppStrings.assignTarget),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RepAppointmentsScreen(rep: rep)));
                  },
                  icon: Icon(Icons.calendar_month),
                    label: Text(AppStrings.u062cU062fU0648U0644),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showRepVisits(context, rep);
                  },
                  icon: Icon(Icons.history),
                  label: Text(AppStrings.viewVisits),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RepRouteScreen(rep: rep),
                      ),
                    );
                  },
                  icon: Icon(Icons.route),
                  label: Text(AppStrings.viewMovements),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RepReportScreen(rep: rep),
                      ),
                    );
                  },
                  icon: Icon(Icons.assessment),
                  label: Text(AppStrings.detailedReport),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRepVisits(BuildContext context, UserModel rep) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('${rep.fullName.split(' ').first}\'s Visits'),
          ),
          body: _RepVisitsList(repId: rep.id),
        ),
      ),
    );
  }

  void _showTargetPostScreen(
    BuildContext context,
    List<UserModel> allReps,
    WidgetRef ref,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _TargetPostScreen(reps: allReps)),
    );
  }

  void _showAssignTargetDialog(
    BuildContext context,
    UserModel rep,
    WidgetRef ref,
  ) {
    String? draggedProductId;
    final qtyCtrl = TextEditingController();
    bool dragAccepted = false;

    final now = DateTime.now();
    DateTime periodStart = DateTime(now.year, now.month, 1);
    DateTime periodEnd = DateTime(now.year, now.month + 1, 0);

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final productsAsync = ref.watch(productsProvider);

          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assign target to ${rep.fullName.split(' ')[0]}',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Drag product to the target zone',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Drag Target Zone (shows selected product)
                  DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        draggedProductId = details.data;
                        dragAccepted = true;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovering = candidateData.isNotEmpty;
                      final selectedProduct = draggedProductId != null
                          ? (productsAsync.asData?.value
                                .where((p) => p.id == draggedProductId)
                                .firstOrNull)
                          : null;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 80,
                        decoration: BoxDecoration(
                          color: dragAccepted
                              ? AppColors.successLight
                              : isHovering
                              ? AppColors.primaryContainer
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: dragAccepted
                                ? AppColors.success
                                : isHovering
                                ? AppColors.primary
                                : AppColors.outlineVariant.withValues(alpha: 0.5),
                            width: dragAccepted || isHovering ? 2 : 1,
                          ),
                        ),
                        child: selectedProduct != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selectedProduct.imageUrl != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          fullImageUrl(
                                            selectedProduct.imageUrl,
                                          ),
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              const Icon(Icons.medication),
                                        ),
                                      ),
                                    ),
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedProduct.name,
                                    style: AppTextStyles.h4,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isHovering ? Icons.add_circle : Icons.inbox,
                                    color: isHovering
                                        ? AppColors.primary
                                        : AppColors.outline,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isHovering
                                        ? 'Drop product here'
                                        : 'Drag a product here',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isHovering
                                          ? AppColors.primary
                                          : AppColors.outline,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Draggable Product Grid
                  productsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Error: $e'),
                    data: (products) {
                      if (products.isEmpty) {
                        return Text(AppStrings.noProductsAvailable);
                      }
                      return SizedBox(
                        height: 180,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: products.length,
                          itemBuilder: (ctx, i) {
                            final p = products[i];
                            final isSelected = p.id == draggedProductId;
                            if (isSelected) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.success,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: 32,
                                  ),
                                ),
                              );
                            }
                            return LongPressDraggable<String>(
                              data: p.id,
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(11),
                                              ),
                                          child: p.imageUrl != null
                                              ? Image.network(
                                                  fullImageUrl(p.imageUrl),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  errorBuilder: (_, _, _) =>
                                                      Icon(
                                                        Icons.medication,
                                                        size: 24,
                                                        color: Colors
                                                            .grey
                                                            .shade400,
                                                      ),
                                                )
                                              : Icon(
                                                  Icons.medication,
                                                  size: 24,
                                                  color: AppColors.outline,
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          p.name,
                                          style: AppTextStyles.caption.copyWith(
                                            fontSize: 9,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _productGridItem(p),
                              ),
                              child: _productGridItem(p),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Quantity + Period
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppStrings.targetQuantity,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${periodStart.toIso8601String().split('T')[0]} to ${periodEnd.toIso8601String().split('T')[0].substring(5)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(AppStrings.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (draggedProductId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Drag a product to the designated area',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            final targetQty = int.tryParse(qtyCtrl.text) ?? 0;
                            if (targetQty <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(AppStrings.enterAValidQuantity),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            try {
                              await ref
                                  .read(targetRepositoryProvider)
                                  .createTarget({
                                    'product_id': draggedProductId,
                                    'rep_id': rep.id,
                                    'period_start': periodStart
                                        .toIso8601String(),
                                    'period_end': periodEnd.toIso8601String(),
                                    'target_qty': targetQty,
                                  });
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Target assigned successfully',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed: $e'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(AppStrings.assignTarget),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productGridItem(ProductModel p) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              child: p.imageUrl != null
                  ? Image.network(
                      fullImageUrl(p.imageUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.medication,
                        size: 28,
                        color: AppColors.outline,
                      ),
                    )
                  : Icon(
                      Icons.medication,
                      size: 28,
                      color: AppColors.outline,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              p.name,
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  
}

class _TargetPostScreen extends ConsumerStatefulWidget {
  final List<UserModel> reps;
  const _TargetPostScreen({required this.reps});

  @override
  ConsumerState<_TargetPostScreen> createState() => _TargetPostScreenState();
}

class _TargetPostScreenState extends ConsumerState<_TargetPostScreen> {
  final _prodSearchCtrl = TextEditingController();
  final _repSearchCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final Set<String> _selectedProductIds = {};
  final Set<String> _selectedRepIds = {};
  DateTime? _expiryDate;
  bool _saving = false;
  bool _selectAllReps = true;

  @override
  void initState() {
    super.initState();
    _selectedRepIds.addAll(widget.reps.map((r) => r.id));
    _expiryDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  }

  @override
  void dispose() {
    _prodSearchCtrl.dispose();
    _repSearchCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final prodSearch = _prodSearchCtrl.text.trim().toLowerCase();
    final repSearch = _repSearchCtrl.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.targetPost),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _publish,
            child: _saving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppStrings.publish, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Products Section ──
                Text(AppStrings.products, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _prodSearchCtrl,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchForAProduct,
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                productsAsync.when(
                  data: (products) {
                    var filtered = products;
                    if (prodSearch.isNotEmpty) {
                      filtered = filtered
                          .where(
                            (p) => p.name.toLowerCase().contains(prodSearch),
                          )
                          .toList();
                    }
                    return Column(
                      children: filtered.map((p) {
                        final isSelected = _selectedProductIds.contains(p.id);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedProductIds.remove(p.id);
                              } else {
                                _selectedProductIds.add(p.id);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.outline,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                if (p.imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      fullImageUrl(p.imageUrl),
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.medication,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.medication,
                                      size: 20,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '${p.stockQty}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),

                const Divider(height: 32),

                // ── Quantity + Notes ──
                Text(AppStrings.targetQuantity, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: AppStrings.enterQuantity,
                  ),
                ),
                const SizedBox(height: 16),
                Text(AppStrings.note, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppStrings.writeANoteFor,
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Expiry Date ──
                Text(AppStrings.targetExpiryDate, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate:
                          _expiryDate ??
                          DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setState(() => _expiryDate = d);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    child: Text(
                      _expiryDate != null
                          ? '${_expiryDate!.year}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}'
                          : 'Select Date',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),

                const Divider(height: 32),

                // ── Reps Section ──
                Row(
                  children: [
                    Text(AppStrings.reps, style: AppTextStyles.h3),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectAllReps = !_selectAllReps;
                          if (_selectAllReps) {
                            _selectedRepIds.addAll(
                              widget.reps.map((r) => r.id),
                            );
                          } else {
                            _selectedRepIds.clear();
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _selectAllReps
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Select All',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _repSearchCtrl,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchForARep,
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                ..._buildRepList(repSearch),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRepList(String query) {
    final filtered = query.isEmpty
        ? widget.reps
        : widget.reps
              .where((r) => r.fullName.toLowerCase().contains(query))
              .toList();
    final widgets = <Widget>[];
    for (final rep in filtered) {
      widgets.add(
        InkWell(
          onTap: () {
            setState(() {
              if (_selectedRepIds.contains(rep.id)) {
                _selectedRepIds.remove(rep.id);
                _selectAllReps = false;
              } else {
                _selectedRepIds.add(rep.id);
                if (_selectedRepIds.length == widget.reps.length) {
                  _selectAllReps = true;
                }
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  _selectedRepIds.contains(rep.id)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 20,
                  color: _selectedRepIds.contains(rep.id)
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryContainer.withValues(
                    alpha: 0.2,
                  ),
                  child: Text(
                    rep.fullName.isNotEmpty
                        ? rep.fullName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(rep.fullName, style: AppTextStyles.bodyMedium),
                ),
                if (rep.region != null)
                  Text(
                    rep.region!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      widgets.add(const Divider(height: 2));
    }
    return widgets;
  }

  Future<void> _publish() async {
    final targetQty = int.tryParse(_qtyCtrl.text);
    if (_selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.selectAtLeastOne),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (targetQty == null || targetQty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.enterAValidQuantity),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.selectAnExpiryDate),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_selectedRepIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.selectAtLeastOne_36),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final periodStart = DateTime.now();
    final periodEnd = DateTime(
      _expiryDate!.year,
      _expiryDate!.month,
      _expiryDate!.day,
      23,
      59,
      59,
    );
    final notes = _notesCtrl.text.trim().isEmpty
        ? null
        : _notesCtrl.text.trim();
    final targetRepo = ref.read(targetRepositoryProvider);

    int total = 0;
    for (final pid in _selectedProductIds) {
      for (final rid in _selectedRepIds) {
        try {
          await targetRepo.createTarget({
            'product_id': pid,
            'rep_id': rid,
            'period_start': periodStart.toIso8601String(),
            'period_end': periodEnd.toIso8601String(),
            'target_qty': targetQty,
            'notes': notes,
          });
          total++;
        } catch (_) {}
      }
    }

    if (!mounted) return;
    ref.invalidate(targetsProvider);
    setState(() => _saving = false);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Published: $total target(s)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  const _StatColumn({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.onPrimary)),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(value, style: AppTextStyles.labelLarge),
        ],
      ),
    );
  }
}

class _RepVisitsList extends ConsumerStatefulWidget {
  final String repId;
  const _RepVisitsList({required this.repId});

  @override
  ConsumerState<_RepVisitsList> createState() => _RepVisitsListState();
}

class _RepVisitsListState extends ConsumerState<_RepVisitsList> {
  List<VisitModel>? _visits;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(visitRepositoryProvider);
      final visits = await repo.getAllVisits();
      final filtered = visits.where((v) => v.repId == widget.repId).toList();
      if (mounted) setState(() => _visits = filtered);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_visits == null || _visits!.isEmpty) {
      return const Center(child: Text(AppStrings.noVisits));
    }
    return RefreshIndicator(
      onRefresh: _loadVisits,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _visits!.length,
        itemBuilder: (context, index) {
          final v = _visits![index];
          final statusColor = switch (v.status) {
            VisitStatus.completed => AppColors.success,
            VisitStatus.flagged => AppColors.warning,
            VisitStatus.rejected => AppColors.error,
            _ => AppColors.onSurfaceVariant,
          };
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            onTap: () => context.push('/rep/visit/${v.id}'),
              child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: statusColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.centerName ?? 'Unknown Center',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(v.visitDate),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      v.status.displayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
