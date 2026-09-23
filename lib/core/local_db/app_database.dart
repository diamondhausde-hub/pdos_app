// ignore_for_file: avoid_print
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// --- Local Tables matching Supabase ---

@DataClassName('LocalVisit')
class LocalVisits extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get referenceCode => text().nullable()();
  TextColumn get repId => text()();
  TextColumn get brandId => text().nullable()();
  TextColumn get centerId => text()();
  TextColumn get appointmentId => text().nullable()();
  DateTimeColumn get visitDate => dateTime()();
  DateTimeColumn get arrivalTime => dateTime().nullable()();
  DateTimeColumn get completionTime => dateTime().nullable()();
  TextColumn get status => text()(); // 'planned', 'arrived', 'completed'
  TextColumn get notes => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get isFlagged => boolean().withDefault(const Constant(false))();
  TextColumn get supervisorNote => text().nullable()();
  TextColumn get signaturePath => text().nullable()();
  TextColumn get signatureUrl => text().nullable()();
  TextColumn get retroactiveReason => text().nullable()();
  RealColumn get saveLocationLat => real().nullable()();
  RealColumn get saveLocationLng => real().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();
  // Doctor-visit flow
  TextColumn get clientId => text().nullable()();
  TextColumn get visitType => text().withDefault(const Constant('center'))(); // 'center' | 'doctor'
  TextColumn get visitReason => text().nullable()();
  TextColumn get interestedProductIds => text().nullable()(); // comma-separated product ids
  TextColumn get taskId => text().nullable()();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalVisitItem')
class LocalVisitItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get visitId => text().nullable()();
  TextColumn get productId => text()();
  IntColumn get qtySold => integer().withDefault(const Constant(0))();
  IntColumn get qtyFree => integer().withDefault(const Constant(0))();
  RealColumn get priceAtSale => real().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalPharmacyStockCheck')
class LocalPharmacyStockChecks extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get visitId => text().nullable()();
  TextColumn get productId => text().nullable()();
  TextColumn get competitorProductName => text().nullable()();
  IntColumn get observedQty => integer().withDefault(const Constant(0))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalCenter')
class LocalCenters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get region => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get assignedRepId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get rejectionReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  TextColumn get brandId => text().nullable()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalAppointment')
class LocalAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get referenceCode => text().nullable()();
  TextColumn get repId => text()();
  TextColumn get brandId => text().nullable()();
  TextColumn get clientId => text().nullable()();
  TextColumn get centerId => text().nullable()();
  TextColumn get centerName => text().nullable()(); // Cached joined field
  DateTimeColumn get apptDate => dateTime()();
  TextColumn get apptTime => text()();
  IntColumn get reminderMinutesBefore => integer().withDefault(const Constant(30))();
  TextColumn get notes => text().nullable()();
  TextColumn get suggestedProductId => text().nullable()();
  TextColumn get suggestedProductName => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get supervisorNote => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(true))(); // By default, fetched ones are synced
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalNotification')
class LocalNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get message => text().nullable()();
  TextColumn get relatedId => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  
  // Track offline read status syncing
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();
 

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProduct')
class LocalProducts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  RealColumn get unitPrice => real().nullable()();
  // stockQty is a cached snapshot, source of truth is server-side.
  IntColumn get stockQty => integer().withDefault(const Constant(0))();
  BoolColumn get isLowStock => boolean().withDefault(const Constant(false))();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get barcode => text().nullable()();
  TextColumn get brandId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalVisitPhoto')
class LocalVisitPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get visitId => text().nullable()();
  TextColumn get photoPath => text()();
  TextColumn get uploadedUrl => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalFieldReport')
class LocalFieldReports extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get repId => text()();
  TextColumn get brandId => text().nullable()();
  TextColumn get content => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get uploadedUrl => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalExpense')
class LocalExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get visitId => text().nullable()();
  TextColumn get repId => text()();
  TextColumn get brandId => text().nullable()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  TextColumn get receiptImagePath => text().nullable()();
  TextColumn get uploadedUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get rejectionReason => text().nullable()();
  BoolColumn get requiresAdminApproval => boolean().withDefault(const Constant(false))();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  TextColumn get repName => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}


@DataClassName('LocalSpecialRequest')
class LocalSpecialRequests extends Table {
  TextColumn get id => text()();
  TextColumn get visitId => text().nullable()();
  TextColumn get requestType => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalClient')
class LocalClients extends Table {
  TextColumn get id => text()();
  TextColumn get clientType => text().withDefault(const Constant('doctor'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get repId => text()();
  TextColumn get brandId => text().nullable()();
  TextColumn get facilityName => text().nullable()();
  TextColumn get facilityType => text().nullable()();
  TextColumn get doctorName => text().nullable()();
  TextColumn get specialty => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get classTier => text().nullable()();
  TextColumn get relationshipType => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get area => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get nearbyLandmark => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  TextColumn get syncError => text().nullable()();
  BoolColumn get isAbandoned => boolean().withDefault(const Constant(false))();
  // Doctor profiling (doctor-visit flow)
  TextColumn get gender => text().nullable()();            // 'male' | 'female'
  IntColumn get rating => integer().nullable()();          // 1..5 stars
  TextColumn get treatmentQuality => text().nullable()();  // 'good' | 'average' | 'bad'
  TextColumn get scientificInterests => text().nullable()();
  TextColumn get productInterests => text().nullable()();
  TextColumn get pharmacyType => text().nullable()();
  TextColumn get institutionType => text().nullable()();
  TextColumn get keyContactName => text().nullable()();
  TextColumn get keyContactPosition => text().nullable()();
  TextColumn get keyContactPhone => text().nullable()();
  TextColumn get departments => text().nullable()(); // JSON string



  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalUserSignature')
class LocalUserSignatures extends Table {
  TextColumn get id => text()(); // userId
  TextColumn get pointsJson => text()();
  TextColumn get imagePath => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Database Class ---

@DriftDatabase(tables: [
  LocalVisits,
  LocalVisitItems,
  LocalPharmacyStockChecks,
  LocalCenters,
  LocalAppointments,
  LocalNotifications,
  LocalProducts,
  LocalVisitPhotos,
  LocalFieldReports,
  LocalExpenses,
  LocalSpecialRequests,
  LocalClients,
  LocalUserSignatures,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 23;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
           await m.addColumn(localCenters, localCenters.synced);
        }
        if (from < 3) {
           await m.createTable(localVisitPhotos);
        }
        if (from < 5) {
           await m.addColumn(localProducts, localProducts.barcode);
           await m.createTable(localFieldReports);
        }
        if (from < 6) {
           // We tried to create localExpenses here previously
        }
        if (from < 7) {
           // Force create localExpenses if it doesn't exist
           try {
             await m.createTable(localExpenses);
           } catch (e) {
             print('Table localExpenses might already exist: $e');
           }
        }
        if (from < 8) {
           await m.addColumn(localAppointments, localAppointments.suggestedProductId);
           await m.addColumn(localAppointments, localAppointments.suggestedProductName);
        }
        if (from < 9) {
           await m.addColumn(localVisits, localVisits.signaturePath);
        }
        if (from < 10) {
           await m.addColumn(localCenters, localCenters.status);
           await m.addColumn(localCenters, localCenters.rejectionReason);
         }
         if (from < 11) {
           await m.addColumn(localVisits, localVisits.signatureUrl);
         }
         if (from < 12) {
           await m.createTable(localSpecialRequests);
           await m.addColumn(localPharmacyStockChecks, localPharmacyStockChecks.competitorProductName);
           await m.addColumn(localAppointments, localAppointments.supervisorNote);
           await m.addColumn(localVisits, localVisits.retroactiveReason);
           await m.addColumn(localVisits, localVisits.saveLocationLat);
           await m.addColumn(localVisits, localVisits.saveLocationLng);
           await m.addColumn(localExpenses, localExpenses.requiresAdminApproval);
           await m.addColumn(localExpenses, localExpenses.approvedBy);
           await m.addColumn(localExpenses, localExpenses.approvedAt);
           await m.addColumn(localExpenses, localExpenses.repName);
         }
          if (from < 13) {
            await m.addColumn(localVisits, localVisits.supervisorNote);
            await m.alterTable(TableMigration(localExpenses));
            await m.alterTable(TableMigration(localVisitPhotos));
            await m.alterTable(TableMigration(localPharmacyStockChecks));
          }
          if (from < 14) {
            await m.createTable(localClients);
          }
          if (from < 15) {
            await m.addColumn(localAppointments, localAppointments.clientId);
          }

        if (from < 16) {
           await m.addColumn(localVisits, localVisits.syncError);
           await m.addColumn(localVisits, localVisits.isAbandoned);
           await m.addColumn(localVisitItems, localVisitItems.syncError);
           await m.addColumn(localVisitItems, localVisitItems.isAbandoned);
           await m.addColumn(localPharmacyStockChecks, localPharmacyStockChecks.syncError);
           await m.addColumn(localPharmacyStockChecks, localPharmacyStockChecks.isAbandoned);
           await m.addColumn(localCenters, localCenters.syncError);
           await m.addColumn(localCenters, localCenters.isAbandoned);
           await m.addColumn(localAppointments, localAppointments.syncError);
           await m.addColumn(localAppointments, localAppointments.isAbandoned);
           await m.addColumn(localNotifications, localNotifications.syncError);
           await m.addColumn(localNotifications, localNotifications.isAbandoned);
           await m.addColumn(localVisitPhotos, localVisitPhotos.syncError);
           await m.addColumn(localVisitPhotos, localVisitPhotos.isAbandoned);
            await m.addColumn(localFieldReports, localFieldReports.syncError);
           await m.addColumn(localFieldReports, localFieldReports.isAbandoned);
           await m.addColumn(localExpenses, localExpenses.syncError);
           await m.addColumn(localExpenses, localExpenses.isAbandoned);
           await m.addColumn(localSpecialRequests, localSpecialRequests.syncError);
           await m.addColumn(localSpecialRequests, localSpecialRequests.isAbandoned);
           await m.addColumn(localClients, localClients.syncError);
           await m.addColumn(localClients, localClients.isAbandoned);
        }

          // v17 introduced brandId on centers/products — must use its own
          // version guard; devices already at v16 would otherwise upgrade
          // without these columns and crash on SQL.
          if (from < 17) {
            await m.addColumn(localCenters, localCenters.brandId);
            await m.addColumn(localProducts, localProducts.brandId);
          }
          if (from < 17) {
            try {
              await customStatement('DROP TABLE IF EXISTS local_route_points');
            } catch (_) {}
          }
          if (from < 18) {
            // Doctor-visit flow columns
            await m.addColumn(localClients, localClients.gender);
            await m.addColumn(localClients, localClients.rating);
            await m.addColumn(localClients, localClients.treatmentQuality);
            await m.addColumn(localVisits, localVisits.clientId);
            await m.addColumn(localVisits, localVisits.visitType);
            await m.addColumn(localVisits, localVisits.visitReason);
            await m.addColumn(localVisits, localVisits.interestedProductIds);
          }
          if (from < 19) {
            await m.addColumn(localClients, localClients.clientType);
            await m.addColumn(localClients, localClients.status);
            await m.addColumn(localClients, localClients.scientificInterests);
            await m.addColumn(localClients, localClients.productInterests);
            await m.addColumn(localClients, localClients.pharmacyType);
            await m.addColumn(localClients, localClients.institutionType);
            await m.addColumn(localClients, localClients.keyContactName);
            await m.addColumn(localClients, localClients.keyContactPosition);
            await m.addColumn(localClients, localClients.keyContactPhone);
            await m.addColumn(localClients, localClients.departments);
          }
          if (from < 20) {
            await m.createTable(localUserSignatures);
          }
                    if (from < 21) {
              await m.addColumn(localVisits, localVisits.referenceCode);
              await m.addColumn(localAppointments, localAppointments.referenceCode);
              await m.addColumn(localAppointments, localAppointments.status);
            }
          if (from < 22) {
              await m.addColumn(localClients, localClients.brandId);
          }
          if (from < 23) {
              await m.addColumn(localVisits, localVisits.taskId);
          }
      },
    );

  // --- Helpers for Sync ---

  /// Get all unsynced centers
  Future<List<LocalCenter>> getUnsyncedCenters() {
    return (select(localCenters)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> updateAppointmentsCenterId({required String oldId, required String newId}) async {
    await (update(localAppointments)..where((t) => t.centerId.equals(oldId)))
        .write(LocalAppointmentsCompanion(centerId: Value(newId)));
  }

  Future<void> updateVisitsCenterId({required String oldId, required String newId}) async {
    await (update(localVisits)..where((t) => t.centerId.equals(oldId)))
        .write(LocalVisitsCompanion(centerId: Value(newId)));
  }

  Future<void> deleteLocalCenter(String id) async {
    await (delete(localCenters)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markAppointmentSynced(String id) async {
    await (update(localAppointments)..where((t) => t.id.equals(id)))
        .write(const LocalAppointmentsCompanion(synced: Value(true)));
  }

  // --- Photos Sync ---
  Future<List<LocalVisitPhoto>> getUnsyncedPhotos() {
    return (select(localVisitPhotos)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> markPhotoSynced(String id, {required String uploadedUrl}) async {
    await (update(localVisitPhotos)..where((t) => t.id.equals(id)))
        .write(LocalVisitPhotosCompanion(
      synced: const Value(true),
      uploadedUrl: Value(uploadedUrl),
    ));
  }

  Future<void> deletePhoto(String id) async {
    await (delete(localVisitPhotos)..where((t) => t.id.equals(id))).go();
  }

  // --- Notifications ---
  Stream<List<LocalNotification>> getNotificationsStream(String userId) {
    return (select(localNotifications)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<void> clearNotificationsForUser(String userId) async {
    await (delete(localNotifications)..where((t) => t.userId.equals(userId))).go();
  }

  Future<void> deleteNotification(String id) async {
    await (delete(localNotifications)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllNotifications() async {
    await delete(localNotifications).go();
  }

  Future<void> upsertNotification(LocalNotificationsCompanion companion) async {
    await into(localNotifications).insertOnConflictUpdate(companion);
  }

  Future<List<LocalNotification>> getUnsyncedNotifications() {
    return (select(localNotifications)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> markNotificationSynced(String id) async {
    await (update(localNotifications)..where((t) => t.id.equals(id)))
        .write(const LocalNotificationsCompanion(synced: Value(true)));
  }

  Future<void> markCenterSynced(String id) async {
    await (update(localCenters)..where((t) => t.id.equals(id)))
        .write(const LocalCentersCompanion(synced: Value(true)));
  }

  /// Get all visits for a rep, ordered by date desc
  Future<List<LocalVisit>> getAllVisits(String repId) {
    return (select(localVisits)
          ..where((t) => t.repId.equals(repId))
          ..orderBy([(t) => OrderingTerm(expression: t.visitDate, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<LocalVisit>> watchAllVisits(String repId) {
    return (select(localVisits)
          ..where((t) => t.repId.equals(repId))
          ..orderBy([(t) => OrderingTerm(expression: t.visitDate, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Get all unsynced visits
  Future<List<LocalVisit>> getUnsyncedVisits() {
    return (select(localVisits)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  /// Get all unsynced visit items
  Future<List<LocalVisitItem>> getUnsyncedVisitItems() {
    return (select(localVisitItems)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  /// Get visit items for a specific visit
  Future<List<LocalVisitItem>> getVisitItemsForVisit(String visitId) {
    return (select(localVisitItems)..where((t) => t.visitId.equals(visitId))).get();
  }

  /// Get all unsynced stock checks
  Future<List<LocalPharmacyStockCheck>> getUnsyncedStockChecks() {
    return (select(localPharmacyStockChecks)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  /// Get all unsynced appointments
  Future<List<LocalAppointment>> getUnsyncedAppointments() {
    return (select(localAppointments)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  // --- Field Reports ---
  Future<List<LocalFieldReport>> getAllFieldReports() {
    return (select(localFieldReports)..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).get();
  }

  Future<List<LocalFieldReport>> getUnsyncedFieldReports() {
    return (select(localFieldReports)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> markFieldReportSynced(String id) async {
    await (update(localFieldReports)..where((t) => t.id.equals(id)))
        .write(const LocalFieldReportsCompanion(synced: Value(true)));
  }

  // --- Expenses Sync ---
  Future<List<LocalExpense>> getUnsyncedExpenses() {
    return (select(localExpenses)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> markExpenseSynced(String id, {String? uploadedUrl}) async {
    await (update(localExpenses)..where((t) => t.id.equals(id)))
        .write(LocalExpensesCompanion(
          synced: const Value(true),
          uploadedUrl: Value(uploadedUrl),
        ));
  }

  Future<List<LocalSpecialRequest>> getUnsyncedSpecialRequests() {
    return (select(localSpecialRequests)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  // --- Clients ---

  Stream<List<LocalClient>> getClientsStream({String? repId, String? brandId}) {
    // Sort by whichever name is present (doctor first, then facility)
    var query = select(localClients)
      ..where((t) => t.isAbandoned.equals(false))
      ..orderBy([
        (t) => OrderingTerm(expression: t.doctorName, mode: OrderingMode.asc, nulls: NullsOrder.last),
        (t) => OrderingTerm(expression: t.facilityName, mode: OrderingMode.asc, nulls: NullsOrder.last),
      ]);
    if (repId != null) {
      query = query..where((t) => t.repId.equals(repId));
    }
    return query.watch();
  }

  Future<List<LocalClient>> getUnsyncedClients() {
    return (select(localClients)..where((t) => t.synced.equals(false) & t.isAbandoned.equals(false))).get();
  }

  Future<void> markClientSynced(String id) async {
    await (update(localClients)..where((t) => t.id.equals(id)))
        .write(const LocalClientsCompanion(synced: Value(true)));
  }

  Future<List<LocalClient>> searchClients(String query) {
    return (select(localClients)
          ..where((t) => t.doctorName.contains(query) | t.facilityName.contains(query) | t.phoneNumber.contains(query)))
        .get();
  }


  // --- Abandonment Helpers ---
  Future<void> markVisitAbandoned(String id) async {
    await (update(localVisits)..where((t) => t.id.equals(id))).write(const LocalVisitsCompanion(isAbandoned: Value(true)));
  }
  Future<void> markExpenseAbandoned(String id) async {
    await (update(localExpenses)..where((t) => t.id.equals(id))).write(const LocalExpensesCompanion(isAbandoned: Value(true)));
  }
  Future<void> markPhotoAbandoned(String id) async {
    await (update(localVisitPhotos)..where((t) => t.id.equals(id))).write(const LocalVisitPhotosCompanion(isAbandoned: Value(true)));
  }
  Future<void> markStockCheckAbandoned(String id) async {
    await (update(localPharmacyStockChecks)..where((t) => t.id.equals(id))).write(const LocalPharmacyStockChecksCompanion(isAbandoned: Value(true)));
  }
  Future<void> markCenterAbandoned(String id) async {
    await (update(localCenters)..where((t) => t.id.equals(id))).write(const LocalCentersCompanion(isAbandoned: Value(true)));
  }
  Future<void> markAppointmentAbandoned(String id) async {
    await (update(localAppointments)..where((t) => t.id.equals(id))).write(const LocalAppointmentsCompanion(isAbandoned: Value(true)));
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pdos_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
