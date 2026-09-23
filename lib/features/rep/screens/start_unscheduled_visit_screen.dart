import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/client_model.dart';

class StartUnscheduledVisitScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? clientId;
  const StartUnscheduledVisitScreen({super.key, this.taskId, this.clientId});

  @override
  ConsumerState<StartUnscheduledVisitScreen> createState() => _StartUnscheduledVisitScreenState();
}

class _StartUnscheduledVisitScreenState extends ConsumerState<StartUnscheduledVisitScreen> {
  String _searchQuery = '';
  String _typeFilter = 'All';
  bool _hasAutoNavigated = false;

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.startNewVisit),
      ),
      body: clientsAsync.when(
        data: (clients) {
          if (widget.clientId != null && !_hasAutoNavigated) {
            _hasAutoNavigated = true;
            final client = clients.where((c) => c.id == widget.clientId).firstOrNull;
            if (client != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                final taskParam = widget.taskId != null ? 'taskId=${widget.taskId}' : '';
                if (client.clientType == 'doctor') {
                  context.pushReplacement('/rep/doctor-visit?clientId=${client.id}${taskParam.isNotEmpty ? '&$taskParam' : ''}');
                } else {
                  context.pushReplacement('/rep/active_visit/unscheduled?clientId=${client.id}${taskParam.isNotEmpty ? '&$taskParam' : ''}');
                }
              });
              return const Center(child: CircularProgressIndicator());
            }
          }

          final filtered = clients.where((c) {
            final type = c.clientType;
            

            if (_searchQuery.isNotEmpty) {
              final q = _searchQuery;
              final matches = (c.doctorName?.toLowerCase().contains(q) ?? false) ||
                  (c.facilityName?.toLowerCase().contains(q) ?? false) ||
                  (c.specialty?.toLowerCase().contains(q) ?? false);
              if (!matches) return false;
            }
            if (_typeFilter != 'All') {
              if (_typeFilter == 'Doctors' && type != 'doctor') return false;
              if (_typeFilter == 'Pharmacies' && type != 'pharmacy') return false;
              if (_typeFilter == 'Institutions' && type != 'institution') return false;
            }
            return true;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Client',
                  style: AppTextStyles.headlineMd,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a client to start an unscheduled check-in.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  decoration: const InputDecoration(
                    labelText: AppStrings.doctorFacilityName,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
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
                        label: const Text('Doctors'),
                        selected: _typeFilter == 'Doctors',
                        onSelected: (b) { if (b) setState(() => _typeFilter = 'Doctors'); },
                        avatar: Icon(Icons.person_rounded, size: 18, color: _typeFilter == 'Doctors' ? Colors.white : null),
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
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == filtered.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: _ActionOption(
                            icon: Icons.person_add_rounded,
                            title: AppStrings.createNewClient,
                            onTap: () {
                              String q = '';
                              if (_typeFilter == 'Doctors') q = '?type=doctor';
                              if (_typeFilter == 'Pharmacies') q = '?type=pharmacy';
                              if (_typeFilter == 'Institutions') q = '?type=institution';
                              context.push('/clients/new$q');
                            },
                          ),
                        );
                      }
                      final client = filtered[index];
                      return Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: _ClientOption(
                          client: client,
                          onTap: () {
                            final taskParam = widget.taskId != null ? 'taskId=${widget.taskId}' : '';
                            if (client.clientType == 'doctor') {
                              context.pushReplacement('/rep/doctor-visit?clientId=${client.id}${taskParam.isNotEmpty ? '&$taskParam' : ''}');
                            } else {
                              context.pushReplacement('/rep/active_visit/unscheduled?clientId=${client.id}${taskParam.isNotEmpty ? '&$taskParam' : ''}');
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ClientOption extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;
  const _ClientOption({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          (client.doctorName ?? client.facilityName ?? '?').isNotEmpty
              ? (client.doctorName ?? client.facilityName ?? '?')[0].toUpperCase()
              : '?',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(client.doctorName ?? client.facilityName ?? 'Unknown', style: AppTextStyles.bodyLg),
      subtitle: Text(
        '${client.facilityName ?? ''}${client.specialty != null && client.facilityName != null ? ' · ' : ''}${client.specialty ?? ''}',
        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
      ),
      onTap: onTap,
    );
  }
}

class _ActionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ActionOption({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary)),
      onTap: onTap,
    );
  }
}
