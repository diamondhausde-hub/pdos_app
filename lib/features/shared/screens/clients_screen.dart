import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/models/client_model.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  String _searchQuery = '';
  String _classFilter = 'All';
  String _specialtyFilter = 'All';
  String _typeFilter = 'All'; // All | Doctors | Pharmacies
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.clients),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.scaffoldBg(isDark),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      Text('Add New Client', style: AppTextStyles.h4),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.medical_services_rounded, color: AppColors.primary),
                        ),
                        title: Text('Doctor', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Add a new doctor', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                        onTap: () {
                          Navigator.pop(ctx);
                          context.push('/clients/new?type=doctor');
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.local_pharmacy_rounded, color: AppColors.secondary),
                        ),
                        title: Text('Pharmacy / Center', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Add a new facility', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                        onTap: () {
                          Navigator.pop(ctx);
                          context.push('/clients/new?type=pharmacy');
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.tertiary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.business_rounded, color: AppColors.tertiary),
                        ),
                        title: Text('Institution / Hospital', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Add a new hospital or center', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                        onTap: () {
                          Navigator.pop(ctx);
                          context.push('/clients/new?type=institution');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: AppStrings.searchByNameFacility,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.filter_list_rounded, color: AppColors.onSurfaceVariant),
                        onPressed: () {
                          if (clientsAsync.hasValue) {
                            final specialties = ['All', ...{for (final c in clientsAsync.value!) if (c.specialty != null) c.specialty!}];
                            _showFilterSheet(specialties);
                          }
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                    ),
                    style: AppTextStyles.bodyMd,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(_isGridView ? Icons.grid_view_rounded : Icons.list_rounded,
                        color: AppColors.onSurfaceVariant, size: 20),
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text(AppStrings.all),
                    selected: _typeFilter == 'All',
                    onSelected: (b) { if (b) setState(() => _typeFilter = 'All'); },
                    avatar: Icon(Icons.apps_rounded, size: 18, color: _typeFilter == 'All' ? Colors.white : null),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: _typeFilter == 'All' ? Colors.white : null),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(AppStrings.doctors),
                    selected: _typeFilter == 'Doctors',
                    onSelected: (b) { if (b) setState(() => _typeFilter = 'Doctors'); },
                    avatar: Icon(Icons.medical_services_rounded, size: 18, color: _typeFilter == 'Doctors' ? Colors.white : null),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: _typeFilter == 'Doctors' ? Colors.white : null),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(AppStrings.pharmacies),
                    selected: _typeFilter == 'Pharmacies',
                    onSelected: (b) { if (b) setState(() => _typeFilter = 'Pharmacies'); },
                    avatar: Icon(Icons.local_pharmacy_rounded, size: 18, color: _typeFilter == 'Pharmacies' ? Colors.white : null),
                    selectedColor: AppColors.secondary,
                    labelStyle: TextStyle(color: _typeFilter == 'Pharmacies' ? Colors.white : null),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Institutions'),
                    selected: _typeFilter == 'Institutions',
                    onSelected: (b) { if (b) setState(() => _typeFilter = 'Institutions'); },
                    avatar: Icon(Icons.business_rounded, size: 18, color: _typeFilter == 'Institutions' ? Colors.white : null),
                    selectedColor: AppColors.tertiary,
                    labelStyle: TextStyle(color: _typeFilter == 'Institutions' ? Colors.white : null),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(clientsStreamProvider);
                // Wait briefly to allow stream to emit new state
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Builder(builder: (context) {
                if (!clientsAsync.hasValue && clientsAsync.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (clientsAsync.hasError && !clientsAsync.hasValue) {
                  return Center(
                    child: Text('Failed to load clients: ${clientsAsync.error}', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
                  );
                }
                final clients = clientsAsync.value ?? [];
                  final filtered = clients.where((c) {
                    if (_searchQuery.isNotEmpty) {
                      final q = _searchQuery;
                      final matches = (c.doctorName?.toLowerCase().contains(q) ?? false) ||
                          (c.facilityName?.toLowerCase().contains(q) ?? false) ||
                          (c.phoneNumber?.contains(q) ?? false) ||
                          (c.specialty?.toLowerCase().contains(q) ?? false) ||
                          (c.region?.toLowerCase().contains(q) ?? false);
                      if (!matches) return false;
                    }
                    if (_classFilter != 'All' && c.classTier != _classFilter) return false;
                    if (_specialtyFilter != 'All' && c.specialty != _specialtyFilter) return false;
                    if (_typeFilter != 'All') {
                      final type = c.clientType; // 'doctor', 'pharmacy', 'institution'
                      
                      final bool isDoctor = type == 'doctor';
                      final bool isPharmacy = type == 'pharmacy';
                      final bool isInstitution = type == 'institution';
                      
                      if (_typeFilter == 'Doctors' && !isDoctor) return false;
                      if (_typeFilter == 'Pharmacies' && !isPharmacy) return false;
                      if (_typeFilter == 'Institutions' && !isInstitution) return false;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
                                child: Icon(Icons.people_outline, size: 28, color: AppColors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 16),
                              Text(AppStrings.noClientsFound, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              TextButton(
                                onPressed: () {
                                  String q = '';
                                  if (_typeFilter == 'Pharmacies') q = '?type=pharmacy';
                                  if (_typeFilter == 'Institutions') q = '?type=institution';
                                  context.push('/clients/new$q');
                                },
                                child: Text(AppStrings.addANewClient),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (_isGridView) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => _buildGridItem(filtered[index]),
                    );
                  } else {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => _buildListItem(filtered[index]),
                    );
                  }
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(ClientModel client) {
    final name = client.doctorName ?? client.facilityName ?? 'Unnamed';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/clients/${client.id}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(initial, style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (client.classTier != null || client.specialty != null) ...[
              const SizedBox(height: 4),
              Text(
                client.specialty ?? 'Class ${client.classTier ?? "?"}',
                style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(ClientModel client) {
    final name = client.doctorName ?? client.facilityName ?? 'Unnamed';
    final subtitle = [
      if (client.specialty != null) client.specialty,
      if (client.classTier != null) 'Class ${client.classTier}',
      if (client.region != null) client.region,
    ].join(' • ');

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/clients/${client.id}'),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                      Row(
                      children: [
                        Expanded(
                          child: Text(name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                        ),
                        if (client.status == 'incomplete')
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('أكمل ما تبقى', style: AppTextStyles.labelSm.copyWith(color: AppColors.warning)),
                          ),
                      ],
                    ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                  if (client.phoneNumber != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone_rounded, size: 12, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(client.phoneNumber!, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }


  void _showFilterSheet(List<String> specialties) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.filters, style: AppTextStyles.headlineSm),
                      IconButton(
                        icon: Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(AppStrings.clientClass, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'A', 'B', 'C', 'D'].map((c) {
                      final active = _classFilter == c;
                      return ChoiceChip(
                        label: Text(c == 'All' ? 'All Classes' : 'Class $c'),
                        selected: active,
                        onSelected: (_) {
                          setSheetState(() => _classFilter = c);
                          setState(() => _classFilter = c);
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: active ? Colors.white : AppColors.onSurface),
                        backgroundColor: AppColors.surfaceContainer,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(AppStrings.specialty, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: specialties.map((s) {
                      final active = _specialtyFilter == s;
                      return ChoiceChip(
                        label: Text(s),
                        selected: active,
                        onSelected: (_) {
                          setSheetState(() => _specialtyFilter = s);
                          setState(() => _specialtyFilter = s);
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: active ? Colors.white : AppColors.onSurface),
                        backgroundColor: AppColors.surfaceContainer,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: MediaQuery.of(ctx).padding.bottom + 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
