// ignore_for_file: avoid_print
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'schedule_sync_service.dart';
import 'sync_service.dart';
import 'product_sync_service.dart';
import '../repositories/expense_repository.dart';

class SyncOrchestrator {
  final ScheduleSyncService scheduleSyncService;
  final SyncService syncService;
  final ProductSyncService productSyncService;
  final ExpenseRepository expenseRepository;

  /// Returns true while a valid session exists. When false, all sync work
  /// is skipped (prevents 401 storms after logout/token expiry).
  final bool Function() isAuthenticated;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _pollingTimer;
  bool _isSyncing = false;

  int _retryCount = 0;
  static const int _maxRetries = 5;

  SyncOrchestrator(
    this.scheduleSyncService,
    this.syncService,
    this.productSyncService,
    this.expenseRepository, {
    bool Function()? isAuthenticated,
    String? Function()? getRepId,
  }) : isAuthenticated = isAuthenticated ?? (() => true),
       _getRepId = getRepId ?? (() => null);

  final String? Function() _getRepId;
  String? get _currentRepId => _getRepId();

  void startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (!isAuthenticated()) return;
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        _retryCount = 0;
        syncAllInOrder(repId: _currentRepId);
      }
    });
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isAuthenticated()) return;
      syncAllInOrder(repId: _currentRepId);
    });
  }

  void stopListening() {
    _connectivitySubscription?.cancel();
    _pollingTimer?.cancel();
  }

  Future<void> syncAllInOrder({String? repId}) async {
    if (_isSyncing) return;
    if (!isAuthenticated()) return; // never sync without a live session
    _isSyncing = true;
    try {
      final results = await _connectivity.checkConnectivity();
      if (!results.contains(ConnectivityResult.mobile) && !results.contains(ConnectivityResult.wifi)) return;

      await scheduleSyncService.pushCenters();
      await scheduleSyncService.pushClients();
      if (repId != null) {
        await scheduleSyncService.pushSignature(repId);
      }
      await scheduleSyncService.pushAppointments();
      await syncService.syncNow();
      await scheduleSyncService.pullCenters();
      await scheduleSyncService.pullClients(repId: repId);
      await scheduleSyncService.pullAppointments(repId: repId);
      await scheduleSyncService.pullVisits(repId: repId);  // ← NEW: pull visits from server
      await productSyncService.pullProducts();
      // Pull expense status updates (approved/rejected) from server
      await expenseRepository.syncExpensesFromServer();
      if (repId != null) {
        await scheduleSyncService.pullSignature(repId);
      }

      _retryCount = 0;
    } catch (e) {
      print('SyncOrchestrator: error - $e');
      // Retry only transient failures — a dead session will never recover
      // by retrying, and would just generate more 401s.
      if (_retryCount < _maxRetries) {
        _retryCount++;
        final delay = Duration(seconds: _retryCount * _retryCount * 10);
        print('SyncOrchestrator: retrying in ${delay.inSeconds}s (attempt $_retryCount/$_maxRetries)');
        Timer(delay, () => syncAllInOrder(repId: repId));
      }
    } finally {
      _isSyncing = false;
    }
  }
}
