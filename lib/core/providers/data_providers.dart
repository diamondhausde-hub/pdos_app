import '../models/brand_activity_log_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'auth_provider.dart';
import '../services/api_service.dart';
import '../local_db/app_database.dart';
import '../services/sync_service.dart';
import '../services/schedule_sync_service.dart';
import '../services/sync_orchestrator.dart';
import '../repositories/stock_check_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/center_repository.dart';
import '../repositories/target_repository.dart';
import '../repositories/visit_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/analytics_repository.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/coverage_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/rep_note_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/log_repository.dart';
import '../repositories/client_repository.dart';
import '../models/activity_log_model.dart';
import '../models/expense_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/center_model.dart';
import '../models/target_model.dart';
import '../models/visit_model.dart';
import '../models/notification_model.dart';
import '../models/analytics_models.dart';
import '../models/appointment_model.dart';
import '../models/client_model.dart';
import '../models/overview_model.dart';
import '../models/coverage_model.dart';
import '../models/team_directory_model.dart';
import '../models/note_model.dart';
import 'package:drift/drift.dart' as drift;
import '../services/product_sync_service.dart';
import '../services/settings_service.dart';
import '../models/system_setting.dart';
import '../services/notification_service.dart';
import 'brand_provider.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

// --- Core ---

final apiServiceProvider = Provider((ref) => ApiService.instance);

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(apiServiceProvider));
});

final scheduleSyncServiceProvider = Provider<ScheduleSyncService>((ref) {
  return ScheduleSyncService(ref.watch(appDatabaseProvider));
});

final notificationServiceProvider = Provider((ref) => notificationService);

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(appDatabaseProvider), ref);
});

final syncOrchestratorProvider = Provider<SyncOrchestrator>((ref) {
  final orchestrator = SyncOrchestrator(
    ref.watch(scheduleSyncServiceProvider),
    ref.watch(syncServiceProvider),
    ref.watch(productSyncServiceProvider),
    ref.watch(expenseRepositoryProvider),
    isAuthenticated: () =>
        ref.read(authNotifierProvider).status == AuthStateStatus.authenticated,
    getRepId: () {
        final user = ref.read(currentUserProvider);
        if (user == null) return null;
        if (user.role == UserRole.rep) return user.id;
        // Supervisors and GMs should pull all data in their scope, not just their own
        return null;
      },
  );
  orchestrator.startListening();
  ref.onDispose(orchestrator.stopListening);
  return orchestrator;
});

// --- Repositories ---

final userRepositoryProvider = Provider((ref) => UserRepository());
final productRepositoryProvider = Provider((ref) => ProductRepository(ref.watch(appDatabaseProvider)));
final centerRepositoryProvider = Provider((ref) => CenterRepository(ref.watch(appDatabaseProvider)));
final targetRepositoryProvider = Provider((ref) => TargetRepository());
final appointmentRepositoryProvider = Provider((ref) => AppointmentRepository(ref.watch(appDatabaseProvider), ref.watch(apiServiceProvider)));
final clientRepositoryProvider = Provider((ref) => ClientRepository(ref.watch(appDatabaseProvider)));
final repNoteRepositoryProvider = Provider((ref) => RepNoteRepository(ref.watch(apiServiceProvider)));
final profileRepositoryProvider = Provider((ref) => ProfileRepository(ref.watch(apiServiceProvider)));
final visitRepositoryProvider = Provider((ref) => VisitRepository(ref.watch(appDatabaseProvider), ref.watch(syncOrchestratorProvider)));
final stockCheckRepositoryProvider = Provider((ref) => StockCheckRepository(ref.watch(appDatabaseProvider), ref.watch(syncOrchestratorProvider)));
final notificationRepositoryProvider = Provider((ref) => NotificationRepository(ref.watch(appDatabaseProvider)));
final analyticsRepositoryProvider = Provider((ref) => AnalyticsRepository());
final coverageRepositoryProvider = Provider((ref) => CoverageRepository(ref.watch(apiServiceProvider)));
final expenseRepositoryProvider = Provider((ref) => ExpenseRepository(
  ref.watch(apiServiceProvider),
  ref.watch(appDatabaseProvider),
  () => ref.read(currentUserProvider)?.id,
));

