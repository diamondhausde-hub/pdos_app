import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_db/app_database.dart';
import '../providers/data_providers.dart';

class SyncStatusService {
  final AppDatabase _localDb;

  SyncStatusService(this._localDb);

  Future<int> getPendingCount() async {
    final items = await getPendingItems();
    return items.length;
  }

  Future<List<SyncItem>> getPendingItems() async {
    final List<SyncItem> items = [];
    
    try {
      final visits = await _localDb.getUnsyncedVisits();
      for (final v in visits) {
        items.add(SyncItem(
          id: v.id,
          type: 'visit',
          title: 'Unsynced center visit',
          error: v.syncError,
        ));
      }

      final checks = await _localDb.getUnsyncedStockChecks();
      for (final c in checks) {
        items.add(SyncItem(
          id: c.id,
          type: 'stock_check',
          title: 'Pharmacy stock check',
          error: c.syncError,
        ));
      }

      final centers = await _localDb.getUnsyncedCenters();
      for (final c in centers) {
        items.add(SyncItem(
          id: c.id,
          type: 'center',
          title: 'Center: ${c.name}',
          error: c.syncError,
        ));
      }

      final appointments = await _localDb.getUnsyncedAppointments();
      for (final a in appointments) {
        items.add(SyncItem(
          id: a.id,
          type: 'appointment',
          title: 'Appointment: ${a.apptTime}',
          error: a.syncError,
        ));
      }

      final photos = await _localDb.getUnsyncedPhotos();
      for (final p in photos) {
        items.add(SyncItem(
          id: p.id,
          type: 'photo',
          title: 'Shelf photo',
          error: p.syncError,
        ));
      }
      
      final expenses = await _localDb.getUnsyncedExpenses();
      for (final e in expenses) {
        items.add(SyncItem(
          id: e.id,
          type: 'expense',
          title: 'Expense: ${e.category}',
          error: e.syncError,
        ));
      }

      final fieldReports = await _localDb.getUnsyncedFieldReports();
      for (final r in fieldReports) {
        items.add(SyncItem(
          id: r.id,
          type: 'field_report',
          title: 'Field report',
          error: r.syncError,
        ));
      }

      final clients = await _localDb.getUnsyncedClients();
      for (final c in clients) {
        items.add(SyncItem(
          id: c.id,
          type: 'client',
          title: 'Client: ${c.doctorName ?? c.facilityName ?? c.id}',
          error: c.syncError,
        ));
      }

    } catch (e) {
      // Ignored
    }
    return items;
  }

  Future<bool> hasPendingSync() async {
    return (await getPendingCount()) > 0;
  }
}

final syncStatusServiceProvider = Provider<SyncStatusService>((ref) {
  return SyncStatusService(ref.watch(appDatabaseProvider));
});

final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(syncStatusServiceProvider).getPendingCount();
});

final pendingSyncItemsProvider = FutureProvider<List<SyncItem>>((ref) async {
  return ref.watch(syncStatusServiceProvider).getPendingItems();
});

class SyncItem {
  final String id;
  final String type;
  final String title;
  final String? error;

  SyncItem({
    required this.id,
    required this.type,
    required this.title,
    this.error,
  });
}
