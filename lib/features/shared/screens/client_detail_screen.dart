import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/client_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../shared/widgets/schedule_appointment_sheet.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String clientId;
  const ClientDetailScreen({super.key, required this.clientId});

  @override
  ConsumerState<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  final _noteController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _sendNote() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    setState(() => _sending = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.dio.post('/centers/${widget.clientId}/report', data: {'content': note});
      _noteController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report sent to supervisor')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send report: ${e.message}')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: const Text('Client Details'),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: 'Schedule Appointment',
            onPressed: () => showScheduleAppointmentSheet(context, ref, initialClientId: widget.clientId),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push('/clients/edit/${widget.clientId}'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/rep/active_visit/unscheduled?clientId=${widget.clientId}'),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Start Visit'),
      ),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (clients) {
          final client = clients.where((c) => c.id == widget.clientId).firstOrNull;
          if (client == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off_rounded, size: 64, color: AppColors.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('Client not found', style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (client.status == 'incomplete')
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: AppColors.warning.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ملف الطبيب غير مكتمل، أكمل ما تبقى من البيانات.',
                          style: AppTextStyles.bodySm.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/clients/edit/${client.id}'),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                _buildHeader(client),
                const SizedBox(height: 20),
                _buildSection('Doctor Info', [
                  _infoRow(Icons.person_rounded, 'Name', client.doctorName ?? 'N/A'),
                  _infoRow(Icons.medical_services_rounded, 'Specialty', client.specialty ?? 'N/A'),
                  if (client.birthDate != null)
                    _infoRow(Icons.cake_rounded, 'Birth Date', '${client.birthDate!.day}/${client.birthDate!.month}/${client.birthDate!.year}'),
                  _infoRow(Icons.star_rounded, 'Class', client.classTier ?? 'N/A'),
                  _infoRow(Icons.handshake_rounded, 'Relationship', client.relationshipType ?? 'N/A'),
                  if (client.description != null && client.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(client.description!, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    ),
                ]),
                const SizedBox(height: 16),
                _buildSection('Facility Info', [
                  _infoRow(Icons.business_rounded, 'Name', client.facilityName ?? 'N/A'),
                  _infoRow(Icons.category_rounded, 'Type', client.facilityType ?? 'N/A'),
                ]),
                const SizedBox(height: 16),
                _buildSection('Contact', [
                  if (client.phoneNumber != null)
                    _infoRow(Icons.phone_rounded, 'Phone', client.phoneNumber!),
                ]),
                const SizedBox(height: 16),
                _buildSection('Location', [
                  _infoRow(Icons.location_city_rounded, 'Region', client.region ?? 'N/A'),
                  _infoRow(Icons.map_rounded, 'Area', client.area ?? 'N/A'),
                  _infoRow(Icons.signpost_rounded, 'Street', client.street ?? 'N/A'),
                  _infoRow(Icons.location_on_rounded, 'Landmark', client.nearbyLandmark ?? 'N/A'),
                ]),
                const SizedBox(height: 24),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Note to Supervisor', style: AppTextStyles.h4),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Type your report/note here...',
                          filled: true,
                          fillColor: AppColors.surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _sending ? null : _sendNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _sending
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Send Note'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          ),
          ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(ClientModel client) {
    final name = client.doctorName ?? client.facilityName ?? 'Unnamed';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(initial, style: AppTextStyles.headlineLg.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(height: 16),
          Text(name, style: AppTextStyles.headlineMd, textAlign: TextAlign.center),
          if (client.classTier != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.5)),
              ),
              child: Text(
                'Class ${client.classTier}',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.tertiary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                Text(value, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
