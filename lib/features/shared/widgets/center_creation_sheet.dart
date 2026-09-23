import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/center_model.dart';
import 'schedule_appointment_sheet.dart';

Future<void> showCenterCreationSheet(
  BuildContext context,
  WidgetRef ref, {
  String initialName = '',
  required Function(String centerId) onCreated,
}) async {
  final nameCtrl = TextEditingController(text: initialName);
  final streetCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String region = 'Baghdad';
  bool isGettingLocation = false;
  double? lat;
  double? lng;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.addClientPharmacy, style: AppTextStyles.headlineMd),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                  border: OutlineInputBorder(),
                ),
                
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: region,
                decoration: const InputDecoration(
                  labelText: AppStrings.region,
                  border: OutlineInputBorder(),
                ),
                items: ['Baghdad', 'Basra', 'Erbil', 'Mosul', 'Najaf', 'Karbala', 'Kirkuk', 'Sulaymaniyah', 'Anbar', 'Babil', 'Diyala', 'Duhok', 'Maysan', 'Muthanna', 'Qadisiyyah', 'Saladin', 'Wasit', 'Dhi Qar']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setSheetState(() => region = v ?? 'Baghdad'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: streetCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.u0627U0633U0645U0627,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: landmarkCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.u0645U0643U0627U0646,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.u0645U0644U0627U062d,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: isGettingLocation
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.location_on),
                label: Text(lat != null ? 'Location Set' : 'Get Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lat != null ? AppColors.success : null,
                  foregroundColor: lat != null ? Colors.white : null,
                ),
                onPressed: isGettingLocation
                    ? null
                    : () async {
                        setSheetState(() => isGettingLocation = true);
                        try {
                          if (!await Geolocator.isLocationServiceEnabled()) {
                            throw Exception('Location disabled');
                          }
                          var perm = await Geolocator.checkPermission();
                          if (perm == LocationPermission.denied) {
                            perm = await Geolocator.requestPermission();
                          }
                          if (perm == LocationPermission.denied ||
                              perm == LocationPermission.deniedForever) {
                            throw Exception('Permission denied');
                          }
                          var pos = await Geolocator.getCurrentPosition(
                            locationSettings: const LocationSettings(
                              accuracy: LocationAccuracy.high,
                            ),
                          );

                          setSheetState(() {
                            lat = pos.latitude;
                            lng = pos.longitude;
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        } finally {
                          setSheetState(() => isGettingLocation = false);
                        }
                      },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppStrings.nameIsRequired)),
                      );
                      return;
                    }
                    
                    final user = ref.read(currentUserProvider);
                    if (user == null) return;
                    

                    final addressParts = <String>[];
                    if (streetCtrl.text.trim().isNotEmpty) addressParts.add('\u0627\u0644\u0634\u0627\u0631\u0639/\u0627\u0644\u0645\u0646\u0637\u0642\u0629: ${streetCtrl.text.trim()}');
                    if (landmarkCtrl.text.trim().isNotEmpty) addressParts.add('\u0623\u0642\u0631\u0628 \u0645\u0639\u0644\u0645: ${landmarkCtrl.text.trim()}');
                    if (noteCtrl.text.trim().isNotEmpty) addressParts.add('\u0645\u0644\u0627\u062d\u0638\u0629: ${noteCtrl.text.trim()}');
                    final fullAddress = addressParts.join('\n');

                    final newId = const Uuid().v4();
                    await ref.read(centerRepositoryProvider).createLocalCenter(
                          CenterModel(
                            id: newId,
                            name: nameCtrl.text.trim(),
                            region: region,
                            latitude: lat,
                            longitude: lng,
                            address: fullAddress.isNotEmpty ? fullAddress : null,
                            assignedRepId: user.id,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );
                    
                    // Trigger sync in background immediately
                    ref.read(scheduleSyncServiceProvider).pushCenters();

                    ref.invalidate(centersProvider);
                    if (context.mounted) Navigator.pop(ctx);
                    onCreated(newId);
                    
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: Text(AppStrings.scheduleFollowUp_68),
                          content: Text(AppStrings.doYouWantTo),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: Text(AppStrings.noLater),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(c);
                                showScheduleAppointmentSheet(context, ref);
                              },
                              child: Text(AppStrings.yesSchedule),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text(AppStrings.saveClient),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    ),
  );
}
