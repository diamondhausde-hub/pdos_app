import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/appointment_model.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/center_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';

Future<bool?> showScheduleAppointmentSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialClientId,
  String? initialCenterId,
  AppointmentModel? initialAppointment,
  ClientModel? initialClientObj,
}) async {
  ClientModel? selectedClient = initialClientObj;
  if (selectedClient == null && initialClientId != null) {
    final clients = ref.read(clientsStreamProvider).asData?.value ?? [];
    selectedClient = clients.where((c) => c.id == initialClientId).firstOrNull;
  }

  CenterModel? selectedCenter;
  if (initialCenterId != null) {
    final centers = ref.read(centersProvider).asData?.value ?? [];
    selectedCenter = centers.where((c) => c.id == initialCenterId).firstOrNull;
  }

  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AppointmentSheetContent(
      initialClient: selectedClient,
      initialCenter: selectedCenter,
      initialAppointment: initialAppointment,
    ),
  );
}

class _AppointmentSheetContent extends ConsumerStatefulWidget {
  final ClientModel? initialClient;
  final CenterModel? initialCenter;
  final AppointmentModel? initialAppointment;
  const _AppointmentSheetContent({this.initialClient, this.initialCenter, this.initialAppointment});

  @override
  ConsumerState<_AppointmentSheetContent> createState() => _AppointmentSheetContentState();
}

class _AppointmentSheetContentState extends ConsumerState<_AppointmentSheetContent> {
  ClientModel? _selectedClient;
  CenterModel? _selectedCenter;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int _reminderMinutes = 30;
  final _notesCtrl = TextEditingController();
  bool _isSaving = false;

  final List<int> _reminderOptions = [15, 30, 60, 120];