final logRepositoryProvider = Provider((ref) => LogRepository(ref.watch(apiServiceProvider)));

final taskRepositoryProvider = Provider((ref) => TaskRepository(ref.watch(apiServiceProvider)));


final tasksProvider = FutureProvider.autoDispose<List<SupervisorTask>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  return ref.watch(taskRepositoryProvider).getTasks(brandId: brandId);
});

final myTasksProvider = FutureProvider.autoDispose<List<SupervisorTask>>((ref) async {
  return ref.watch(taskRepositoryProvider).getTasks();
});

/// Tasks assigned to the current rep (for My Day tab)
final repTasksProvider = FutureProvider.autoDispose<List<SupervisorTask>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.rep) return [];
  return ref.watch(taskRepositoryProvider).getTasks(repId: user.id);
});

final taskHistoryProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, taskId) async {
  return ref.watch(taskRepositoryProvider).getTaskHistory(taskId);
});


final notesProvider = FutureProvider.autoDispose.family<List<NoteModel>, String?>((ref, userId) {
  return ref.watch(repNoteRepositoryProvider).getNotes(userId: userId);
});

final centerNotesProvider = FutureProvider.autoDispose.family<List<NoteModel>, String>((ref, centerId) {
  return ref.watch(repNoteRepositoryProvider).getNotes(visitCenterId: centerId, limit: 20);
});

final visitNotesProvider = FutureProvider.autoDispose.family<List<NoteModel>, String>((ref, visitId) {
  return ref.watch(repNoteRepositoryProvider).getNotes(visitId: visitId, limit: 20);
});

final logsProvider = FutureProvider.autoDispose.family<List<ActivityLogModel>, String?>((ref, brandId) {
  return ref.watch(logRepositoryProvider).getLogs(brandId: brandId);
});

// --- WebSocket Provider ---
final webSocketProvider = FutureProvider.family<IOWebSocketChannel?, String>((ref, userId) async {
  final token = await ApiService.instance.storage.read(key: 'jwt_token');
  if (token == null) return null;

  final baseUrl = ApiService.instance.dio.options.baseUrl.replaceFirst('http', 'ws');
  
  final channel = IOWebSocketChannel.connect(
    Uri.parse('$baseUrl/ws/notifications/$userId'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  ref.onDispose(() {
    channel.sink.close();
  });
  
  return channel;
});

// --- Data Streams/Futures ---

final settingsProvider = FutureProvider.autoDispose<List<SystemSettingModel>>((ref) async {
  return ref.watch(settingsServiceProvider).getSettings();
});

final notificationsStreamProvider = StreamProvider<List<NotificationModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
     return const Stream.empty();
  }

  final channelAsync = ref.watch(webSocketProvider(user.id));
  final db = ref.watch(appDatabaseProvider);

  channelAsync.whenData((channel) {
    if (channel != null) {
      final subscription = channel.stream.listen((message) {
        if (message == 'refresh_analytics') {
          ref.invalidate(analyticsProvider);
          return;
        }
        try {
          final data = jsonDecode(message);
          final n = NotificationModel.fromJson(data);
          // Upsert into local DB
          db.upsertNotification(LocalNotificationsCompanion(
            id: drift.Value(n.id),
            userId: drift.Value(n.userId),
            type: drift.Value(n.type),
            title: drift.Value(n.title),
            message: drift.Value(n.message),
            relatedId: drift.Value(n.relatedId),
            isRead: drift.Value(n.isRead),
            createdAt: drift.Value(n.createdAt),
            synced: const drift.Value(true),
          ));
        } catch (e) {
          // Ignore
        }
      });
      ref.onDispose(subscription.cancel);
    }
  });

  // Fetch historical to populate local DB on initial load
  ref.read(notificationRepositoryProvider).getNotifications();

  // Return the local reactive stream
  return db.getNotificationsStream(user.id).map((localList) {
    return localList.map((l) => NotificationModel(
      id: l.id,
      userId: l.userId,
      type: l.type,
      title: l.title,
      message: l.message,
      relatedId: l.relatedId,
      isRead: l.isRead,
      createdAt: l.createdAt,
    )).toList();
  });
});

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final repo = ref.read(productRepositoryProvider);
  final all = await repo.getProducts();
  if (brandId == null) return all;
  return all.where((p) => p.brandId == brandId).toList();
});

