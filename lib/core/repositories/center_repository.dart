// ignore_for_file: avoid_print
import 'package:drift/drift.dart' as drift;
import '../models/center_model.dart';
import '../local_db/app_database.dart';
import '../services/api_service.dart';

class CenterRepository {
  final ApiService _api = ApiService.instance;
  final AppDatabase _localDb;

  CenterRepository(this._localDb);

  Future<List<CenterModel>> getCenters() async {
    final rows = await _localDb.select(_localDb.localCenters).get();
    return rows.map((r) => CenterModel(
      id: r.id,
      name: r.name,
      region: r.region,
      latitude: r.latitude,
      longitude: r.longitude,
      address: r.address,
      assignedRepId: r.assignedRepId,
      status: r.status,
      rejectionReason: r.rejectionReason,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      brandId: r.brandId,
    )).toList();
  }

  Future<void> approveCenter(String centerId, String status, {String? rejectionReason}) async {
    await _api.dio.patch('/centers/$centerId/status', data: {
      'status': status,
      'rejection_reason': rejectionReason,
    });
  }

  Future<CenterModel?> getCenterById(String id) async {
    // 1. Try local DB first (fast, works offline)
    final r = await (_localDb.select(_localDb.localCenters)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (r != null) {
      return CenterModel(
        id: r.id,
        name: r.name,
        region: r.region,
        latitude: r.latitude,
        longitude: r.longitude,
        address: r.address,
        assignedRepId: r.assignedRepId,
        status: r.status,
        rejectionReason: r.rejectionReason,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
        brandId: r.brandId,
      );
    }
    // 2. Fallback: fetch from remote and cache locally for next time
    try {
      final response = await _api.dio.get('/centers/$id');
      // API may return a single object or a list — handle both
      final Map<String, dynamic> json;
      if (response.data is List) {
        final list = response.data as List;
        if (list.isEmpty) return null;
        json = list.first as Map<String, dynamic>;
      } else {
        json = response.data as Map<String, dynamic>;
      }
      final center = CenterModel.fromJson(json);
      // Cache it locally so future visits resolve correctly
      await _localDb.into(_localDb.localCenters).insertOnConflictUpdate(LocalCentersCompanion.insert(
        id: center.id,
        name: center.name,
        region: drift.Value(center.region),
        latitude: drift.Value(center.latitude),
        longitude: drift.Value(center.longitude),
        address: drift.Value(center.address),
        assignedRepId: drift.Value(center.assignedRepId),
        status: drift.Value(center.status),
        rejectionReason: drift.Value(center.rejectionReason),
        createdAt: center.createdAt,
        updatedAt: center.updatedAt,
        brandId: drift.Value(center.brandId),
      ));
      return center;
    } catch (e) {
      print('CenterRepository: getCenterById remote fallback failed ($e)');
      return null;
    }
  }

  Future<CenterModel?> createCenter(CenterModel center) async {
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
      final newCenter = CenterModel.fromJson(response.data);
      
      // Save locally
      await _localDb.into(_localDb.localCenters).insert(
        LocalCentersCompanion.insert(
          id: newCenter.id,
          name: newCenter.name,
          region: drift.Value(newCenter.region),
          latitude: drift.Value(newCenter.latitude),
          longitude: drift.Value(newCenter.longitude),
          address: drift.Value(newCenter.address),
          assignedRepId: drift.Value(newCenter.assignedRepId),
          status: drift.Value(newCenter.status),
          createdAt: newCenter.createdAt,
          updatedAt: newCenter.updatedAt,
          brandId: drift.Value(newCenter.brandId),
        ),
        mode: drift.InsertMode.insertOrReplace,
      );
      return newCenter;
    } catch (e) {
      print('Error creating center: $e');
      return null;
    }
  }

  Future<void> createLocalCenter(CenterModel center) async {
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
        synced: const drift.Value(false),
      ),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  Future<void> updateCenter(String id, Map<String, dynamic> data) async {
    try {
      await _api.dio.put('/centers/$id', data: data);
      
      // Update local if we know the new values
      // A full sync will eventually fetch it, but we can do a partial update here.
      if (data.containsKey('name')) {
        await (_localDb.update(_localDb.localCenters)..where((t) => t.id.equals(id))).write(
          LocalCentersCompanion(
            name: drift.Value(data['name']),
            region: data.containsKey('region') ? drift.Value(data['region']) : const drift.Value.absent(),
            assignedRepId: data.containsKey('assigned_rep_id') ? drift.Value(data['assigned_rep_id']) : const drift.Value.absent(),
          ),
        );
      }
    } catch (e) {
      print('Error updating center: $e');
      rethrow;
    }
  }

  Future<void> deleteCenter(String id) async {
    try {
      await _api.dio.delete('/centers/$id');
      // Delete locally
      await (_localDb.delete(_localDb.localCenters)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      print('Error deleting center: $e');
      rethrow;
    }
  }
}