  @override
  void initState() {
    super.initState();
    if (widget.initialAppointment != null) {
      final appt = widget.initialAppointment!;
      if (appt.clientId != null) {
        _selectedClient = ClientModel(id: appt.clientId!, facilityName: appt.clientName, repId: appt.repId, createdAt: DateTime.now(), updatedAt: DateTime.now());
      }
      if (appt.centerId != null) {
        _selectedCenter = CenterModel(id: appt.centerId!, name: appt.centerName ?? '', isActive: true, status: 'active', createdAt: DateTime.now(), updatedAt: DateTime.now());
      }
      _selectedDate = appt.apptDate;
      final timeParts = appt.apptTime.split(':');
      if (timeParts.length >= 2) {
        _selectedTime = TimeOfDay(hour: int.tryParse(timeParts[0]) ?? 10, minute: int.tryParse(timeParts[1]) ?? 0);
      }
      _reminderMinutes = appt.reminderMinutesBefore;
      if (appt.notes != null) {
        _notesCtrl.text = appt.notes!;
      }
    } else {
      _selectedClient = widget.initialClient;
      _selectedCenter = widget.initialCenter;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  String _reminderLabel(int minutes) {
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    return '$hours hrs';
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);
    final clients = clientsAsync.asData?.value ?? [];
    
    final centersAsync = ref.watch(centersProvider);
    final centers = centersAsync.asData?.value ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 12,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.event_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.lbl_71, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 2),
                      Text(AppStrings.lbl_72, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Date & Time pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    child: GlassCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.lbl_73, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 2),
                                Text(DateFormat('yyyy/MM/dd').format(_selectedDate),
                                    style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) setState(() => _selectedTime = time);
                    },
                    child: GlassCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.lbl_74, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 2),
                                Text(_selectedTime.format(context),
                                    style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Center/Client Selection
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.lbl_75, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      if (_selectedClient != null || _selectedCenter != null)
                        InkWell(
                          onTap: () => setState(() { _selectedClient = null; _selectedCenter = null; }),
                          child: Text(AppStrings.lbl_76, style: AppTextStyles.labelSm.copyWith(color: AppColors.error)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_selectedClient == null && _selectedCenter == null)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showCenterPicker(centers),
                            icon: const Icon(Icons.store_rounded, size: 18),
                            label: const Text(AppStrings.lbl_77),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showClientPicker(clients),
                            icon: const Icon(Icons.person_rounded, size: 18),
                            label: const Text(AppStrings.lbl_78),
                          ),
                        ),
                      ],
                    )
                  else if (_selectedCenter != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.tertiary.withValues(alpha: 0.12),
                        child: Icon(Icons.store_rounded, color: AppColors.tertiary),
                      ),
                      title: Text(_selectedCenter!.name, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                      subtitle: _selectedCenter!.region != null ? Text(_selectedCenter!.region!) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 20),
                        onPressed: () => _showCenterPicker(centers),
                      ),
                    )
                  else if (_selectedClient != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        child: Icon(Icons.person_rounded, color: AppColors.primary),
                      ),
                      title: Text(_selectedClient!.doctorName ?? _selectedClient!.facilityName ?? 'Client', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                      subtitle: _selectedClient!.specialty != null ? Text(_selectedClient!.specialty!) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 20),
                        onPressed: () => _showClientPicker(clients),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reminder picker
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active_rounded, color: AppColors.warning, size: 20),
                      const SizedBox(width: 10),
                      Text(AppStrings.lbl_79, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _reminderOptions.map((minutes) {
                      final isSelected = _reminderMinutes == minutes;
                      return ChoiceChip(
                        label: Text(_reminderLabel(minutes)),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _reminderMinutes = minutes),
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: AppTextStyles.labelMd.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: _notesCtrl,
                maxLines: 2,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: AppStrings.lbl_23,
                  hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.notes_rounded, color: AppColors.info, size: 20),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 20),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveAppointment,
                icon: _isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded, size: 20),
                label: Text(_isSaving ? 'Saving...' : 'Confirm Appointment'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCenterPicker(List<CenterModel> centers) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(AppStrings.lbl_80, style: AppTextStyles.headlineSm),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: centers.length,
                  itemBuilder: (ctx, i) {
                    final center = centers[i];
                    return ListTile(
                      leading: Icon(Icons.store_rounded, color: AppColors.tertiary),
                      title: Text(center.name),
                      subtitle: center.region != null ? Text(center.region!) : null,
                      onTap: () {
                        setState(() { _selectedCenter = center; _selectedClient = null; });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClientPicker(List<ClientModel> clients) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(AppStrings.lbl_81, style: AppTextStyles.headlineSm),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (ctx, i) {
                    final client = clients[i];
                    return ListTile(
                      leading: Icon(Icons.person_rounded, color: AppColors.primary),
                      title: Text(client.doctorName ?? client.facilityName ?? 'Client'),
                      subtitle: client.specialty != null ? Text(client.specialty!) : null,
                      onTap: () {
                        setState(() { _selectedClient = client; _selectedCenter = null; });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAppointment() async {
    if (_selectedClient == null && _selectedCenter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.lbl_82)),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (dateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.lbl_83)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final isEdit = widget.initialAppointment != null;
      final newId = isEdit ? widget.initialAppointment!.id : const Uuid().v4();
      final appt = AppointmentModel(
        id: newId,
        repId: user.id,
        clientId: _selectedClient?.id,
        clientName: _selectedClient?.doctorName ?? _selectedClient?.facilityName,
        centerId: _selectedCenter?.id,
        centerName: _selectedCenter?.name,
        apptDate: _selectedDate,
        apptTime: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        reminderMinutesBefore: _reminderMinutes,
        notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
        status: isEdit ? widget.initialAppointment!.status : AppointmentStatus.pending,
        synced: isEdit ? widget.initialAppointment!.synced : false,
        createdAt: isEdit ? widget.initialAppointment!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEdit) {
        await ref.read(appointmentRepositoryProvider).updateAppointment(appt);
      } else {
        await ref.read(appointmentRepositoryProvider).createAppointment(appt);
      }
      ref.invalidate(appointmentsProvider);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.lbl_84),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
