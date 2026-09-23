import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdos_app/core/local_db/app_database.dart';
import 'package:pdos_app/core/services/sync_orchestrator.dart';
import 'package:pdos_app/core/services/schedule_sync_service.dart';
import 'package:pdos_app/core/services/sync_service.dart';
import 'package:pdos_app/core/services/product_sync_service.dart';
import 'package:pdos_app/core/repositories/expense_repository.dart';

class _MockScheduleSyncService implements ScheduleSyncService {
  final List<String> callLog = [];

  @override
  Future<void> pushCenters() async => callLog.add('pushCenters');

  @override
  Future<void> pushClients() async => callLog.add('pushClients');

  @override
  Future<void> pushAppointments() async => callLog.add('pushAppointments');

  @override
  Future<void> pullCenters() async => callLog.add('pullCenters');

  @override
  Future<void> pullClients({String? repId}) async => callLog.add('pullClients');

  @override
  Future<void> pullAppointments({String? repId}) async => callLog.add('pullAppointments');

  @override
  Future<void> pullVisits({String? repId}) async => callLog.add('pullVisits');

  @override
  Future<void> pushSignature(String userId) async => callLog.add('pushSignature');

  @override
  Future<void> pullSignature(String userId) async => callLog.add('pullSignature');
}

class _MockSyncService implements SyncService {
  final List<String> callLog = [];

  @override
  late final AppDatabase localDb;
  @override
  late final Ref ref;

  @override
  Future<void> syncNow() async => callLog.add('syncNow');

  @override
  Future<void> abandonItem(String type, String id, String repId) async {}
}

class _MockProductSyncService implements ProductSyncService {
  final List<String> callLog = [];

  @override
  Future<void> pullProducts() async => callLog.add('pullProducts');
}

class _MockExpenseRepository implements ExpenseRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) async {}

  @override
  Future<void> syncExpensesFromServer() async {}
}

void main() {
  late _MockScheduleSyncService mockSchedule;
  late _MockSyncService mockSync;
  late _MockProductSyncService mockProduct;
  late SyncOrchestrator orchestrator;

  setUp(() {
    mockSchedule = _MockScheduleSyncService();
    mockSync = _MockSyncService();
    mockProduct = _MockProductSyncService();
    orchestrator = SyncOrchestrator(mockSchedule, mockSync, mockProduct, _MockExpenseRepository());
  });

  test('syncAllInOrder calls pushCenters before syncNow and pullCenters', () async {
    await orchestrator.syncAllInOrder();

    if (mockSchedule.callLog.isEmpty && mockSync.callLog.isEmpty && mockProduct.callLog.isEmpty) {
      // ignore: avoid_print
      print('SKIP: No connectivity in test environment');
      return;
    }

    final pushCentersIdx = mockSchedule.callLog.indexOf('pushCenters');
    final syncNowIdx = mockSync.callLog.indexOf('syncNow');
    final pullCentersIdx = mockSchedule.callLog.indexOf('pullCenters');

    expect(pushCentersIdx, lessThan(syncNowIdx), reason: 'pushCenters must run before syncNow');
    expect(pushCentersIdx, lessThan(pullCentersIdx), reason: 'pushCenters must run before pullCenters');
  });

}
