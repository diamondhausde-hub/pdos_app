// ignore_for_file: avoid_print, use_null_aware_elements
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/visit_model.dart';
import '../services/api_service.dart';
import '../services/sync_orchestrator.dart';
import '../local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;

class VisitRepository {
  final ApiService _api = ApiService.instance;
  final AppDatabase _localDb;
  final SyncOrchestrator _syncOrchestrator;
  final _uuid = const Uuid();

  VisitRepository(this._localDb, this._syncOrchestrator);

  Future<List<VisitModel>> getVisitsByStatus(String status, {String? brandId}) async {
    try {
      final queryParams = <String, dynamic>{'status': status};
      if (brandId != null) queryParams['brand_id'] = brandId;
      final response = await _api.dio.get('/visits', queryParameters: queryParams);
      final data = response.data as List;
      return data.map((e) => VisitModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<VisitModel>> getAllVisits({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      final response = await _api.dio.get('/visits', queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final data = response.data as List;
      return data.map((e) => VisitModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> reviewVisit(String visitId, String status, {String? note}) async {
    await _api.dio.put('/visits/$visitId/review', data: {
      'status': status,
      'note': note,
    });
  }

  Future<void> addVisitNote(String visitId, String note) async {
    await _api.dio.put('/visits/$visitId/note', data: {
      'review_note': note,
    });
  }

  Future<void> createVisit(VisitModel visit) async {
    final companion = LocalVisit(
      id: visit.id,
      repId: visit.repId,
      centerId: visit.centerId,
      visitDate: visit.visitDate,
      arrivalTime: visit.arrivalTime,
      completionTime: visit.completionTime,
      status: visit.status.name,
      notes: visit.notes,
      latitude: visit.latitude,
      longitude: visit.longitude,
      appointmentId: null,
      taskId: visit.taskId,
      createdAt: visit.createdAt,
      updatedAt: DateTime.now(),
      synced: false,
      isFlagged: false,
      isAbandoned: false,
      visitType: 'center',
    );
    await _localDb.into(_localDb.localVisits).insert(companion);
    await _syncOrchestrator.syncAllInOrder();
  }

  Future<String> startVisit({
    required String repId,
    required String centerId,
    String? clientId,
    double? latitude,
    double? longitude,
    String? appointmentId,
    String? taskId,
  }) async {
    final visitId = _uuid.v4();

    // Try backend check-in first (Server is authority)
    try {
      final payload = <String, dynamic>{
        'visit_id': visitId,
        'rep_id': repId,
        if (centerId.isNotEmpty) 'center_id': centerId,
        if (clientId != null) 'client_id': clientId,
        if (appointmentId != null) 'appointment_id': appointmentId,
        if (taskId != null) 'task_id': taskId,
        'latitude': latitude,
        'longitude': longitude,
      };
      await _api.dio.post('/visits/check-in', data: payload);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        // Server rejected check-in due to distance
        throw Exception(e.response?.data['detail'] ?? 'Check-in rejected by server.');
      }
      // If it's a network error, we proceed provisionally (offline mode).
      // The visit is optimistically considered 'in_progress' locally.
      print('Offline check-in fallback: $e');
    }

    final newVisit = LocalVisit(
      id: visitId,
      repId: repId,
      centerId: centerId,
      clientId: clientId,
      appointmentId: appointmentId,
      taskId: taskId,
      visitDate: DateTime.now(),
      arrivalTime: DateTime.now(),
      status: 'in_progress', // ALWAYS start in_progress locally; server may flag it later.
      synced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      isFlagged: false,
      isAbandoned: false,
      visitType: clientId != null ? 'doctor' : 'center',
    );
    await _localDb.into(_localDb.localVisits).insert(newVisit);
    
    return visitId;
  }

  Future<void> completeVisit({
    required String visitId,
    String? notes,
    required List<Map<String, dynamic>> salesItems,
    required List<Map<String, dynamic>> stockChecks,
    String? signaturePath,
  }) async {
    await _localDb.transaction(() async {
      final companion = LocalVisitsCompanion(
        completionTime: drift.Value(DateTime.now()),
        notes: drift.Value(notes),
        status: const drift.Value('completed'),
        synced: const drift.Value(false),
        updatedAt: drift.Value(DateTime.now()),
        signaturePath: drift.Value(signaturePath),
      );
      
      await (_localDb.update(_localDb.localVisits)..where((t) => t.id.equals(visitId))).write(companion);
      
      for (final item in salesItems) {
        await _localDb.into(_localDb.localVisitItems).insert(
          LocalVisitItem(
            id: _uuid.v4(),
            visitId: visitId,
            productId: item['productId'] as String,
            qtySold: item['qtySold'] as int,
            qtyFree: item['qtyFree'] as int,
            priceAtSale: item['priceAtSale'] as double?,
            synced: false,
            createdAt: DateTime.now(),
            isAbandoned: false,
          )
        );
      }

      for (final check in stockChecks) {
        await _localDb.into(_localDb.localPharmacyStockChecks).insert(
          LocalPharmacyStockCheck(
            id: _uuid.v4(),
            visitId: visitId,
            productId: check['productId'] as String,
            observedQty: check['observedQty'] as int,
            synced: false,
            createdAt: DateTime.now(),
            isAbandoned: false,
          )
        );
      }
    });

    // Fire and forget sync
    _syncOrchestrator.syncAllInOrder().catchError((e) => print('Background sync failed: $e'));
  }

  Future<void> cancelVisit(String visitId) async {
    await (_localDb.delete(_localDb.localVisits)..where((t) => t.id.equals(visitId))).go();
  }

  Stream<LocalVisit?> watchActiveVisit(String repId) {
    return (_localDb.select(_localDb.localVisits)
          ..where((t) => t.repId.equals(repId) & t.status.equals('in_progress'))
          ..limit(1))
        .watchSingleOrNull();
  }
}
