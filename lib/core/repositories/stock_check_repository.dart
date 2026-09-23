import '../local_db/app_database.dart';
import '../services/sync_orchestrator.dart';
import 'package:uuid/uuid.dart';

class StockCheckRepository {
  final AppDatabase _localDb;
  final SyncOrchestrator _syncOrchestrator;
  final _uuid = const Uuid();

  StockCheckRepository(this._localDb, this._syncOrchestrator);

  Future<void> recordStockCheck({
    required String visitId,
    required String productId,
    required int observedQty,
  }) async {
    final companion = LocalPharmacyStockCheck(
      id: _uuid.v4(),
      visitId: visitId,
      productId: productId,
      observedQty: observedQty,
      synced: false,
      createdAt: DateTime.now(),
      isAbandoned: false,
    );
    
    await _localDb.into(_localDb.localPharmacyStockChecks).insert(companion);
    // Attempt to sync immediately if online
    await _syncOrchestrator.syncAllInOrder();
  }
}
