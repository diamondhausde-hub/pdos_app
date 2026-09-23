// ignore_for_file: avoid_print
import '../services/api_service.dart';
import '../models/notification_model.dart';
import '../local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;

class NotificationRepository {
  final ApiService _api = ApiService.instance;
  final AppDatabase _db;

  NotificationRepository(this._db);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _api.dio.get('/notifications');
      final notifications = (response.data as List).map((e) => NotificationModel.fromJson(e)).toList();
      
      // Upsert to local DB
      for (final n in notifications) {
        await _db.upsertNotification(LocalNotificationsCompanion(
          id: drift.Value(n.id),
          userId: drift.Value(n.userId),
          type: drift.Value(n.type),
          title: drift.Value(n.title),
          message: drift.Value(n.message),
          relatedId: drift.Value(n.relatedId),
          isRead: drift.Value(n.isRead),
          createdAt: drift.Value(n.createdAt),
          synced: const drift.Value(true), // Synced because it came from the server
        ));
      }
      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markAsRead(String id) async {
    // 1. Update locally FIRST (Optimistic offline update)
    await (_db.update(_db.localNotifications)..where((t) => t.id.equals(id)))
        .write(const LocalNotificationsCompanion(
          isRead: drift.Value(true),
          synced: drift.Value(false), // Mark as unsynced
        ));

    // 2. Try updating remote
    try {
      await _api.dio.put('/notifications/$id/read');
      // If success, mark synced
      await _db.markNotificationSynced(id);
    } catch (e) {
      print('Error marking notification as read on server: $e (queued for sync)');
    }
  }

  Future<void> deleteNotification(String id) async {
    // Delete on server FIRST so it doesn't come back on sync
    await _api.dio.delete('/notifications/$id');
    // Only delete locally if server succeeded
    await _db.deleteNotification(id);
  }

  Future<void> deleteAllNotifications() async {
    // Delete all on server first
    await _api.dio.delete('/notifications');
    // Only delete locally if server succeeded
    await _db.deleteAllNotifications();
  }

  Future<void> markAllAsRead(String userId) async {
    // 1. Update locally
    await (_db.update(_db.localNotifications)..where((t) => t.userId.equals(userId)))
        .write(const LocalNotificationsCompanion(
          isRead: drift.Value(true),
          synced: drift.Value(false),
        ));

    // 2. Try remote
    try {
      await _api.dio.put('/notifications/users/$userId/read-all');
      // Mark all as synced
      await (_db.update(_db.localNotifications)..where((t) => t.userId.equals(userId)))
          .write(const LocalNotificationsCompanion(synced: drift.Value(true)));
    } catch (e) {
      print('Error marking all notifications as read on server: $e');
    }
  }
}
