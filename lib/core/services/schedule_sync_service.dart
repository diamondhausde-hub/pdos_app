// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:dio/dio.dart';
import '../local_db/app_database.dart';
import '../models/appointment_model.dart';
import '../models/center_model.dart';
import '../models/client_model.dart';
import 'api_service.dart';
import 'notification_service.dart';

class ScheduleSyncService {
  final ApiService _api = ApiService.instance;
  final AppDatabase _localDb;

  ScheduleSyncService(this._localDb);

  Future<void> pushCenters() async {
    try {
      final unsynced = await _localDb.getUnsyncedCenters();
      for (final center in unsynced) {
        try {
          final payload = {
            'name': center.name,
            'region': center.region,
            'latitude': center.latitude,
            'longitude': center.longitude,
            'address': center.address,
            'assigned_rep_id': center.assignedRepId,
            'brand_id': center.brandId,
          };
          
          final response = await _api.dio.post('/centers', data: payload);
          final serverId = response.data['id'] as String;
          
          await _localDb.transaction(() async {
            if (serverId != center.id) {
              await _localDb.updateAppointmentsCenterId(oldId: center.id, newId: serverId);
              await _localDb.updateVisitsCenterId(oldId: center.id, newId: serverId);
              await _localDb.deleteLocalCenter(center.id);
            } else {
              await _localDb.markCenterSynced(center.id);
            }
          });
        } catch (e) {
          print('Failed to push center ${center.id}: $e');
        }
      }
    } catch (e) {
      print('Failed to push centers: $e');
    }
  }

