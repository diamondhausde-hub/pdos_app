with open('lib/core/services/schedule_sync_service.dart', 'r', encoding='utf-8') as f:
    text = f.read()

center_original = '''          if (serverId != center.id) {
            await _localDb.updateAppointmentsCenterId(oldId: center.id, newId: serverId);
            await _localDb.updateVisitsCenterId(oldId: center.id, newId: serverId);
            await _localDb.deleteLocalCenter(center.id);
          }'''

center_new = '''          if (serverId != center.id) {
            await _localDb.updateAppointmentsCenterId(oldId: center.id, newId: serverId);
            await _localDb.updateVisitsCenterId(oldId: center.id, newId: serverId);
            await _localDb.deleteLocalCenter(center.id);
            final newLocalCenter = LocalCenter(
              id: serverId,
              name: center.name,
              region: center.region,
              latitude: center.latitude,
              longitude: center.longitude,
              address: center.address,
              assignedRepId: center.assignedRepId,
              brandId: center.brandId,
              synced: true,
            );
            await _localDb.into(_localDb.localCenters).insert(newLocalCenter, mode: drift.InsertMode.insertOrReplace);
          }'''

if 'final newLocalCenter = LocalCenter' not in text:
    text = text.replace(center_original, center_new)

appt_original = '''            'reminder_minutes_before': model.reminderMinutesBefore,
            'notes': model.notes,
            'status': model.status.name,
          };'''

appt_new = '''            'reminder_minutes_before': model.reminderMinutesBefore,
            'notes': model.notes,
            'supervisor_note': model.supervisorNote,
            'suggested_product_id': model.suggestedProductId,
            'status': model.status.name,
          };'''

if 'supervisor_note' not in text:
    text = text.replace(appt_original, appt_new)

with open('lib/core/services/schedule_sync_service.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
