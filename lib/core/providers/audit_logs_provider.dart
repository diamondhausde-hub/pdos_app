import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_log_model.dart';
import '../services/api_service.dart';

class AuditLogsNotifier extends Notifier<AsyncValue<List<ActivityLogModel>>> {
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 30;

  bool get hasMore => _hasMore;

  @override
  AsyncValue<List<ActivityLogModel>> build() {
    _offset = 0;
    _hasMore = true;
    _fetchInitial();
    return const AsyncValue.loading();
  }

  Future<void> _fetchInitial() async {
    try {
      final logs = await _fetchLogs();
      state = AsyncValue.data(logs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<ActivityLogModel>> _fetchLogs() async {
    final response = await ApiService.instance.dio.get('/audit-logs', queryParameters: {
      'limit': _limit,
      'offset': _offset,
    });

    final List<dynamic> data = response.data;
    final newLogs = data.map((json) => ActivityLogModel.fromJson(json)).toList();

    if (newLogs.length < _limit) {
      _hasMore = false;
    }
    _offset += newLogs.length;

    return newLogs;
  }

  Future<void> loadLogs({bool isRefresh = false}) async {
    if (state.isLoading || state.isReloading) return;
    if (!isRefresh && !_hasMore) return;

    if (isRefresh) {
      _offset = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
      try {
        final logs = await _fetchLogs();
        state = AsyncValue.data(logs);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    } else {
      final currentLogs = state.value ?? [];
      try {
        final moreLogs = await _fetchLogs();
        state = AsyncValue.data([...currentLogs, ...moreLogs]);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

final auditLogsProvider = NotifierProvider<AuditLogsNotifier, AsyncValue<List<ActivityLogModel>>>(
  AuditLogsNotifier.new,
);