  Future<void> pullCenters() async {
    try {
      final response = await _api.dio.get('/centers');
      final data = response.data as List;
      final centers = data.map((e) => CenterModel.fromJson(e)).toList();

      await _localDb.transaction(() async {
        final serverIds = centers.map((c) => c.id).toList();
        
        // Delete local centers that are synced but no longer returned by the server (soft deleted)
        if (serverIds.isNotEmpty) {
          await (_localDb.delete(_localDb.localCenters)
            ..where((t) => t.id.isNotIn(serverIds) & t.synced.equals(true)))
            .go();
        } else {
          // If server returned empty, delete all synced centers
          await (_localDb.delete(_localDb.localCenters)
            ..where((t) => t.synced.equals(true)))
            .go();
        }

        for (final center in centers) {
          await _localDb.into(_localDb.localCenters).insert(
                LocalCentersCompanion.insert(
                  id: center.id,
                  name: center.name,
                  region: drift.Value(center.region),
                  latitude: drift.Value(center.latitude),
                  longitude: drift.Value(center.longitude),
                  address: drift.Value(center.address),
                  assignedRepId: drift.Value(center.assignedRepId),
                  status: drift.Value(center.status),
                  createdAt: center.createdAt,
                  updatedAt: center.updatedAt,
                  brandId: drift.Value(center.brandId),
                  synced: const drift.Value(true),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }
      });
    } catch (e) {
      print('Failed to pull centers: $e');
    }
  }

  Future<void> pushAppointments() async {
    try {
      final unsynced = await _localDb.getUnsyncedAppointments();
      for (final localAppt in unsynced) {
        final model = AppointmentModel.fromLocal(localAppt);
        try {
          final payload = {
            'id': model.id,
            'rep_id': model.repId,
            'client_id': model.clientId,
            'center_id': model.centerId,
            'appt_date': model.apptDate.toIso8601String(),
            'appt_time': model.apptTime,
            'reminder_minutes_before': model.reminderMinutesBefore,
            'notes': model.notes,
            'status': model.status.name,
          };
          
          await _api.dio.post('/appointments', data: payload);
          // Mark as synced locally
          await (_localDb.update(_localDb.localAppointments)..where((t) => t.id.equals(localAppt.id)))
              .write(const LocalAppointmentsCompanion(synced: drift.Value(true)));
        } catch (e) {
          print('Failed to push appointment ${localAppt.id}: $e');
        }
      }
    } catch (e) {
      print('Failed to push appointments: $e');
    }
  }

  Future<void> pullAppointments({String? repId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (repId != null) queryParams['rep_id'] = repId;
      final response = await _api.dio.get('/appointments', queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final data = response.data as List;
      final appointments = data.map((e) => AppointmentModel.fromJson(e)).toList();

      await _localDb.transaction(() async {
        final serverIds = appointments.map((a) => a.id).toList();

        // Delete stale appointments (synced ones not in server response)
        if (serverIds.isNotEmpty) {
          await (_localDb.delete(_localDb.localAppointments)
            ..where((t) => t.id.isNotIn(serverIds) & t.synced.equals(true)))
            .go();
        }

        for (final appt in appointments) {
          await _localDb.into(_localDb.localAppointments).insert(
                appt.toLocalCompanion().copyWith(synced: const drift.Value(true)),
                mode: drift.InsertMode.insertOrReplace,
              );
        }
      });
      
      // Schedule notifications outside the database transaction to prevent deadlocks
      for (final appt in appointments) {
        if (appt.status == AppointmentStatus.pending) {
          await notificationService.scheduleAppointmentReminder(appt);
        } else {
          await notificationService.cancelAppointmentReminder(appt.id);
        }
      }
    } catch (e) {
      print('Failed to pull appointments: $e');
    }
  }

  Future<void> pushClients() async {
    try {
      final unsynced = await _localDb.getUnsyncedClients();
      for (final local in unsynced) {
        final model = ClientModel.fromLocal(local);
        try {
          // Reverted to unified /clients endpoint as backend is not yet split
          await _api.dio.post('/clients', data: model.toJson());
          await _localDb.markClientSynced(model.id);
        } catch (e) {
          print('Failed to push client ${model.id}: $e');
        }
      }
    } catch (e) {
      print('Failed to push clients: $e');
    }
  }

  Future<void> pullVisits({String? repId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (repId != null) queryParams['rep_id'] = repId;
      final response = await _api.dio.get(
        '/visits',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = response.data as List;

      await _localDb.transaction(() async {
        final serverIds = data.map((e) => e['id'] as String).toList();

        // Remove stale synced visits that no longer exist on the server
        if (serverIds.isNotEmpty) {
          await (_localDb.delete(_localDb.localVisits)
            ..where((t) => t.id.isNotIn(serverIds) & t.synced.equals(true)))
            .go();
        }

        for (final raw in data) {
          final v = raw as Map<String, dynamic>;
          // Only upsert visits that have been accepted/processed by the server
          // (synced=true means they came from the server)
          final existing = await (_localDb.select(_localDb.localVisits)
            ..where((t) => t.id.equals(v['id'] as String)))
            .getSingleOrNull();

          // If we have a local unsynced version, don't overwrite it
          if (existing != null && !existing.synced) continue;

          await _localDb.into(_localDb.localVisits).insertOnConflictUpdate(
            LocalVisitsCompanion.insert(
              id: v['id'] as String,
              referenceCode: drift.Value(v['reference_code'] as String?),
              repId: v['rep_id'] as String,
              centerId: v['center_id'] as String? ?? '',
              clientId: drift.Value(v['client_id'] as String?),
              appointmentId: drift.Value(v['appointment_id'] as String?),
              taskId: drift.Value(v['task_id'] as String?),
              visitDate: DateTime.parse(v['visit_date'] as String),
              arrivalTime: drift.Value(v['arrival_time'] != null ? DateTime.parse(v['arrival_time'] as String) : null),
              completionTime: drift.Value(v['completion_time'] != null ? DateTime.parse(v['completion_time'] as String) : null),
              status: v['status'] as String? ?? 'planned',
              notes: drift.Value(v['notes'] as String?),
              latitude: drift.Value((v['latitude'] as num?)?.toDouble()),
              longitude: drift.Value((v['longitude'] as num?)?.toDouble()),
              supervisorNote: drift.Value(v['supervisor_note'] as String?),
              retroactiveReason: drift.Value(v['retroactive_reason'] as String?),
              saveLocationLat: drift.Value((v['save_location_lat'] as num?)?.toDouble()),
              saveLocationLng: drift.Value((v['save_location_lng'] as num?)?.toDouble()),
              signatureUrl: drift.Value(v['signature_url'] as String?),
              visitType: drift.Value(v['visit_type'] as String? ?? 'center'),
              visitReason: drift.Value(v['visit_reason'] as String?),
              interestedProductIds: drift.Value(v['interested_product_ids'] != null
                  ? (v['interested_product_ids'] as List).join(',')
                  : null),
              synced: const drift.Value(true),
              isFlagged: drift.Value(v['status'] == 'flagged'),
              isAbandoned: const drift.Value(false),
              createdAt: DateTime.parse(v['created_at'] as String),
              updatedAt: DateTime.parse(v['updated_at'] as String),
            ),
          );
        }
      });
    } catch (e) {
      print('Failed to pull visits: $e');
    }
  }

  Future<void> pullClients({String? repId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (repId != null) queryParams['rep_id'] = repId;
      
      // Reverted to unified /clients endpoint as backend is not yet split
      final response = await _api.dio.get('/clients', queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final data = response.data as List;
      final clients = data.map((e) => ClientModel.fromJson(e as Map<String, dynamic>)).toList();

      await _localDb.transaction(() async {
        final serverIds = clients.map((c) => c.id).toList();

        if (serverIds.isEmpty) {
          await (_localDb.delete(_localDb.localClients)..where((t) => t.synced.equals(true))).go();
        } else {
          await (_localDb.delete(_localDb.localClients)
            ..where((t) => t.id.isNotIn(serverIds) & t.synced.equals(true)))
            .go();
        }

        for (final client in clients) {
          await _localDb.into(_localDb.localClients).insert(
                client.toLocalCompanion().copyWith(synced: const drift.Value(true)),
                mode: drift.InsertMode.insertOrReplace,
              );
        }
      });
    } catch (e) {
      print('Failed to pull clients: $e');
    }
  }

  Future<void> pushSignature(String userId) async {
    try {
      final sig = await (_localDb.select(_localDb.localUserSignatures)..where((t) => t.id.equals(userId))).getSingleOrNull();
      if (sig != null && !sig.synced) {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(sig.imagePath),
        });
        await _api.dio.post('/users/me/signatures', data: formData);
        await (_localDb.update(_localDb.localUserSignatures)..where((t) => t.id.equals(userId))).write(
          const LocalUserSignaturesCompanion(synced: drift.Value(true))
        );
      }
    } catch (e) {
      print('Failed to push signature: $e');
    }
  }

  Future<void> pullSignature(String userId) async {
    try {
      final localSig = await (_localDb.select(_localDb.localUserSignatures)..where((t) => t.id.equals(userId))).getSingleOrNull();
      if (localSig != null && !localSig.synced) {
        // Local has unsynced changes. Last-write-wins with local prioritizing unsynced.
        // So we skip pull.
        return;
      }
      
      final response = await _api.dio.get('/users/me/signatures');
      // If 404, exception is thrown and caught below.
      final data = response.data;
      final serverUpdatedAt = DateTime.parse(data['updated_at']);
      
      if (localSig != null && !serverUpdatedAt.isAfter(localSig.updatedAt)) {
        return; // Local is up to date
      }
      
      // Download the image
      final imageUrl = data['image_url'];
      final downloadRes = await _api.dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(downloadRes.data);
      
      if (localSig != null) {
        final oldFile = File(localSig.imagePath);
        if (await oldFile.exists()) await oldFile.delete();
      }
      
      await _localDb.into(_localDb.localUserSignatures).insertOnConflictUpdate(
        LocalUserSignaturesCompanion(
          id: drift.Value(userId),
          pointsJson: drift.Value(localSig?.pointsJson ?? '[]'), // Server doesn't send points, preserve local if any
          imagePath: drift.Value(file.path),
          createdAt: drift.Value(DateTime.parse(data['created_at'])),
          updatedAt: drift.Value(serverUpdatedAt),
          synced: const drift.Value(true),
        )
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        // No signature on server. If we have a synced one locally, it means server deleted it.
        final localSig = await (_localDb.select(_localDb.localUserSignatures)..where((t) => t.id.equals(userId))).getSingleOrNull();
        if (localSig != null && localSig.synced) {
          final file = File(localSig.imagePath);
          if (await file.exists()) await file.delete();
          await (_localDb.delete(_localDb.localUserSignatures)..where((t) => t.id.equals(userId))).go();
        }
      } else {
        print('Failed to pull signature: $e');
      }
    }
  }
}