final usersListProvider = FutureProvider<List<UserModel>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final all = await ref.read(userRepositoryProvider).getUsers();
  if (brandId == null) return all;
  return all.where((u) => u.brandId == brandId || u.brandIds.contains(brandId) || u.role.name == 'general_manager' || u.role.name == 'admin').toList();
});

final myTeamProvider = FutureProvider<List<UserModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final allUsers = await ref.watch(usersListProvider.future);
  if (user.role == UserRole.supervisor) {
    return allUsers.where((u) => u.supervisorId == user.id).toList();
  }
  return allUsers;
});

final teamDirectoryProvider = FutureProvider<List<TeamDirectoryNode>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final repo = ref.watch(userRepositoryProvider);
  return repo.getTeamDirectory(brandId: brandId);
});

final brandSupervisorsProvider = FutureProvider.family<List<UserModel>, String>((ref, brandId) async {
  final api = ref.watch(apiServiceProvider);
  try {
    final resp = await api.dio.get('/users', queryParameters: {'brand_id': brandId, 'role': 'supervisor'});
    final data = resp.data as List;
    return data.map((e) => UserModel.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

final myExpensesProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchMyExpenses();
});

final centersProvider = FutureProvider<List<CenterModel>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final all = await ref.read(centerRepositoryProvider).getCenters();
  if (brandId == null) return all;
  return all.where((c) => c.brandId == brandId).toList();
});

final centerByIdProvider = FutureProvider.family<CenterModel?, String>((ref, centerId) async {
  final center = await ref.read(centerRepositoryProvider).getCenterById(centerId);
  final user = ref.read(currentUserProvider);

  if (user == null) return center;

  // General manager & admin bypass brand isolation
  if (user.role == UserRole.generalManager || user.role == UserRole.admin) {
    return center;
  }

  // All other roles: enforce brand isolation using user's own brandId
  if (center != null && user.brandId != null && center.brandId != user.brandId) {
    throw Exception('Center not accessible — different brand');
  }
  return center;
});

final targetsProvider = FutureProvider<List<TargetModel>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final repo = ref.watch(targetRepositoryProvider);
  return repo.getTargets(brandId: brandId);
});

final flaggedVisitsProvider = FutureProvider<List<VisitModel>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  final repo = ref.watch(visitRepositoryProvider);
  return repo.getVisitsByStatus('flagged', brandId: brandId);
});

final recentVisitsProvider = FutureProvider<List<VisitModel>>((ref) async {
  final repo = ref.watch(visitRepositoryProvider);
  final visits = await repo.getAllVisits();
  return visits..sort((a, b) => b.visitDate.compareTo(a.visitDate));
});

final appointmentsProvider = StreamProvider<List<AppointmentModel>>((ref) {
  final repo = ref.watch(appointmentRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  return repo.watchAppointments(repId: user?.id);
});

final clientsStreamProvider = StreamProvider<List<ClientModel>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return repo.watchClients(brandId: brandId);
});

// --- Analytics ---

final dateRangeProvider = NotifierProvider<DateRangeNotifier, DateTimeRange>(DateRangeNotifier.new);

class DateRangeNotifier extends Notifier<DateTimeRange> {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  void setRange(DateTimeRange range) => state = range;
}

