import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/expense_model.dart';
import '../services/api_service.dart';
import '../local_db/app_database.dart';

class ExpenseRepository {
  final ApiService _api;
  final AppDatabase _db;
  final String? Function() _getCurrentUserId;

  ExpenseRepository(this._api, this._db, this._getCurrentUserId);

  Stream<List<ExpenseModel>> watchMyExpenses() {
    final userId = _getCurrentUserId();
    if (userId == null) return Stream.value([]);
    
    return (_db.select(_db.localExpenses)
      ..where((t) => t.repId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .watch()
      .map((rows) => rows.map((r) => ExpenseModel(
        id: r.id,
        visitId: r.visitId,
        repId: r.repId,
        category: r.category,
        amount: r.amount,
        description: r.description,
        receiptImageUrl: r.uploadedUrl,
        status: r.status,
        rejectionReason: r.rejectionReason,
        createdAt: r.createdAt,
      )).toList());
  }

  Future<void> syncExpensesFromServer() async {
    try {
      final response = await _api.dio.get('/expenses/my');
      final serverExpenses = (response.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
      
      for (final e in serverExpenses) {
        await _db.into(_db.localExpenses).insertOnConflictUpdate(LocalExpensesCompanion(
          id: Value(e.id),
          visitId: Value(e.visitId ?? ''),
          repId: Value(e.repId),
          category: Value(e.category),
          amount: Value(e.amount),
          description: Value(e.description),
          uploadedUrl: Value(e.receiptImageUrl),
          status: Value(e.status),
          rejectionReason: Value(e.rejectionReason),
          synced: const Value(true),
          createdAt: Value(e.createdAt),
        ));
      }
    } catch (e) {
      debugPrint('Failed to sync expenses: $e');
    }
  }

  Future<void> createExpenseLocally({
    required String visitId,
    required String category,
    required double amount,
    String? description,
    String? receiptImagePath,
  }) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;
    
    final id = const Uuid().v4();
    await _db.into(_db.localExpenses).insert(LocalExpensesCompanion(
      id: Value(id),
      visitId: Value(visitId),
      repId: Value(userId),
      category: Value(category),
      amount: Value(amount),
      description: Value(description),
      receiptImagePath: Value(receiptImagePath),
      status: const Value('pending'),
      synced: const Value(false),
      createdAt: Value(DateTime.now()),
    ));
  }
}

