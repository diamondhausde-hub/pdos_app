// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../local_db/app_database.dart';
import '../models/client_model.dart';
import 'api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SyncService {
  final AppDatabase localDb;
  final Ref ref;
  // Reuse the shared Dio (JWT injection + 401 session-clearing interceptor)
  // instead of a private client with divergent auth behavior.
  late Dio _dio;

  SyncService(this.localDb, this.ref) {
    _dio = ApiService.instance.dio;
  }

  Future<void> _handleError(
    dynamic e,
    Future<void> Function(String) updateError,
  ) async {
    String errMsg = 'Unexpected error, please try again later';
    if (e is DioException) {
      if (e.response?.statusCode == 401) {
        errMsg = 'Session expired, please sign in again';
        ref.read(authNotifierProvider.notifier).logout();
      } else if (e.response == null &&
          (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout)) {
        errMsg = 'No internet connection';
      } else if (e.response?.statusCode != null) {
        errMsg =
            'HTTP ${e.response!.statusCode}: ${e.response?.data ?? e.message ?? 'Request failed'}';
      } else {
        errMsg =
            e.response?.data?.toString() ?? e.message ?? 'Connection error';
      }
    } else {
      errMsg = e.toString();
    }
    updateError(errMsg);
  }

  Future<void> abandonItem(String type, String id, String repId) async {
    try {
      if (type == 'visit') {
        await localDb.markVisitAbandoned(id);
      } else if (type == 'expense') {
        await localDb.markExpenseAbandoned(id);
      } else if (type == 'photo') {
        await localDb.markPhotoAbandoned(id);
      } else if (type == 'stock_check') {
        await localDb.markStockCheckAbandoned(id);
      } else if (type == 'center') {
        await localDb.markCenterAbandoned(id);
      } else if (type == 'appointment') {
        await localDb.markAppointmentAbandoned(id);
      }

      final payload = {'type': type, 'id': id};
      await _dio.post('/sync/abandon', data: payload);
    } catch (e) {
      print('Failed to abandon item: $e');
    }
  }

  Future<void> syncNow() async {
    try {
      // 1. Sync Visits & Visit Items (Nested)
      final unsyncedVisits = await localDb.getUnsyncedVisits();
      for (final v in unsyncedVisits) {
        try {
          // Gather items for this visit
          final items = await localDb.getVisitItemsForVisit(v.id);
          final specialReqs = await (localDb.select(
            localDb.localSpecialRequests,
          )..where((t) => t.visitId.equals(v.id))).get();

          final payload = {
            'id': v.id,
            'rep_id': v.repId,
            'center_id': v.centerId,
            'client_id': v.clientId,
            'visit_date': v.visitDate.toIso8601String(),
            'arrival_time': v.arrivalTime?.toIso8601String(),
            'completion_time': v.completionTime?.toIso8601String(),
            'status': v.status,
            'notes': v.notes,
            'latitude': v.latitude,
            'longitude': v.longitude,
            'appointment_id': v.appointmentId,
            'task_id': v.taskId,
            'visit_type': v.visitType,
            'visit_reason': v.visitReason,
            if (v.interestedProductIds != null)
              'interested_product_ids': v.interestedProductIds!
                  .split(',')
                  .where((s) => s.trim().isNotEmpty)
                  .toList(),
            'items': items
                .map(
                  (i) => {
                    'product_id': i.productId,
                    'qty_sold': i.qtySold,
                    'qty_free': i.qtyFree,
                    'price_at_sale': i.priceAtSale,
                  },
                )
                .toList(),
            'special_requests': specialReqs
                .map(
                  (sr) => {
                    'id': sr.id,
                    'request_type': sr.requestType,
                    'description': sr.description,
                  },
                )
                .toList(),
          };

          final response = await _dio.post('/visits', data: payload);
          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            final signatureUrl = response.data['signature_url'] as String?;
            if (signatureUrl != null && v.signaturePath != null) {
              await localDb
                  .update(localDb.localVisits)
                  .replace(v.copyWith(signatureUrl: Value(signatureUrl)));
            }
            if (v.signaturePath != null) {
              final sigFile = File(v.signaturePath!);
              if (await sigFile.exists()) {
                try {
                  final sigFormData = FormData.fromMap({
                    'file': await MultipartFile.fromFile(sigFile.path),
                  });
                  await _dio.post(
                    '/visits/${v.id}/signature',
                    data: sigFormData,
                  );
                  await sigFile.delete();
                } catch (sigErr) {
                  print('Failed to sync signature for visit ${v.id}: $sigErr');
                }
              }
            }
            await localDb
                .update(localDb.localVisits)
                .replace(
                  v.copyWith(synced: true, syncError: const Value(null)),
                );
            for (final i in items) {
              await localDb
                  .update(localDb.localVisitItems)
                  .replace(
                    i.copyWith(synced: true, syncError: const Value(null)),
                  );
            }
            for (final sr in specialReqs) {
              await localDb
                  .update(localDb.localSpecialRequests)
                  .replace(
                    sr.copyWith(synced: true, syncError: const Value(null)),
                  );
            }
          } else {
            print('Failed to sync visit ${v.id}: HTTP ${response.statusCode}');
            await localDb
                .update(localDb.localVisits)
                .replace(
                  v.copyWith(syncError: Value('HTTP ${response.statusCode}')),
                );
          }
        } catch (e) {
          print('Error syncing visit ${v.id}: $e');
          await _handleError(e, (msg) async {
            await localDb
                .update(localDb.localVisits)
                .replace(v.copyWith(syncError: Value(msg)));
          });
        }
      }

      // 2. Sync Pharmacy Stock Checks
      final unsyncedChecks = await localDb.getUnsyncedStockChecks();
      if (unsyncedChecks.isNotEmpty) {
        try {
          final payload = unsyncedChecks
              .map(
                (c) => {
                  'visit_id': c.visitId,
                  'product_id': c.productId,
                  'observed_qty': c.observedQty,
                },
              )
              .toList();

          final response = await _dio.post('/stock-checks', data: payload);
          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            for (final c in unsyncedChecks) {
              await localDb
                  .update(localDb.localPharmacyStockChecks)
                  .replace(
                    c.copyWith(synced: true, syncError: const Value(null)),
                  );
            }
          } else {
            print('Failed to sync stock checks: HTTP ${response.statusCode}');
          }
        } catch (e) {
          print('Error syncing stock checks: $e');
          await _handleError(e, (msg) async {
            for (final c in unsyncedChecks) {
              await localDb
                  .update(localDb.localPharmacyStockChecks)
                  .replace(c.copyWith(syncError: Value(msg)));
            }
          });
        }
      }
      // 3. Sync Notification Read Statuses
      final unsyncedNotifs = await localDb.getUnsyncedNotifications();
      for (final n in unsyncedNotifs) {
        if (n.isRead) {
          try {
            final response = await _dio.put('/notifications/${n.id}/read');
            if (response.statusCode != null &&
                response.statusCode! >= 200 &&
                response.statusCode! < 300) {
              await localDb.markNotificationSynced(
                n.id,
              ); // Also clears error if implemented
            }
          } catch (e) {
            print('Failed to sync notification read status ${n.id}: $e');
            await _handleError(e, (msg) async {
              await (localDb.update(localDb.localNotifications)
                    ..where((t) => t.id.equals(n.id)))
                  .write(LocalNotificationsCompanion(syncError: Value(msg)));
            });
          }
        }
      }

      // 4. Sync Shelf Photos
      final unsyncedPhotos = await localDb.getUnsyncedPhotos();
      for (final p in unsyncedPhotos) {
        try {
          final file = File(p.photoPath);
          if (!await file.exists()) continue; // skip if local file deleted

          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path),
          });

          final response = await _dio.post(
            '/visits/${p.visitId}/photos',
            data: formData,
          );
          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            await localDb.markPhotoSynced(
              p.id,
              uploadedUrl: response.data['photo_url'],
            );
            await (localDb.update(localDb.localVisitPhotos)
                  ..where((t) => t.id.equals(p.id)))
                .write(const LocalVisitPhotosCompanion(syncError: Value(null)));
            // Keep local file as cache for offline viewing in visit details screen
            // The system can have a separate background cleaner job later if space becomes an issue.
          }
        } catch (e) {
          print('Failed to sync photo ${p.id}: $e');
          await _handleError(e, (msg) async {
            await (localDb.update(localDb.localVisitPhotos)
                  ..where((t) => t.id.equals(p.id)))
                .write(LocalVisitPhotosCompanion(syncError: Value(msg)));
          });
        }
      }
      // 4. Sync Field Reports
      final unsyncedReports = await localDb.getUnsyncedFieldReports();
      for (final r in unsyncedReports) {
        try {
          String? photoUrl;
          if (r.photoPath != null && !r.photoPath!.startsWith('http')) {
            final file = File(r.photoPath!);
            if (await file.exists()) {
              final form = FormData.fromMap({
                'file': await MultipartFile.fromFile(
                  file.path,
                  filename: 'report_photo.jpg',
                ),
              });
              final uploadRes = await _dio.post(
                '/field-reports/${r.id}/photo',
                data: form,
              );
              if (uploadRes.statusCode != null &&
                  uploadRes.statusCode! >= 200 &&
                  uploadRes.statusCode! < 300) {
                photoUrl = uploadRes.data['photo_url'] as String?;
              }
            }
          } else if (r.photoPath != null) {
            photoUrl = r.photoPath;
          }

          final payload = {
            'id': r.id,
            'rep_id': r.repId,
            'content': r.content,
            'photo_url': photoUrl,
          };

          final response = await _dio.post('/field-reports', data: payload);
          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            await localDb.markFieldReportSynced(r.id);
            await (localDb.update(
              localDb.localFieldReports,
            )..where((t) => t.id.equals(r.id))).write(
              const LocalFieldReportsCompanion(syncError: Value(null)),
            );
          }
        } catch (e) {
          print('Failed to sync field report ${r.id}: $e');
          await _handleError(e, (msg) async {
            await (localDb.update(localDb.localFieldReports)
                  ..where((t) => t.id.equals(r.id)))
                .write(LocalFieldReportsCompanion(syncError: Value(msg)));
          });
        }
      }

      // 5. Sync Expenses
      final unsyncedExpenses = await localDb.getUnsyncedExpenses();
      for (final e in unsyncedExpenses) {
        try {
          final payload = {
            'id': e.id,
            'visit_id': e.visitId,
            'category': e.category,
            'amount': e.amount,
            'description': e.description,
          };

          final response = await _dio.post('/expenses', data: payload);
          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            final serverExpenseId = response.data['id'];

            // Then upload the receipt if it exists
            if (e.receiptImagePath != null) {
              final file = File(e.receiptImagePath!);
              if (await file.exists()) {
                final formData = FormData.fromMap({
                  'file': await MultipartFile.fromFile(file.path),
                });
                final receiptResponse = await _dio.post(
                  '/expenses/$serverExpenseId/receipt',
                  data: formData,
                );
                if (receiptResponse.statusCode != null &&
                    receiptResponse.statusCode! >= 200 &&
                    receiptResponse.statusCode! < 300) {
                  await localDb.markExpenseSynced(
                    e.id,
                    uploadedUrl: receiptResponse.data['receipt_image_url'],
                  );
                  await file.delete();
                  continue;
                }
                continue;
              }
            }

            await localDb.markExpenseSynced(e.id);
          }
        } catch (err) {
          print('Failed to sync expense ${e.id}: $err');
          await _handleError(err, (msg) async {
            await (localDb.update(localDb.localExpenses)
                  ..where((t) => t.id.equals(e.id)))
                .write(LocalExpensesCompanion(syncError: Value(msg)));
          });
        }
      }

      // 6. Sync Clients
      final unsyncedClients = await localDb.getUnsyncedClients();
      for (final c in unsyncedClients) {
        try {
          final clientModel = ClientModel.fromLocal(c);

          // Reverted to unified /clients endpoint as backend is not yet split
          final response = await _dio.post(
            '/clients',
            data: clientModel.toJson(),
          );

          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            await localDb
                .update(localDb.localClients)
                .replace(
                  c.copyWith(synced: true, syncError: const Value(null)),
                );
          } else {
            await localDb
                .update(localDb.localClients)
                .replace(
                  c.copyWith(syncError: Value('HTTP ${response.statusCode}')),
                );
          }
        } catch (e) {
          print('Failed to sync client ${c.id}: $e');
          await _handleError(e, (msg) async {
            await localDb
                .update(localDb.localClients)
                .replace(c.copyWith(syncError: Value(msg)));
          });
        }
      }
    } catch (e) {
      print('SyncService error: $e');
    }
  }
}