Stream<T> _pollWithLifecycle<T>(Ref ref, Future<T> Function() fetcher) async* {
  // Riverpod 3: a disposed provider's Ref must never be touched again.
  bool isAuthed() {
    if (!ref.mounted) return false;
    return ref.read(authNotifierProvider).status == AuthStateStatus.authenticated;
  }

  if (!isAuthed()) return;
  try {
    yield await fetcher();
  } catch (_) {}

  while (true) {
    await Future.delayed(const Duration(seconds: 20));
    // Stop hammering the API once the session ended OR the provider was
    // rebuilt/disposed while we were waiting.
    if (!ref.mounted || !isAuthed()) break;
    final state = WidgetsBinding.instance.lifecycleState;
    // If running in a test or foregrounded, continue polling
    if (state == null || state == AppLifecycleState.resumed) {
      T value;
      try {
        value = await fetcher();
      } catch (_) {
        continue; // transient failure — keep polling
      }
      if (!ref.mounted) break; // disposed during the fetch
      yield value;
    }
  }
}

final analyticsProvider = StreamProvider<AnalyticsModel>((ref) {
  if (ref.watch(currentUserProvider) == null) return const Stream.empty();
  final dateRange = ref.watch(dateRangeProvider);
  final repo = ref.read(analyticsRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return _pollWithLifecycle(ref, () => repo.getAnalytics(dateRange.start, dateRange.end, brandId: brandId));
});

final compareBrandsAnalyticsProvider = FutureProvider<Map<String, AnalyticsModel?>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.generalManager) return {};
  
  final brands = ref.watch(brandsProvider).asData?.value ?? [];
  if (brands.isEmpty) return {};
  
  final dateRange = ref.watch(dateRangeProvider);
  final repo = ref.read(analyticsRepositoryProvider);
  
  final results = <String, AnalyticsModel?>{};
  
  await Future.wait(brands.map((brand) async {
    try {
      final data = await repo.getAnalytics(dateRange.start, dateRange.end, brandId: brand.id);
      results[brand.name] = data;
    } catch (e) {
      results[brand.name] = null; // Partial failure
    }
  }));
  
  return results;
});

final dailyRevenueProvider = FutureProvider<List<DailyRevenueModel>>((ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final repo = ref.read(analyticsRepositoryProvider);
  return repo.getDailyRevenue(dateRange.start, dateRange.end);
});

final monthlyRevenueProvider = FutureProvider<List<MonthlyRevenueModel>>((ref) {
  final repo = ref.read(analyticsRepositoryProvider);
  final now = DateTime.now();
  return repo.getMonthlyRevenue(now.year);
});

final systemOverviewProvider = StreamProvider<SystemOverviewModel>((ref) {
  if (ref.watch(currentUserProvider) == null) return const Stream.empty();
  final repo = ref.read(analyticsRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return _pollWithLifecycle(ref, () => repo.getSystemOverview(brandId: brandId));
});

final coverageProvider = StreamProvider<List<CoverageCenter>>((ref) {
  if (ref.watch(currentUserProvider) == null) return const Stream.empty();
  final repo = ref.watch(coverageRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return _pollWithLifecycle(ref, () => repo.getCoverage(brandId: brandId));
});

final teamLocationsProvider = StreamProvider<List<UserModel>>((ref) {
  if (ref.watch(currentUserProvider) == null) return const Stream.empty();
  final api = ref.watch(apiServiceProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return _pollWithLifecycle(ref, () async {
    final queryParams = brandId != null ? {'brand_id': brandId} : null;
    final res = await api.dio.get('/users/team/locations', queryParameters: queryParams);
    return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
  });
});

final repAppointmentsProvider = StreamProvider.family<List<AppointmentModel>, String>((ref, repId) {
  final repo = ref.watch(appointmentRepositoryProvider);
  return repo.watchAppointments(repId: repId);
});

final repClientsStreamProvider = StreamProvider.family<List<ClientModel>, String>((ref, repId) {
  final repo = ref.watch(clientRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return repo.watchClients(repId: repId, brandId: brandId);
});

final activityLogsProvider = FutureProvider.autoDispose.family<List<BrandActivityLogModel>, Map<String, String?>>((ref, params) async {
  final brandId = params['brandId'];
  final dateFilter = params['dateFilter'];
  return ref.watch(taskRepositoryProvider).getActivityLogs(brandId: brandId, dateFilter: dateFilter);
});
