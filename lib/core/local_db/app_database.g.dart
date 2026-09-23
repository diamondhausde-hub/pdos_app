// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalVisitsTable extends LocalVisits
    with TableInfo<$LocalVisitsTable, LocalVisit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceCodeMeta = const VerificationMeta(
    'referenceCode',
  );
  @override
  late final GeneratedColumn<String> referenceCode = GeneratedColumn<String>(
    'reference_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repIdMeta = const VerificationMeta('repId');
  @override
  late final GeneratedColumn<String> repId = GeneratedColumn<String>(
    'rep_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centerIdMeta = const VerificationMeta(
    'centerId',
  );
  @override
  late final GeneratedColumn<String> centerId = GeneratedColumn<String>(
    'center_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitDateMeta = const VerificationMeta(
    'visitDate',
  );
  @override
  late final GeneratedColumn<DateTime> visitDate = GeneratedColumn<DateTime>(
    'visit_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalTimeMeta = const VerificationMeta(
    'arrivalTime',
  );
  @override
  late final GeneratedColumn<DateTime> arrivalTime = GeneratedColumn<DateTime>(
    'arrival_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionTimeMeta = const VerificationMeta(
    'completionTime',
  );
  @override
  late final GeneratedColumn<DateTime> completionTime =
      GeneratedColumn<DateTime>(
        'completion_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFlaggedMeta = const VerificationMeta(
    'isFlagged',
  );
  @override
  late final GeneratedColumn<bool> isFlagged = GeneratedColumn<bool>(
    'is_flagged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_flagged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supervisorNoteMeta = const VerificationMeta(
    'supervisorNote',
  );
  @override
  late final GeneratedColumn<String> supervisorNote = GeneratedColumn<String>(
    'supervisor_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signaturePathMeta = const VerificationMeta(
    'signaturePath',
  );
  @override
  late final GeneratedColumn<String> signaturePath = GeneratedColumn<String>(
    'signature_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureUrlMeta = const VerificationMeta(
    'signatureUrl',
  );
  @override
  late final GeneratedColumn<String> signatureUrl = GeneratedColumn<String>(
    'signature_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retroactiveReasonMeta = const VerificationMeta(
    'retroactiveReason',
  );
  @override
  late final GeneratedColumn<String> retroactiveReason =
      GeneratedColumn<String>(
        'retroactive_reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _saveLocationLatMeta = const VerificationMeta(
    'saveLocationLat',
  );
  @override
  late final GeneratedColumn<double> saveLocationLat = GeneratedColumn<double>(
    'save_location_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saveLocationLngMeta = const VerificationMeta(
    'saveLocationLng',
  );
  @override
  late final GeneratedColumn<double> saveLocationLng = GeneratedColumn<double>(
    'save_location_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitTypeMeta = const VerificationMeta(
    'visitType',
  );
  @override
  late final GeneratedColumn<String> visitType = GeneratedColumn<String>(
    'visit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('center'),
  );
  static const VerificationMeta _visitReasonMeta = const VerificationMeta(
    'visitReason',
  );
  @override
  late final GeneratedColumn<String> visitReason = GeneratedColumn<String>(
    'visit_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestedProductIdsMeta =
      const VerificationMeta('interestedProductIds');
  @override
  late final GeneratedColumn<String> interestedProductIds =
      GeneratedColumn<String>(
        'interested_product_ids',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    referenceCode,
    repId,
    brandId,
    centerId,
    appointmentId,
    visitDate,
    arrivalTime,
    completionTime,
    status,
    notes,
    latitude,
    longitude,
    isFlagged,
    supervisorNote,
    signaturePath,
    signatureUrl,
    retroactiveReason,
    saveLocationLat,
    saveLocationLng,
    synced,
    createdAt,
    updatedAt,
    syncError,
    isAbandoned,
    clientId,
    visitType,
    visitReason,
    interestedProductIds,
    taskId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reference_code')) {
      context.handle(
        _referenceCodeMeta,
        referenceCode.isAcceptableOrUnknown(
          data['reference_code']!,
          _referenceCodeMeta,
        ),
      );
    }
    if (data.containsKey('rep_id')) {
      context.handle(
        _repIdMeta,
        repId.isAcceptableOrUnknown(data['rep_id']!, _repIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('center_id')) {
      context.handle(
        _centerIdMeta,
        centerId.isAcceptableOrUnknown(data['center_id']!, _centerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_centerIdMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    }
    if (data.containsKey('visit_date')) {
      context.handle(
        _visitDateMeta,
        visitDate.isAcceptableOrUnknown(data['visit_date']!, _visitDateMeta),
      );
    } else if (isInserting) {
      context.missing(_visitDateMeta);
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
        _arrivalTimeMeta,
        arrivalTime.isAcceptableOrUnknown(
          data['arrival_time']!,
          _arrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('completion_time')) {
      context.handle(
        _completionTimeMeta,
        completionTime.isAcceptableOrUnknown(
          data['completion_time']!,
          _completionTimeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('is_flagged')) {
      context.handle(
        _isFlaggedMeta,
        isFlagged.isAcceptableOrUnknown(data['is_flagged']!, _isFlaggedMeta),
      );
    }
    if (data.containsKey('supervisor_note')) {
      context.handle(
        _supervisorNoteMeta,
        supervisorNote.isAcceptableOrUnknown(
          data['supervisor_note']!,
          _supervisorNoteMeta,
        ),
      );
    }
    if (data.containsKey('signature_path')) {
      context.handle(
        _signaturePathMeta,
        signaturePath.isAcceptableOrUnknown(
          data['signature_path']!,
          _signaturePathMeta,
        ),
      );
    }
    if (data.containsKey('signature_url')) {
      context.handle(
        _signatureUrlMeta,
        signatureUrl.isAcceptableOrUnknown(
          data['signature_url']!,
          _signatureUrlMeta,
        ),
      );
    }
    if (data.containsKey('retroactive_reason')) {
      context.handle(
        _retroactiveReasonMeta,
        retroactiveReason.isAcceptableOrUnknown(
          data['retroactive_reason']!,
          _retroactiveReasonMeta,
        ),
      );
    }
    if (data.containsKey('save_location_lat')) {
      context.handle(
        _saveLocationLatMeta,
        saveLocationLat.isAcceptableOrUnknown(
          data['save_location_lat']!,
          _saveLocationLatMeta,
        ),
      );
    }
    if (data.containsKey('save_location_lng')) {
      context.handle(
        _saveLocationLngMeta,
        saveLocationLng.isAcceptableOrUnknown(
          data['save_location_lng']!,
          _saveLocationLngMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('visit_type')) {
      context.handle(
        _visitTypeMeta,
        visitType.isAcceptableOrUnknown(data['visit_type']!, _visitTypeMeta),
      );
    }
    if (data.containsKey('visit_reason')) {
      context.handle(
        _visitReasonMeta,
        visitReason.isAcceptableOrUnknown(
          data['visit_reason']!,
          _visitReasonMeta,
        ),
      );
    }
    if (data.containsKey('interested_product_ids')) {
      context.handle(
        _interestedProductIdsMeta,
        interestedProductIds.isAcceptableOrUnknown(
          data['interested_product_ids']!,
          _interestedProductIdsMeta,
        ),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVisit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      referenceCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_code'],
      ),
      repId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      centerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}center_id'],
      )!,
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      ),
      visitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visit_date'],
      )!,
      arrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrival_time'],
      ),
      completionTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completion_time'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      isFlagged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_flagged'],
      )!,
      supervisorNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supervisor_note'],
      ),
      signaturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_path'],
      ),
      signatureUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_url'],
      ),
      retroactiveReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}retroactive_reason'],
      ),
      saveLocationLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}save_location_lat'],
      ),
      saveLocationLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}save_location_lng'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      visitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_type'],
      )!,
      visitReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_reason'],
      ),
      interestedProductIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interested_product_ids'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
    );
  }

  @override
  $LocalVisitsTable createAlias(String alias) {
    return $LocalVisitsTable(attachedDatabase, alias);
  }
}

class LocalVisit extends DataClass implements Insertable<LocalVisit> {
  final String id;
  final String? referenceCode;
  final String repId;
  final String? brandId;
  final String centerId;
  final String? appointmentId;
  final DateTime visitDate;
  final DateTime? arrivalTime;
  final DateTime? completionTime;
  final String status;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final bool isFlagged;
  final String? supervisorNote;
  final String? signaturePath;
  final String? signatureUrl;
  final String? retroactiveReason;
  final double? saveLocationLat;
  final double? saveLocationLng;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncError;
  final bool isAbandoned;
  final String? clientId;
  final String visitType;
  final String? visitReason;
  final String? interestedProductIds;
  final String? taskId;
  const LocalVisit({
    required this.id,
    this.referenceCode,
    required this.repId,
    this.brandId,
    required this.centerId,
    this.appointmentId,
    required this.visitDate,
    this.arrivalTime,
    this.completionTime,
    required this.status,
    this.notes,
    this.latitude,
    this.longitude,
    required this.isFlagged,
    this.supervisorNote,
    this.signaturePath,
    this.signatureUrl,
    this.retroactiveReason,
    this.saveLocationLat,
    this.saveLocationLng,
    required this.synced,
    required this.createdAt,
    required this.updatedAt,
    this.syncError,
    required this.isAbandoned,
    this.clientId,
    required this.visitType,
    this.visitReason,
    this.interestedProductIds,
    this.taskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || referenceCode != null) {
      map['reference_code'] = Variable<String>(referenceCode);
    }
    map['rep_id'] = Variable<String>(repId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    map['center_id'] = Variable<String>(centerId);
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<String>(appointmentId);
    }
    map['visit_date'] = Variable<DateTime>(visitDate);
    if (!nullToAbsent || arrivalTime != null) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime);
    }
    if (!nullToAbsent || completionTime != null) {
      map['completion_time'] = Variable<DateTime>(completionTime);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['is_flagged'] = Variable<bool>(isFlagged);
    if (!nullToAbsent || supervisorNote != null) {
      map['supervisor_note'] = Variable<String>(supervisorNote);
    }
    if (!nullToAbsent || signaturePath != null) {
      map['signature_path'] = Variable<String>(signaturePath);
    }
    if (!nullToAbsent || signatureUrl != null) {
      map['signature_url'] = Variable<String>(signatureUrl);
    }
    if (!nullToAbsent || retroactiveReason != null) {
      map['retroactive_reason'] = Variable<String>(retroactiveReason);
    }
    if (!nullToAbsent || saveLocationLat != null) {
      map['save_location_lat'] = Variable<double>(saveLocationLat);
    }
    if (!nullToAbsent || saveLocationLng != null) {
      map['save_location_lng'] = Variable<double>(saveLocationLng);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    map['visit_type'] = Variable<String>(visitType);
    if (!nullToAbsent || visitReason != null) {
      map['visit_reason'] = Variable<String>(visitReason);
    }
    if (!nullToAbsent || interestedProductIds != null) {
      map['interested_product_ids'] = Variable<String>(interestedProductIds);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    return map;
  }

  LocalVisitsCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitsCompanion(
      id: Value(id),
      referenceCode: referenceCode == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceCode),
      repId: Value(repId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      centerId: Value(centerId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      visitDate: Value(visitDate),
      arrivalTime: arrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalTime),
      completionTime: completionTime == null && nullToAbsent
          ? const Value.absent()
          : Value(completionTime),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isFlagged: Value(isFlagged),
      supervisorNote: supervisorNote == null && nullToAbsent
          ? const Value.absent()
          : Value(supervisorNote),
      signaturePath: signaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(signaturePath),
      signatureUrl: signatureUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(signatureUrl),
      retroactiveReason: retroactiveReason == null && nullToAbsent
          ? const Value.absent()
          : Value(retroactiveReason),
      saveLocationLat: saveLocationLat == null && nullToAbsent
          ? const Value.absent()
          : Value(saveLocationLat),
      saveLocationLng: saveLocationLng == null && nullToAbsent
          ? const Value.absent()
          : Value(saveLocationLng),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      visitType: Value(visitType),
      visitReason: visitReason == null && nullToAbsent
          ? const Value.absent()
          : Value(visitReason),
      interestedProductIds: interestedProductIds == null && nullToAbsent
          ? const Value.absent()
          : Value(interestedProductIds),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
    );
  }

  factory LocalVisit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisit(
      id: serializer.fromJson<String>(json['id']),
      referenceCode: serializer.fromJson<String?>(json['referenceCode']),
      repId: serializer.fromJson<String>(json['repId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      centerId: serializer.fromJson<String>(json['centerId']),
      appointmentId: serializer.fromJson<String?>(json['appointmentId']),
      visitDate: serializer.fromJson<DateTime>(json['visitDate']),
      arrivalTime: serializer.fromJson<DateTime?>(json['arrivalTime']),
      completionTime: serializer.fromJson<DateTime?>(json['completionTime']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isFlagged: serializer.fromJson<bool>(json['isFlagged']),
      supervisorNote: serializer.fromJson<String?>(json['supervisorNote']),
      signaturePath: serializer.fromJson<String?>(json['signaturePath']),
      signatureUrl: serializer.fromJson<String?>(json['signatureUrl']),
      retroactiveReason: serializer.fromJson<String?>(
        json['retroactiveReason'],
      ),
      saveLocationLat: serializer.fromJson<double?>(json['saveLocationLat']),
      saveLocationLng: serializer.fromJson<double?>(json['saveLocationLng']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      visitType: serializer.fromJson<String>(json['visitType']),
      visitReason: serializer.fromJson<String?>(json['visitReason']),
      interestedProductIds: serializer.fromJson<String?>(
        json['interestedProductIds'],
      ),
      taskId: serializer.fromJson<String?>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'referenceCode': serializer.toJson<String?>(referenceCode),
      'repId': serializer.toJson<String>(repId),
      'brandId': serializer.toJson<String?>(brandId),
      'centerId': serializer.toJson<String>(centerId),
      'appointmentId': serializer.toJson<String?>(appointmentId),
      'visitDate': serializer.toJson<DateTime>(visitDate),
      'arrivalTime': serializer.toJson<DateTime?>(arrivalTime),
      'completionTime': serializer.toJson<DateTime?>(completionTime),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isFlagged': serializer.toJson<bool>(isFlagged),
      'supervisorNote': serializer.toJson<String?>(supervisorNote),
      'signaturePath': serializer.toJson<String?>(signaturePath),
      'signatureUrl': serializer.toJson<String?>(signatureUrl),
      'retroactiveReason': serializer.toJson<String?>(retroactiveReason),
      'saveLocationLat': serializer.toJson<double?>(saveLocationLat),
      'saveLocationLng': serializer.toJson<double?>(saveLocationLng),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
      'clientId': serializer.toJson<String?>(clientId),
      'visitType': serializer.toJson<String>(visitType),
      'visitReason': serializer.toJson<String?>(visitReason),
      'interestedProductIds': serializer.toJson<String?>(interestedProductIds),
      'taskId': serializer.toJson<String?>(taskId),
    };
  }

  LocalVisit copyWith({
    String? id,
    Value<String?> referenceCode = const Value.absent(),
    String? repId,
    Value<String?> brandId = const Value.absent(),
    String? centerId,
    Value<String?> appointmentId = const Value.absent(),
    DateTime? visitDate,
    Value<DateTime?> arrivalTime = const Value.absent(),
    Value<DateTime?> completionTime = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    bool? isFlagged,
    Value<String?> supervisorNote = const Value.absent(),
    Value<String?> signaturePath = const Value.absent(),
    Value<String?> signatureUrl = const Value.absent(),
    Value<String?> retroactiveReason = const Value.absent(),
    Value<double?> saveLocationLat = const Value.absent(),
    Value<double?> saveLocationLng = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
    Value<String?> clientId = const Value.absent(),
    String? visitType,
    Value<String?> visitReason = const Value.absent(),
    Value<String?> interestedProductIds = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
  }) => LocalVisit(
    id: id ?? this.id,
    referenceCode: referenceCode.present
        ? referenceCode.value
        : this.referenceCode,
    repId: repId ?? this.repId,
    brandId: brandId.present ? brandId.value : this.brandId,
    centerId: centerId ?? this.centerId,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
    visitDate: visitDate ?? this.visitDate,
    arrivalTime: arrivalTime.present ? arrivalTime.value : this.arrivalTime,
    completionTime: completionTime.present
        ? completionTime.value
        : this.completionTime,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    isFlagged: isFlagged ?? this.isFlagged,
    supervisorNote: supervisorNote.present
        ? supervisorNote.value
        : this.supervisorNote,
    signaturePath: signaturePath.present
        ? signaturePath.value
        : this.signaturePath,
    signatureUrl: signatureUrl.present ? signatureUrl.value : this.signatureUrl,
    retroactiveReason: retroactiveReason.present
        ? retroactiveReason.value
        : this.retroactiveReason,
    saveLocationLat: saveLocationLat.present
        ? saveLocationLat.value
        : this.saveLocationLat,
    saveLocationLng: saveLocationLng.present
        ? saveLocationLng.value
        : this.saveLocationLng,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
    clientId: clientId.present ? clientId.value : this.clientId,
    visitType: visitType ?? this.visitType,
    visitReason: visitReason.present ? visitReason.value : this.visitReason,
    interestedProductIds: interestedProductIds.present
        ? interestedProductIds.value
        : this.interestedProductIds,
    taskId: taskId.present ? taskId.value : this.taskId,
  );
  LocalVisit copyWithCompanion(LocalVisitsCompanion data) {
    return LocalVisit(
      id: data.id.present ? data.id.value : this.id,
      referenceCode: data.referenceCode.present
          ? data.referenceCode.value
          : this.referenceCode,
      repId: data.repId.present ? data.repId.value : this.repId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      centerId: data.centerId.present ? data.centerId.value : this.centerId,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      visitDate: data.visitDate.present ? data.visitDate.value : this.visitDate,
      arrivalTime: data.arrivalTime.present
          ? data.arrivalTime.value
          : this.arrivalTime,
      completionTime: data.completionTime.present
          ? data.completionTime.value
          : this.completionTime,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isFlagged: data.isFlagged.present ? data.isFlagged.value : this.isFlagged,
      supervisorNote: data.supervisorNote.present
          ? data.supervisorNote.value
          : this.supervisorNote,
      signaturePath: data.signaturePath.present
          ? data.signaturePath.value
          : this.signaturePath,
      signatureUrl: data.signatureUrl.present
          ? data.signatureUrl.value
          : this.signatureUrl,
      retroactiveReason: data.retroactiveReason.present
          ? data.retroactiveReason.value
          : this.retroactiveReason,
      saveLocationLat: data.saveLocationLat.present
          ? data.saveLocationLat.value
          : this.saveLocationLat,
      saveLocationLng: data.saveLocationLng.present
          ? data.saveLocationLng.value
          : this.saveLocationLng,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      visitType: data.visitType.present ? data.visitType.value : this.visitType,
      visitReason: data.visitReason.present
          ? data.visitReason.value
          : this.visitReason,
      interestedProductIds: data.interestedProductIds.present
          ? data.interestedProductIds.value
          : this.interestedProductIds,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisit(')
          ..write('id: $id, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('centerId: $centerId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('visitDate: $visitDate, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('completionTime: $completionTime, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isFlagged: $isFlagged, ')
          ..write('supervisorNote: $supervisorNote, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('signatureUrl: $signatureUrl, ')
          ..write('retroactiveReason: $retroactiveReason, ')
          ..write('saveLocationLat: $saveLocationLat, ')
          ..write('saveLocationLng: $saveLocationLng, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('clientId: $clientId, ')
          ..write('visitType: $visitType, ')
          ..write('visitReason: $visitReason, ')
          ..write('interestedProductIds: $interestedProductIds, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    referenceCode,
    repId,
    brandId,
    centerId,
    appointmentId,
    visitDate,
    arrivalTime,
    completionTime,
    status,
    notes,
    latitude,
    longitude,
    isFlagged,
    supervisorNote,
    signaturePath,
    signatureUrl,
    retroactiveReason,
    saveLocationLat,
    saveLocationLng,
    synced,
    createdAt,
    updatedAt,
    syncError,
    isAbandoned,
    clientId,
    visitType,
    visitReason,
    interestedProductIds,
    taskId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisit &&
          other.id == this.id &&
          other.referenceCode == this.referenceCode &&
          other.repId == this.repId &&
          other.brandId == this.brandId &&
          other.centerId == this.centerId &&
          other.appointmentId == this.appointmentId &&
          other.visitDate == this.visitDate &&
          other.arrivalTime == this.arrivalTime &&
          other.completionTime == this.completionTime &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isFlagged == this.isFlagged &&
          other.supervisorNote == this.supervisorNote &&
          other.signaturePath == this.signaturePath &&
          other.signatureUrl == this.signatureUrl &&
          other.retroactiveReason == this.retroactiveReason &&
          other.saveLocationLat == this.saveLocationLat &&
          other.saveLocationLng == this.saveLocationLng &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned &&
          other.clientId == this.clientId &&
          other.visitType == this.visitType &&
          other.visitReason == this.visitReason &&
          other.interestedProductIds == this.interestedProductIds &&
          other.taskId == this.taskId);
}

class LocalVisitsCompanion extends UpdateCompanion<LocalVisit> {
  final Value<String> id;
  final Value<String?> referenceCode;
  final Value<String> repId;
  final Value<String?> brandId;
  final Value<String> centerId;
  final Value<String?> appointmentId;
  final Value<DateTime> visitDate;
  final Value<DateTime?> arrivalTime;
  final Value<DateTime?> completionTime;
  final Value<String> status;
  final Value<String?> notes;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isFlagged;
  final Value<String?> supervisorNote;
  final Value<String?> signaturePath;
  final Value<String?> signatureUrl;
  final Value<String?> retroactiveReason;
  final Value<double?> saveLocationLat;
  final Value<double?> saveLocationLng;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<String?> clientId;
  final Value<String> visitType;
  final Value<String?> visitReason;
  final Value<String?> interestedProductIds;
  final Value<String?> taskId;
  final Value<int> rowid;
  const LocalVisitsCompanion({
    this.id = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.repId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.centerId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.visitDate = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.completionTime = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isFlagged = const Value.absent(),
    this.supervisorNote = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.signatureUrl = const Value.absent(),
    this.retroactiveReason = const Value.absent(),
    this.saveLocationLat = const Value.absent(),
    this.saveLocationLng = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.clientId = const Value.absent(),
    this.visitType = const Value.absent(),
    this.visitReason = const Value.absent(),
    this.interestedProductIds = const Value.absent(),
    this.taskId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVisitsCompanion.insert({
    required String id,
    this.referenceCode = const Value.absent(),
    required String repId,
    this.brandId = const Value.absent(),
    required String centerId,
    this.appointmentId = const Value.absent(),
    required DateTime visitDate,
    this.arrivalTime = const Value.absent(),
    this.completionTime = const Value.absent(),
    required String status,
    this.notes = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isFlagged = const Value.absent(),
    this.supervisorNote = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.signatureUrl = const Value.absent(),
    this.retroactiveReason = const Value.absent(),
    this.saveLocationLat = const Value.absent(),
    this.saveLocationLng = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.clientId = const Value.absent(),
    this.visitType = const Value.absent(),
    this.visitReason = const Value.absent(),
    this.interestedProductIds = const Value.absent(),
    this.taskId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repId = Value(repId),
       centerId = Value(centerId),
       visitDate = Value(visitDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalVisit> custom({
    Expression<String>? id,
    Expression<String>? referenceCode,
    Expression<String>? repId,
    Expression<String>? brandId,
    Expression<String>? centerId,
    Expression<String>? appointmentId,
    Expression<DateTime>? visitDate,
    Expression<DateTime>? arrivalTime,
    Expression<DateTime>? completionTime,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isFlagged,
    Expression<String>? supervisorNote,
    Expression<String>? signaturePath,
    Expression<String>? signatureUrl,
    Expression<String>? retroactiveReason,
    Expression<double>? saveLocationLat,
    Expression<double>? saveLocationLng,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<String>? clientId,
    Expression<String>? visitType,
    Expression<String>? visitReason,
    Expression<String>? interestedProductIds,
    Expression<String>? taskId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceCode != null) 'reference_code': referenceCode,
      if (repId != null) 'rep_id': repId,
      if (brandId != null) 'brand_id': brandId,
      if (centerId != null) 'center_id': centerId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (visitDate != null) 'visit_date': visitDate,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (completionTime != null) 'completion_time': completionTime,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isFlagged != null) 'is_flagged': isFlagged,
      if (supervisorNote != null) 'supervisor_note': supervisorNote,
      if (signaturePath != null) 'signature_path': signaturePath,
      if (signatureUrl != null) 'signature_url': signatureUrl,
      if (retroactiveReason != null) 'retroactive_reason': retroactiveReason,
      if (saveLocationLat != null) 'save_location_lat': saveLocationLat,
      if (saveLocationLng != null) 'save_location_lng': saveLocationLng,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (clientId != null) 'client_id': clientId,
      if (visitType != null) 'visit_type': visitType,
      if (visitReason != null) 'visit_reason': visitReason,
      if (interestedProductIds != null)
        'interested_product_ids': interestedProductIds,
      if (taskId != null) 'task_id': taskId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVisitsCompanion copyWith({
    Value<String>? id,
    Value<String?>? referenceCode,
    Value<String>? repId,
    Value<String?>? brandId,
    Value<String>? centerId,
    Value<String?>? appointmentId,
    Value<DateTime>? visitDate,
    Value<DateTime?>? arrivalTime,
    Value<DateTime?>? completionTime,
    Value<String>? status,
    Value<String?>? notes,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<bool>? isFlagged,
    Value<String?>? supervisorNote,
    Value<String?>? signaturePath,
    Value<String?>? signatureUrl,
    Value<String?>? retroactiveReason,
    Value<double?>? saveLocationLat,
    Value<double?>? saveLocationLng,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<String?>? clientId,
    Value<String>? visitType,
    Value<String?>? visitReason,
    Value<String?>? interestedProductIds,
    Value<String?>? taskId,
    Value<int>? rowid,
  }) {
    return LocalVisitsCompanion(
      id: id ?? this.id,
      referenceCode: referenceCode ?? this.referenceCode,
      repId: repId ?? this.repId,
      brandId: brandId ?? this.brandId,
      centerId: centerId ?? this.centerId,
      appointmentId: appointmentId ?? this.appointmentId,
      visitDate: visitDate ?? this.visitDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      completionTime: completionTime ?? this.completionTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFlagged: isFlagged ?? this.isFlagged,
      supervisorNote: supervisorNote ?? this.supervisorNote,
      signaturePath: signaturePath ?? this.signaturePath,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      retroactiveReason: retroactiveReason ?? this.retroactiveReason,
      saveLocationLat: saveLocationLat ?? this.saveLocationLat,
      saveLocationLng: saveLocationLng ?? this.saveLocationLng,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      clientId: clientId ?? this.clientId,
      visitType: visitType ?? this.visitType,
      visitReason: visitReason ?? this.visitReason,
      interestedProductIds: interestedProductIds ?? this.interestedProductIds,
      taskId: taskId ?? this.taskId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (referenceCode.present) {
      map['reference_code'] = Variable<String>(referenceCode.value);
    }
    if (repId.present) {
      map['rep_id'] = Variable<String>(repId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (centerId.present) {
      map['center_id'] = Variable<String>(centerId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (visitDate.present) {
      map['visit_date'] = Variable<DateTime>(visitDate.value);
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime.value);
    }
    if (completionTime.present) {
      map['completion_time'] = Variable<DateTime>(completionTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isFlagged.present) {
      map['is_flagged'] = Variable<bool>(isFlagged.value);
    }
    if (supervisorNote.present) {
      map['supervisor_note'] = Variable<String>(supervisorNote.value);
    }
    if (signaturePath.present) {
      map['signature_path'] = Variable<String>(signaturePath.value);
    }
    if (signatureUrl.present) {
      map['signature_url'] = Variable<String>(signatureUrl.value);
    }
    if (retroactiveReason.present) {
      map['retroactive_reason'] = Variable<String>(retroactiveReason.value);
    }
    if (saveLocationLat.present) {
      map['save_location_lat'] = Variable<double>(saveLocationLat.value);
    }
    if (saveLocationLng.present) {
      map['save_location_lng'] = Variable<double>(saveLocationLng.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (visitType.present) {
      map['visit_type'] = Variable<String>(visitType.value);
    }
    if (visitReason.present) {
      map['visit_reason'] = Variable<String>(visitReason.value);
    }
    if (interestedProductIds.present) {
      map['interested_product_ids'] = Variable<String>(
        interestedProductIds.value,
      );
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitsCompanion(')
          ..write('id: $id, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('centerId: $centerId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('visitDate: $visitDate, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('completionTime: $completionTime, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isFlagged: $isFlagged, ')
          ..write('supervisorNote: $supervisorNote, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('signatureUrl: $signatureUrl, ')
          ..write('retroactiveReason: $retroactiveReason, ')
          ..write('saveLocationLat: $saveLocationLat, ')
          ..write('saveLocationLng: $saveLocationLng, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('clientId: $clientId, ')
          ..write('visitType: $visitType, ')
          ..write('visitReason: $visitReason, ')
          ..write('interestedProductIds: $interestedProductIds, ')
          ..write('taskId: $taskId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVisitItemsTable extends LocalVisitItems
    with TableInfo<$LocalVisitItemsTable, LocalVisitItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtySoldMeta = const VerificationMeta(
    'qtySold',
  );
  @override
  late final GeneratedColumn<int> qtySold = GeneratedColumn<int>(
    'qty_sold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _qtyFreeMeta = const VerificationMeta(
    'qtyFree',
  );
  @override
  late final GeneratedColumn<int> qtyFree = GeneratedColumn<int>(
    'qty_free',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priceAtSaleMeta = const VerificationMeta(
    'priceAtSale',
  );
  @override
  late final GeneratedColumn<double> priceAtSale = GeneratedColumn<double>(
    'price_at_sale',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    productId,
    qtySold,
    qtyFree,
    priceAtSale,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visit_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisitItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty_sold')) {
      context.handle(
        _qtySoldMeta,
        qtySold.isAcceptableOrUnknown(data['qty_sold']!, _qtySoldMeta),
      );
    }
    if (data.containsKey('qty_free')) {
      context.handle(
        _qtyFreeMeta,
        qtyFree.isAcceptableOrUnknown(data['qty_free']!, _qtyFreeMeta),
      );
    }
    if (data.containsKey('price_at_sale')) {
      context.handle(
        _priceAtSaleMeta,
        priceAtSale.isAcceptableOrUnknown(
          data['price_at_sale']!,
          _priceAtSaleMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVisitItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisitItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qtySold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_sold'],
      )!,
      qtyFree: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_free'],
      )!,
      priceAtSale: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_at_sale'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalVisitItemsTable createAlias(String alias) {
    return $LocalVisitItemsTable(attachedDatabase, alias);
  }
}

class LocalVisitItem extends DataClass implements Insertable<LocalVisitItem> {
  final String id;
  final String? visitId;
  final String productId;
  final int qtySold;
  final int qtyFree;
  final double? priceAtSale;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalVisitItem({
    required this.id,
    this.visitId,
    required this.productId,
    required this.qtySold,
    required this.qtyFree,
    this.priceAtSale,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['product_id'] = Variable<String>(productId);
    map['qty_sold'] = Variable<int>(qtySold);
    map['qty_free'] = Variable<int>(qtyFree);
    if (!nullToAbsent || priceAtSale != null) {
      map['price_at_sale'] = Variable<double>(priceAtSale);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalVisitItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitItemsCompanion(
      id: Value(id),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      productId: Value(productId),
      qtySold: Value(qtySold),
      qtyFree: Value(qtyFree),
      priceAtSale: priceAtSale == null && nullToAbsent
          ? const Value.absent()
          : Value(priceAtSale),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalVisitItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisitItem(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      productId: serializer.fromJson<String>(json['productId']),
      qtySold: serializer.fromJson<int>(json['qtySold']),
      qtyFree: serializer.fromJson<int>(json['qtyFree']),
      priceAtSale: serializer.fromJson<double?>(json['priceAtSale']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String?>(visitId),
      'productId': serializer.toJson<String>(productId),
      'qtySold': serializer.toJson<int>(qtySold),
      'qtyFree': serializer.toJson<int>(qtyFree),
      'priceAtSale': serializer.toJson<double?>(priceAtSale),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalVisitItem copyWith({
    String? id,
    Value<String?> visitId = const Value.absent(),
    String? productId,
    int? qtySold,
    int? qtyFree,
    Value<double?> priceAtSale = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalVisitItem(
    id: id ?? this.id,
    visitId: visitId.present ? visitId.value : this.visitId,
    productId: productId ?? this.productId,
    qtySold: qtySold ?? this.qtySold,
    qtyFree: qtyFree ?? this.qtyFree,
    priceAtSale: priceAtSale.present ? priceAtSale.value : this.priceAtSale,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalVisitItem copyWithCompanion(LocalVisitItemsCompanion data) {
    return LocalVisitItem(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qtySold: data.qtySold.present ? data.qtySold.value : this.qtySold,
      qtyFree: data.qtyFree.present ? data.qtyFree.value : this.qtyFree,
      priceAtSale: data.priceAtSale.present
          ? data.priceAtSale.value
          : this.priceAtSale,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitItem(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('qtySold: $qtySold, ')
          ..write('qtyFree: $qtyFree, ')
          ..write('priceAtSale: $priceAtSale, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    productId,
    qtySold,
    qtyFree,
    priceAtSale,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisitItem &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.productId == this.productId &&
          other.qtySold == this.qtySold &&
          other.qtyFree == this.qtyFree &&
          other.priceAtSale == this.priceAtSale &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalVisitItemsCompanion extends UpdateCompanion<LocalVisitItem> {
  final Value<String> id;
  final Value<String?> visitId;
  final Value<String> productId;
  final Value<int> qtySold;
  final Value<int> qtyFree;
  final Value<double?> priceAtSale;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalVisitItemsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qtySold = const Value.absent(),
    this.qtyFree = const Value.absent(),
    this.priceAtSale = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVisitItemsCompanion.insert({
    required String id,
    this.visitId = const Value.absent(),
    required String productId,
    this.qtySold = const Value.absent(),
    this.qtyFree = const Value.absent(),
    this.priceAtSale = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       createdAt = Value(createdAt);
  static Insertable<LocalVisitItem> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? productId,
    Expression<int>? qtySold,
    Expression<int>? qtyFree,
    Expression<double>? priceAtSale,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (productId != null) 'product_id': productId,
      if (qtySold != null) 'qty_sold': qtySold,
      if (qtyFree != null) 'qty_free': qtyFree,
      if (priceAtSale != null) 'price_at_sale': priceAtSale,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVisitItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? visitId,
    Value<String>? productId,
    Value<int>? qtySold,
    Value<int>? qtyFree,
    Value<double?>? priceAtSale,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalVisitItemsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      productId: productId ?? this.productId,
      qtySold: qtySold ?? this.qtySold,
      qtyFree: qtyFree ?? this.qtyFree,
      priceAtSale: priceAtSale ?? this.priceAtSale,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qtySold.present) {
      map['qty_sold'] = Variable<int>(qtySold.value);
    }
    if (qtyFree.present) {
      map['qty_free'] = Variable<int>(qtyFree.value);
    }
    if (priceAtSale.present) {
      map['price_at_sale'] = Variable<double>(priceAtSale.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitItemsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('qtySold: $qtySold, ')
          ..write('qtyFree: $qtyFree, ')
          ..write('priceAtSale: $priceAtSale, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPharmacyStockChecksTable extends LocalPharmacyStockChecks
    with TableInfo<$LocalPharmacyStockChecksTable, LocalPharmacyStockCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPharmacyStockChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _competitorProductNameMeta =
      const VerificationMeta('competitorProductName');
  @override
  late final GeneratedColumn<String> competitorProductName =
      GeneratedColumn<String>(
        'competitor_product_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observedQtyMeta = const VerificationMeta(
    'observedQty',
  );
  @override
  late final GeneratedColumn<int> observedQty = GeneratedColumn<int>(
    'observed_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    productId,
    competitorProductName,
    observedQty,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_pharmacy_stock_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPharmacyStockCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('competitor_product_name')) {
      context.handle(
        _competitorProductNameMeta,
        competitorProductName.isAcceptableOrUnknown(
          data['competitor_product_name']!,
          _competitorProductNameMeta,
        ),
      );
    }
    if (data.containsKey('observed_qty')) {
      context.handle(
        _observedQtyMeta,
        observedQty.isAcceptableOrUnknown(
          data['observed_qty']!,
          _observedQtyMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPharmacyStockCheck map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPharmacyStockCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      competitorProductName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}competitor_product_name'],
      ),
      observedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}observed_qty'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalPharmacyStockChecksTable createAlias(String alias) {
    return $LocalPharmacyStockChecksTable(attachedDatabase, alias);
  }
}

class LocalPharmacyStockCheck extends DataClass
    implements Insertable<LocalPharmacyStockCheck> {
  final String id;
  final String? visitId;
  final String? productId;
  final String? competitorProductName;
  final int observedQty;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalPharmacyStockCheck({
    required this.id,
    this.visitId,
    this.productId,
    this.competitorProductName,
    required this.observedQty,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || competitorProductName != null) {
      map['competitor_product_name'] = Variable<String>(competitorProductName);
    }
    map['observed_qty'] = Variable<int>(observedQty);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalPharmacyStockChecksCompanion toCompanion(bool nullToAbsent) {
    return LocalPharmacyStockChecksCompanion(
      id: Value(id),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      competitorProductName: competitorProductName == null && nullToAbsent
          ? const Value.absent()
          : Value(competitorProductName),
      observedQty: Value(observedQty),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalPharmacyStockCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPharmacyStockCheck(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      productId: serializer.fromJson<String?>(json['productId']),
      competitorProductName: serializer.fromJson<String?>(
        json['competitorProductName'],
      ),
      observedQty: serializer.fromJson<int>(json['observedQty']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String?>(visitId),
      'productId': serializer.toJson<String?>(productId),
      'competitorProductName': serializer.toJson<String?>(
        competitorProductName,
      ),
      'observedQty': serializer.toJson<int>(observedQty),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalPharmacyStockCheck copyWith({
    String? id,
    Value<String?> visitId = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    Value<String?> competitorProductName = const Value.absent(),
    int? observedQty,
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalPharmacyStockCheck(
    id: id ?? this.id,
    visitId: visitId.present ? visitId.value : this.visitId,
    productId: productId.present ? productId.value : this.productId,
    competitorProductName: competitorProductName.present
        ? competitorProductName.value
        : this.competitorProductName,
    observedQty: observedQty ?? this.observedQty,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalPharmacyStockCheck copyWithCompanion(
    LocalPharmacyStockChecksCompanion data,
  ) {
    return LocalPharmacyStockCheck(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      productId: data.productId.present ? data.productId.value : this.productId,
      competitorProductName: data.competitorProductName.present
          ? data.competitorProductName.value
          : this.competitorProductName,
      observedQty: data.observedQty.present
          ? data.observedQty.value
          : this.observedQty,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPharmacyStockCheck(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('competitorProductName: $competitorProductName, ')
          ..write('observedQty: $observedQty, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    productId,
    competitorProductName,
    observedQty,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPharmacyStockCheck &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.productId == this.productId &&
          other.competitorProductName == this.competitorProductName &&
          other.observedQty == this.observedQty &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalPharmacyStockChecksCompanion
    extends UpdateCompanion<LocalPharmacyStockCheck> {
  final Value<String> id;
  final Value<String?> visitId;
  final Value<String?> productId;
  final Value<String?> competitorProductName;
  final Value<int> observedQty;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalPharmacyStockChecksCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.productId = const Value.absent(),
    this.competitorProductName = const Value.absent(),
    this.observedQty = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPharmacyStockChecksCompanion.insert({
    required String id,
    this.visitId = const Value.absent(),
    this.productId = const Value.absent(),
    this.competitorProductName = const Value.absent(),
    this.observedQty = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<LocalPharmacyStockCheck> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? productId,
    Expression<String>? competitorProductName,
    Expression<int>? observedQty,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (productId != null) 'product_id': productId,
      if (competitorProductName != null)
        'competitor_product_name': competitorProductName,
      if (observedQty != null) 'observed_qty': observedQty,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPharmacyStockChecksCompanion copyWith({
    Value<String>? id,
    Value<String?>? visitId,
    Value<String?>? productId,
    Value<String?>? competitorProductName,
    Value<int>? observedQty,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalPharmacyStockChecksCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      productId: productId ?? this.productId,
      competitorProductName:
          competitorProductName ?? this.competitorProductName,
      observedQty: observedQty ?? this.observedQty,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (competitorProductName.present) {
      map['competitor_product_name'] = Variable<String>(
        competitorProductName.value,
      );
    }
    if (observedQty.present) {
      map['observed_qty'] = Variable<int>(observedQty.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPharmacyStockChecksCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('competitorProductName: $competitorProductName, ')
          ..write('observedQty: $observedQty, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCentersTable extends LocalCenters
    with TableInfo<$LocalCentersTable, LocalCenter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCentersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedRepIdMeta = const VerificationMeta(
    'assignedRepId',
  );
  @override
  late final GeneratedColumn<String> assignedRepId = GeneratedColumn<String>(
    'assigned_rep_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _rejectionReasonMeta = const VerificationMeta(
    'rejectionReason',
  );
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
    'rejection_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    region,
    latitude,
    longitude,
    address,
    assignedRepId,
    status,
    rejectionReason,
    createdAt,
    updatedAt,
    synced,
    brandId,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_centers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCenter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('assigned_rep_id')) {
      context.handle(
        _assignedRepIdMeta,
        assignedRepId.isAcceptableOrUnknown(
          data['assigned_rep_id']!,
          _assignedRepIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
        _rejectionReasonMeta,
        rejectionReason.isAcceptableOrUnknown(
          data['rejection_reason']!,
          _rejectionReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCenter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCenter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      assignedRepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_rep_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rejectionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalCentersTable createAlias(String alias) {
    return $LocalCentersTable(attachedDatabase, alias);
  }
}

class LocalCenter extends DataClass implements Insertable<LocalCenter> {
  final String id;
  final String name;
  final String? region;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? assignedRepId;
  final String status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;
  final String? brandId;
  final String? syncError;
  final bool isAbandoned;
  const LocalCenter({
    required this.id,
    required this.name,
    this.region,
    this.latitude,
    this.longitude,
    this.address,
    this.assignedRepId,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
    this.brandId,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || assignedRepId != null) {
      map['assigned_rep_id'] = Variable<String>(assignedRepId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalCentersCompanion toCompanion(bool nullToAbsent) {
    return LocalCentersCompanion(
      id: Value(id),
      name: Value(name),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      assignedRepId: assignedRepId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedRepId),
      status: Value(status),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalCenter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCenter(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      region: serializer.fromJson<String?>(json['region']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      address: serializer.fromJson<String?>(json['address']),
      assignedRepId: serializer.fromJson<String?>(json['assignedRepId']),
      status: serializer.fromJson<String>(json['status']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'region': serializer.toJson<String?>(region),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'address': serializer.toJson<String?>(address),
      'assignedRepId': serializer.toJson<String?>(assignedRepId),
      'status': serializer.toJson<String>(status),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
      'brandId': serializer.toJson<String?>(brandId),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalCenter copyWith({
    String? id,
    String? name,
    Value<String?> region = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> assignedRepId = const Value.absent(),
    String? status,
    Value<String?> rejectionReason = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    Value<String?> brandId = const Value.absent(),
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalCenter(
    id: id ?? this.id,
    name: name ?? this.name,
    region: region.present ? region.value : this.region,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    address: address.present ? address.value : this.address,
    assignedRepId: assignedRepId.present
        ? assignedRepId.value
        : this.assignedRepId,
    status: status ?? this.status,
    rejectionReason: rejectionReason.present
        ? rejectionReason.value
        : this.rejectionReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    synced: synced ?? this.synced,
    brandId: brandId.present ? brandId.value : this.brandId,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalCenter copyWithCompanion(LocalCentersCompanion data) {
    return LocalCenter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      region: data.region.present ? data.region.value : this.region,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      assignedRepId: data.assignedRepId.present
          ? data.assignedRepId.value
          : this.assignedRepId,
      status: data.status.present ? data.status.value : this.status,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCenter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('assignedRepId: $assignedRepId, ')
          ..write('status: $status, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('brandId: $brandId, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    region,
    latitude,
    longitude,
    address,
    assignedRepId,
    status,
    rejectionReason,
    createdAt,
    updatedAt,
    synced,
    brandId,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCenter &&
          other.id == this.id &&
          other.name == this.name &&
          other.region == this.region &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.assignedRepId == this.assignedRepId &&
          other.status == this.status &&
          other.rejectionReason == this.rejectionReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced &&
          other.brandId == this.brandId &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalCentersCompanion extends UpdateCompanion<LocalCenter> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> region;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> address;
  final Value<String?> assignedRepId;
  final Value<String> status;
  final Value<String?> rejectionReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<String?> brandId;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalCentersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.region = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.assignedRepId = const Value.absent(),
    this.status = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.brandId = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCentersCompanion.insert({
    required String id,
    required String name,
    this.region = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.assignedRepId = const Value.absent(),
    this.status = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.synced = const Value.absent(),
    this.brandId = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalCenter> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? region,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<String>? assignedRepId,
    Expression<String>? status,
    Expression<String>? rejectionReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<String>? brandId,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (region != null) 'region': region,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (assignedRepId != null) 'assigned_rep_id': assignedRepId,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (brandId != null) 'brand_id': brandId,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCentersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? region,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? address,
    Value<String?>? assignedRepId,
    Value<String>? status,
    Value<String?>? rejectionReason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? synced,
    Value<String?>? brandId,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalCentersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      assignedRepId: assignedRepId ?? this.assignedRepId,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      brandId: brandId ?? this.brandId,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (assignedRepId.present) {
      map['assigned_rep_id'] = Variable<String>(assignedRepId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCentersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('assignedRepId: $assignedRepId, ')
          ..write('status: $status, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('brandId: $brandId, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAppointmentsTable extends LocalAppointments
    with TableInfo<$LocalAppointmentsTable, LocalAppointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceCodeMeta = const VerificationMeta(
    'referenceCode',
  );
  @override
  late final GeneratedColumn<String> referenceCode = GeneratedColumn<String>(
    'reference_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repIdMeta = const VerificationMeta('repId');
  @override
  late final GeneratedColumn<String> repId = GeneratedColumn<String>(
    'rep_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centerIdMeta = const VerificationMeta(
    'centerId',
  );
  @override
  late final GeneratedColumn<String> centerId = GeneratedColumn<String>(
    'center_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centerNameMeta = const VerificationMeta(
    'centerName',
  );
  @override
  late final GeneratedColumn<String> centerName = GeneratedColumn<String>(
    'center_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apptDateMeta = const VerificationMeta(
    'apptDate',
  );
  @override
  late final GeneratedColumn<DateTime> apptDate = GeneratedColumn<DateTime>(
    'appt_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apptTimeMeta = const VerificationMeta(
    'apptTime',
  );
  @override
  late final GeneratedColumn<String> apptTime = GeneratedColumn<String>(
    'appt_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderMinutesBeforeMeta =
      const VerificationMeta('reminderMinutesBefore');
  @override
  late final GeneratedColumn<int> reminderMinutesBefore = GeneratedColumn<int>(
    'reminder_minutes_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedProductIdMeta =
      const VerificationMeta('suggestedProductId');
  @override
  late final GeneratedColumn<String> suggestedProductId =
      GeneratedColumn<String>(
        'suggested_product_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _suggestedProductNameMeta =
      const VerificationMeta('suggestedProductName');
  @override
  late final GeneratedColumn<String> suggestedProductName =
      GeneratedColumn<String>(
        'suggested_product_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _supervisorNoteMeta = const VerificationMeta(
    'supervisorNote',
  );
  @override
  late final GeneratedColumn<String> supervisorNote = GeneratedColumn<String>(
    'supervisor_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    referenceCode,
    repId,
    brandId,
    clientId,
    centerId,
    centerName,
    apptDate,
    apptTime,
    reminderMinutesBefore,
    notes,
    suggestedProductId,
    suggestedProductName,
    status,
    supervisorNote,
    synced,
    createdAt,
    updatedAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAppointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reference_code')) {
      context.handle(
        _referenceCodeMeta,
        referenceCode.isAcceptableOrUnknown(
          data['reference_code']!,
          _referenceCodeMeta,
        ),
      );
    }
    if (data.containsKey('rep_id')) {
      context.handle(
        _repIdMeta,
        repId.isAcceptableOrUnknown(data['rep_id']!, _repIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('center_id')) {
      context.handle(
        _centerIdMeta,
        centerId.isAcceptableOrUnknown(data['center_id']!, _centerIdMeta),
      );
    }
    if (data.containsKey('center_name')) {
      context.handle(
        _centerNameMeta,
        centerName.isAcceptableOrUnknown(data['center_name']!, _centerNameMeta),
      );
    }
    if (data.containsKey('appt_date')) {
      context.handle(
        _apptDateMeta,
        apptDate.isAcceptableOrUnknown(data['appt_date']!, _apptDateMeta),
      );
    } else if (isInserting) {
      context.missing(_apptDateMeta);
    }
    if (data.containsKey('appt_time')) {
      context.handle(
        _apptTimeMeta,
        apptTime.isAcceptableOrUnknown(data['appt_time']!, _apptTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_apptTimeMeta);
    }
    if (data.containsKey('reminder_minutes_before')) {
      context.handle(
        _reminderMinutesBeforeMeta,
        reminderMinutesBefore.isAcceptableOrUnknown(
          data['reminder_minutes_before']!,
          _reminderMinutesBeforeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('suggested_product_id')) {
      context.handle(
        _suggestedProductIdMeta,
        suggestedProductId.isAcceptableOrUnknown(
          data['suggested_product_id']!,
          _suggestedProductIdMeta,
        ),
      );
    }
    if (data.containsKey('suggested_product_name')) {
      context.handle(
        _suggestedProductNameMeta,
        suggestedProductName.isAcceptableOrUnknown(
          data['suggested_product_name']!,
          _suggestedProductNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('supervisor_note')) {
      context.handle(
        _supervisorNoteMeta,
        supervisorNote.isAcceptableOrUnknown(
          data['supervisor_note']!,
          _supervisorNoteMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAppointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAppointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      referenceCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_code'],
      ),
      repId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      centerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}center_id'],
      ),
      centerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}center_name'],
      ),
      apptDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}appt_date'],
      )!,
      apptTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appt_time'],
      )!,
      reminderMinutesBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes_before'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      suggestedProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_product_id'],
      ),
      suggestedProductName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_product_name'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      supervisorNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supervisor_note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalAppointmentsTable createAlias(String alias) {
    return $LocalAppointmentsTable(attachedDatabase, alias);
  }
}

class LocalAppointment extends DataClass
    implements Insertable<LocalAppointment> {
  final String id;
  final String? referenceCode;
  final String repId;
  final String? brandId;
  final String? clientId;
  final String? centerId;
  final String? centerName;
  final DateTime apptDate;
  final String apptTime;
  final int reminderMinutesBefore;
  final String? notes;
  final String? suggestedProductId;
  final String? suggestedProductName;
  final String status;
  final String? supervisorNote;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalAppointment({
    required this.id,
    this.referenceCode,
    required this.repId,
    this.brandId,
    this.clientId,
    this.centerId,
    this.centerName,
    required this.apptDate,
    required this.apptTime,
    required this.reminderMinutesBefore,
    this.notes,
    this.suggestedProductId,
    this.suggestedProductName,
    required this.status,
    this.supervisorNote,
    required this.synced,
    required this.createdAt,
    required this.updatedAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || referenceCode != null) {
      map['reference_code'] = Variable<String>(referenceCode);
    }
    map['rep_id'] = Variable<String>(repId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || centerId != null) {
      map['center_id'] = Variable<String>(centerId);
    }
    if (!nullToAbsent || centerName != null) {
      map['center_name'] = Variable<String>(centerName);
    }
    map['appt_date'] = Variable<DateTime>(apptDate);
    map['appt_time'] = Variable<String>(apptTime);
    map['reminder_minutes_before'] = Variable<int>(reminderMinutesBefore);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || suggestedProductId != null) {
      map['suggested_product_id'] = Variable<String>(suggestedProductId);
    }
    if (!nullToAbsent || suggestedProductName != null) {
      map['suggested_product_name'] = Variable<String>(suggestedProductName);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || supervisorNote != null) {
      map['supervisor_note'] = Variable<String>(supervisorNote);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalAppointmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalAppointmentsCompanion(
      id: Value(id),
      referenceCode: referenceCode == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceCode),
      repId: Value(repId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      centerId: centerId == null && nullToAbsent
          ? const Value.absent()
          : Value(centerId),
      centerName: centerName == null && nullToAbsent
          ? const Value.absent()
          : Value(centerName),
      apptDate: Value(apptDate),
      apptTime: Value(apptTime),
      reminderMinutesBefore: Value(reminderMinutesBefore),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      suggestedProductId: suggestedProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedProductId),
      suggestedProductName: suggestedProductName == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedProductName),
      status: Value(status),
      supervisorNote: supervisorNote == null && nullToAbsent
          ? const Value.absent()
          : Value(supervisorNote),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalAppointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAppointment(
      id: serializer.fromJson<String>(json['id']),
      referenceCode: serializer.fromJson<String?>(json['referenceCode']),
      repId: serializer.fromJson<String>(json['repId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      centerId: serializer.fromJson<String?>(json['centerId']),
      centerName: serializer.fromJson<String?>(json['centerName']),
      apptDate: serializer.fromJson<DateTime>(json['apptDate']),
      apptTime: serializer.fromJson<String>(json['apptTime']),
      reminderMinutesBefore: serializer.fromJson<int>(
        json['reminderMinutesBefore'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      suggestedProductId: serializer.fromJson<String?>(
        json['suggestedProductId'],
      ),
      suggestedProductName: serializer.fromJson<String?>(
        json['suggestedProductName'],
      ),
      status: serializer.fromJson<String>(json['status']),
      supervisorNote: serializer.fromJson<String?>(json['supervisorNote']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'referenceCode': serializer.toJson<String?>(referenceCode),
      'repId': serializer.toJson<String>(repId),
      'brandId': serializer.toJson<String?>(brandId),
      'clientId': serializer.toJson<String?>(clientId),
      'centerId': serializer.toJson<String?>(centerId),
      'centerName': serializer.toJson<String?>(centerName),
      'apptDate': serializer.toJson<DateTime>(apptDate),
      'apptTime': serializer.toJson<String>(apptTime),
      'reminderMinutesBefore': serializer.toJson<int>(reminderMinutesBefore),
      'notes': serializer.toJson<String?>(notes),
      'suggestedProductId': serializer.toJson<String?>(suggestedProductId),
      'suggestedProductName': serializer.toJson<String?>(suggestedProductName),
      'status': serializer.toJson<String>(status),
      'supervisorNote': serializer.toJson<String?>(supervisorNote),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalAppointment copyWith({
    String? id,
    Value<String?> referenceCode = const Value.absent(),
    String? repId,
    Value<String?> brandId = const Value.absent(),
    Value<String?> clientId = const Value.absent(),
    Value<String?> centerId = const Value.absent(),
    Value<String?> centerName = const Value.absent(),
    DateTime? apptDate,
    String? apptTime,
    int? reminderMinutesBefore,
    Value<String?> notes = const Value.absent(),
    Value<String?> suggestedProductId = const Value.absent(),
    Value<String?> suggestedProductName = const Value.absent(),
    String? status,
    Value<String?> supervisorNote = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalAppointment(
    id: id ?? this.id,
    referenceCode: referenceCode.present
        ? referenceCode.value
        : this.referenceCode,
    repId: repId ?? this.repId,
    brandId: brandId.present ? brandId.value : this.brandId,
    clientId: clientId.present ? clientId.value : this.clientId,
    centerId: centerId.present ? centerId.value : this.centerId,
    centerName: centerName.present ? centerName.value : this.centerName,
    apptDate: apptDate ?? this.apptDate,
    apptTime: apptTime ?? this.apptTime,
    reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
    notes: notes.present ? notes.value : this.notes,
    suggestedProductId: suggestedProductId.present
        ? suggestedProductId.value
        : this.suggestedProductId,
    suggestedProductName: suggestedProductName.present
        ? suggestedProductName.value
        : this.suggestedProductName,
    status: status ?? this.status,
    supervisorNote: supervisorNote.present
        ? supervisorNote.value
        : this.supervisorNote,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalAppointment copyWithCompanion(LocalAppointmentsCompanion data) {
    return LocalAppointment(
      id: data.id.present ? data.id.value : this.id,
      referenceCode: data.referenceCode.present
          ? data.referenceCode.value
          : this.referenceCode,
      repId: data.repId.present ? data.repId.value : this.repId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      centerId: data.centerId.present ? data.centerId.value : this.centerId,
      centerName: data.centerName.present
          ? data.centerName.value
          : this.centerName,
      apptDate: data.apptDate.present ? data.apptDate.value : this.apptDate,
      apptTime: data.apptTime.present ? data.apptTime.value : this.apptTime,
      reminderMinutesBefore: data.reminderMinutesBefore.present
          ? data.reminderMinutesBefore.value
          : this.reminderMinutesBefore,
      notes: data.notes.present ? data.notes.value : this.notes,
      suggestedProductId: data.suggestedProductId.present
          ? data.suggestedProductId.value
          : this.suggestedProductId,
      suggestedProductName: data.suggestedProductName.present
          ? data.suggestedProductName.value
          : this.suggestedProductName,
      status: data.status.present ? data.status.value : this.status,
      supervisorNote: data.supervisorNote.present
          ? data.supervisorNote.value
          : this.supervisorNote,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppointment(')
          ..write('id: $id, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('clientId: $clientId, ')
          ..write('centerId: $centerId, ')
          ..write('centerName: $centerName, ')
          ..write('apptDate: $apptDate, ')
          ..write('apptTime: $apptTime, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('notes: $notes, ')
          ..write('suggestedProductId: $suggestedProductId, ')
          ..write('suggestedProductName: $suggestedProductName, ')
          ..write('status: $status, ')
          ..write('supervisorNote: $supervisorNote, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    referenceCode,
    repId,
    brandId,
    clientId,
    centerId,
    centerName,
    apptDate,
    apptTime,
    reminderMinutesBefore,
    notes,
    suggestedProductId,
    suggestedProductName,
    status,
    supervisorNote,
    synced,
    createdAt,
    updatedAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAppointment &&
          other.id == this.id &&
          other.referenceCode == this.referenceCode &&
          other.repId == this.repId &&
          other.brandId == this.brandId &&
          other.clientId == this.clientId &&
          other.centerId == this.centerId &&
          other.centerName == this.centerName &&
          other.apptDate == this.apptDate &&
          other.apptTime == this.apptTime &&
          other.reminderMinutesBefore == this.reminderMinutesBefore &&
          other.notes == this.notes &&
          other.suggestedProductId == this.suggestedProductId &&
          other.suggestedProductName == this.suggestedProductName &&
          other.status == this.status &&
          other.supervisorNote == this.supervisorNote &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalAppointmentsCompanion extends UpdateCompanion<LocalAppointment> {
  final Value<String> id;
  final Value<String?> referenceCode;
  final Value<String> repId;
  final Value<String?> brandId;
  final Value<String?> clientId;
  final Value<String?> centerId;
  final Value<String?> centerName;
  final Value<DateTime> apptDate;
  final Value<String> apptTime;
  final Value<int> reminderMinutesBefore;
  final Value<String?> notes;
  final Value<String?> suggestedProductId;
  final Value<String?> suggestedProductName;
  final Value<String> status;
  final Value<String?> supervisorNote;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalAppointmentsCompanion({
    this.id = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.repId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.centerId = const Value.absent(),
    this.centerName = const Value.absent(),
    this.apptDate = const Value.absent(),
    this.apptTime = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.notes = const Value.absent(),
    this.suggestedProductId = const Value.absent(),
    this.suggestedProductName = const Value.absent(),
    this.status = const Value.absent(),
    this.supervisorNote = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAppointmentsCompanion.insert({
    required String id,
    this.referenceCode = const Value.absent(),
    required String repId,
    this.brandId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.centerId = const Value.absent(),
    this.centerName = const Value.absent(),
    required DateTime apptDate,
    required String apptTime,
    this.reminderMinutesBefore = const Value.absent(),
    this.notes = const Value.absent(),
    this.suggestedProductId = const Value.absent(),
    this.suggestedProductName = const Value.absent(),
    this.status = const Value.absent(),
    this.supervisorNote = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repId = Value(repId),
       apptDate = Value(apptDate),
       apptTime = Value(apptTime),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalAppointment> custom({
    Expression<String>? id,
    Expression<String>? referenceCode,
    Expression<String>? repId,
    Expression<String>? brandId,
    Expression<String>? clientId,
    Expression<String>? centerId,
    Expression<String>? centerName,
    Expression<DateTime>? apptDate,
    Expression<String>? apptTime,
    Expression<int>? reminderMinutesBefore,
    Expression<String>? notes,
    Expression<String>? suggestedProductId,
    Expression<String>? suggestedProductName,
    Expression<String>? status,
    Expression<String>? supervisorNote,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (referenceCode != null) 'reference_code': referenceCode,
      if (repId != null) 'rep_id': repId,
      if (brandId != null) 'brand_id': brandId,
      if (clientId != null) 'client_id': clientId,
      if (centerId != null) 'center_id': centerId,
      if (centerName != null) 'center_name': centerName,
      if (apptDate != null) 'appt_date': apptDate,
      if (apptTime != null) 'appt_time': apptTime,
      if (reminderMinutesBefore != null)
        'reminder_minutes_before': reminderMinutesBefore,
      if (notes != null) 'notes': notes,
      if (suggestedProductId != null)
        'suggested_product_id': suggestedProductId,
      if (suggestedProductName != null)
        'suggested_product_name': suggestedProductName,
      if (status != null) 'status': status,
      if (supervisorNote != null) 'supervisor_note': supervisorNote,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? referenceCode,
    Value<String>? repId,
    Value<String?>? brandId,
    Value<String?>? clientId,
    Value<String?>? centerId,
    Value<String?>? centerName,
    Value<DateTime>? apptDate,
    Value<String>? apptTime,
    Value<int>? reminderMinutesBefore,
    Value<String?>? notes,
    Value<String?>? suggestedProductId,
    Value<String?>? suggestedProductName,
    Value<String>? status,
    Value<String?>? supervisorNote,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalAppointmentsCompanion(
      id: id ?? this.id,
      referenceCode: referenceCode ?? this.referenceCode,
      repId: repId ?? this.repId,
      brandId: brandId ?? this.brandId,
      clientId: clientId ?? this.clientId,
      centerId: centerId ?? this.centerId,
      centerName: centerName ?? this.centerName,
      apptDate: apptDate ?? this.apptDate,
      apptTime: apptTime ?? this.apptTime,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      notes: notes ?? this.notes,
      suggestedProductId: suggestedProductId ?? this.suggestedProductId,
      suggestedProductName: suggestedProductName ?? this.suggestedProductName,
      status: status ?? this.status,
      supervisorNote: supervisorNote ?? this.supervisorNote,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (referenceCode.present) {
      map['reference_code'] = Variable<String>(referenceCode.value);
    }
    if (repId.present) {
      map['rep_id'] = Variable<String>(repId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (centerId.present) {
      map['center_id'] = Variable<String>(centerId.value);
    }
    if (centerName.present) {
      map['center_name'] = Variable<String>(centerName.value);
    }
    if (apptDate.present) {
      map['appt_date'] = Variable<DateTime>(apptDate.value);
    }
    if (apptTime.present) {
      map['appt_time'] = Variable<String>(apptTime.value);
    }
    if (reminderMinutesBefore.present) {
      map['reminder_minutes_before'] = Variable<int>(
        reminderMinutesBefore.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (suggestedProductId.present) {
      map['suggested_product_id'] = Variable<String>(suggestedProductId.value);
    }
    if (suggestedProductName.present) {
      map['suggested_product_name'] = Variable<String>(
        suggestedProductName.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (supervisorNote.present) {
      map['supervisor_note'] = Variable<String>(supervisorNote.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('clientId: $clientId, ')
          ..write('centerId: $centerId, ')
          ..write('centerName: $centerName, ')
          ..write('apptDate: $apptDate, ')
          ..write('apptTime: $apptTime, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('notes: $notes, ')
          ..write('suggestedProductId: $suggestedProductId, ')
          ..write('suggestedProductName: $suggestedProductName, ')
          ..write('status: $status, ')
          ..write('supervisorNote: $supervisorNote, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalNotificationsTable extends LocalNotifications
    with TableInfo<$LocalNotificationsTable, LocalNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedIdMeta = const VerificationMeta(
    'relatedId',
  );
  @override
  late final GeneratedColumn<String> relatedId = GeneratedColumn<String>(
    'related_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    title,
    message,
    relatedId,
    isRead,
    createdAt,
    synced,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('related_id')) {
      context.handle(
        _relatedIdMeta,
        relatedId.isAcceptableOrUnknown(data['related_id']!, _relatedIdMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      relatedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_id'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalNotificationsTable createAlias(String alias) {
    return $LocalNotificationsTable(attachedDatabase, alias);
  }
}

class LocalNotification extends DataClass
    implements Insertable<LocalNotification> {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? message;
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;
  final bool synced;
  final String? syncError;
  final bool isAbandoned;
  const LocalNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.message,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
    required this.synced,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || relatedId != null) {
      map['related_id'] = Variable<String>(relatedId);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalNotificationsCompanion toCompanion(bool nullToAbsent) {
    return LocalNotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      title: Value(title),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      relatedId: relatedId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedId),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
      synced: Value(synced),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalNotification(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String?>(json['message']),
      relatedId: serializer.fromJson<String?>(json['relatedId']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String?>(message),
      'relatedId': serializer.toJson<String?>(relatedId),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalNotification copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    Value<String?> message = const Value.absent(),
    Value<String?> relatedId = const Value.absent(),
    bool? isRead,
    DateTime? createdAt,
    bool? synced,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalNotification(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    title: title ?? this.title,
    message: message.present ? message.value : this.message,
    relatedId: relatedId.present ? relatedId.value : this.relatedId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalNotification copyWithCompanion(LocalNotificationsCompanion data) {
    return LocalNotification(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      relatedId: data.relatedId.present ? data.relatedId.value : this.relatedId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotification(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedId: $relatedId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    title,
    message,
    relatedId,
    isRead,
    createdAt,
    synced,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalNotification &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.title == this.title &&
          other.message == this.message &&
          other.relatedId == this.relatedId &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalNotificationsCompanion extends UpdateCompanion<LocalNotification> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> message;
  final Value<String?> relatedId;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalNotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.relatedId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalNotificationsCompanion.insert({
    required String id,
    required String userId,
    required String type,
    required String title,
    this.message = const Value.absent(),
    this.relatedId = const Value.absent(),
    this.isRead = const Value.absent(),
    required DateTime createdAt,
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       type = Value(type),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<LocalNotification> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? message,
    Expression<String>? relatedId,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (relatedId != null) 'related_id': relatedId,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? message,
    Value<String?>? relatedId,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<bool>? synced,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalNotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (relatedId.present) {
      map['related_id'] = Variable<String>(relatedId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedId: $relatedId, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductsTable extends LocalProducts
    with TableInfo<$LocalProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLowStockMeta = const VerificationMeta(
    'isLowStock',
  );
  @override
  late final GeneratedColumn<bool> isLowStock = GeneratedColumn<bool>(
    'is_low_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_low_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    unitPrice,
    stockQty,
    isLowStock,
    imageUrl,
    isActive,
    barcode,
    brandId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('is_low_stock')) {
      context.handle(
        _isLowStockMeta,
        isLowStock.isAcceptableOrUnknown(
          data['is_low_stock']!,
          _isLowStockMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      ),
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_qty'],
      )!,
      isLowStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_low_stock'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
    );
  }

  @override
  $LocalProductsTable createAlias(String alias) {
    return $LocalProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final String id;
  final String name;
  final String? category;
  final double? unitPrice;
  final int stockQty;
  final bool isLowStock;
  final String? imageUrl;
  final bool isActive;
  final String? barcode;
  final String? brandId;
  const LocalProduct({
    required this.id,
    required this.name,
    this.category,
    this.unitPrice,
    required this.stockQty,
    required this.isLowStock,
    this.imageUrl,
    required this.isActive,
    this.barcode,
    this.brandId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    map['stock_qty'] = Variable<int>(stockQty);
    map['is_low_stock'] = Variable<bool>(isLowStock);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    return map;
  }

  LocalProductsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      stockQty: Value(stockQty),
      isLowStock: Value(isLowStock),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isActive: Value(isActive),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
    );
  }

  factory LocalProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      isLowStock: serializer.fromJson<bool>(json['isLowStock']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      brandId: serializer.fromJson<String?>(json['brandId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'stockQty': serializer.toJson<int>(stockQty),
      'isLowStock': serializer.toJson<bool>(isLowStock),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isActive': serializer.toJson<bool>(isActive),
      'barcode': serializer.toJson<String?>(barcode),
      'brandId': serializer.toJson<String?>(brandId),
    };
  }

  LocalProduct copyWith({
    String? id,
    String? name,
    Value<String?> category = const Value.absent(),
    Value<double?> unitPrice = const Value.absent(),
    int? stockQty,
    bool? isLowStock,
    Value<String?> imageUrl = const Value.absent(),
    bool? isActive,
    Value<String?> barcode = const Value.absent(),
    Value<String?> brandId = const Value.absent(),
  }) => LocalProduct(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    stockQty: stockQty ?? this.stockQty,
    isLowStock: isLowStock ?? this.isLowStock,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isActive: isActive ?? this.isActive,
    barcode: barcode.present ? barcode.value : this.barcode,
    brandId: brandId.present ? brandId.value : this.brandId,
  );
  LocalProduct copyWithCompanion(LocalProductsCompanion data) {
    return LocalProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      isLowStock: data.isLowStock.present
          ? data.isLowStock.value
          : this.isLowStock,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('isLowStock: $isLowStock, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('barcode: $barcode, ')
          ..write('brandId: $brandId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    unitPrice,
    stockQty,
    isLowStock,
    imageUrl,
    isActive,
    barcode,
    brandId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.unitPrice == this.unitPrice &&
          other.stockQty == this.stockQty &&
          other.isLowStock == this.isLowStock &&
          other.imageUrl == this.imageUrl &&
          other.isActive == this.isActive &&
          other.barcode == this.barcode &&
          other.brandId == this.brandId);
}

class LocalProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<double?> unitPrice;
  final Value<int> stockQty;
  final Value<bool> isLowStock;
  final Value<String?> imageUrl;
  final Value<bool> isActive;
  final Value<String?> barcode;
  final Value<String?> brandId;
  final Value<int> rowid;
  const LocalProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.isLowStock = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.barcode = const Value.absent(),
    this.brandId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.isLowStock = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.barcode = const Value.absent(),
    this.brandId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<LocalProduct> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? unitPrice,
    Expression<int>? stockQty,
    Expression<bool>? isLowStock,
    Expression<String>? imageUrl,
    Expression<bool>? isActive,
    Expression<String>? barcode,
    Expression<String>? brandId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (stockQty != null) 'stock_qty': stockQty,
      if (isLowStock != null) 'is_low_stock': isLowStock,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isActive != null) 'is_active': isActive,
      if (barcode != null) 'barcode': barcode,
      if (brandId != null) 'brand_id': brandId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<double?>? unitPrice,
    Value<int>? stockQty,
    Value<bool>? isLowStock,
    Value<String?>? imageUrl,
    Value<bool>? isActive,
    Value<String?>? barcode,
    Value<String?>? brandId,
    Value<int>? rowid,
  }) {
    return LocalProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
      stockQty: stockQty ?? this.stockQty,
      isLowStock: isLowStock ?? this.isLowStock,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      barcode: barcode ?? this.barcode,
      brandId: brandId ?? this.brandId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (isLowStock.present) {
      map['is_low_stock'] = Variable<bool>(isLowStock.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('isLowStock: $isLowStock, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('barcode: $barcode, ')
          ..write('brandId: $brandId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVisitPhotosTable extends LocalVisitPhotos
    with TableInfo<$LocalVisitPhotosTable, LocalVisitPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedUrlMeta = const VerificationMeta(
    'uploadedUrl',
  );
  @override
  late final GeneratedColumn<String> uploadedUrl = GeneratedColumn<String>(
    'uploaded_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    photoPath,
    uploadedUrl,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visit_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisitPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('uploaded_url')) {
      context.handle(
        _uploadedUrlMeta,
        uploadedUrl.isAcceptableOrUnknown(
          data['uploaded_url']!,
          _uploadedUrlMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVisitPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisitPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      uploadedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_url'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalVisitPhotosTable createAlias(String alias) {
    return $LocalVisitPhotosTable(attachedDatabase, alias);
  }
}

class LocalVisitPhoto extends DataClass implements Insertable<LocalVisitPhoto> {
  final String id;
  final String? visitId;
  final String photoPath;
  final String? uploadedUrl;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalVisitPhoto({
    required this.id,
    this.visitId,
    required this.photoPath,
    this.uploadedUrl,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['photo_path'] = Variable<String>(photoPath);
    if (!nullToAbsent || uploadedUrl != null) {
      map['uploaded_url'] = Variable<String>(uploadedUrl);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalVisitPhotosCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitPhotosCompanion(
      id: Value(id),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      photoPath: Value(photoPath),
      uploadedUrl: uploadedUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedUrl),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalVisitPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisitPhoto(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      uploadedUrl: serializer.fromJson<String?>(json['uploadedUrl']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String?>(visitId),
      'photoPath': serializer.toJson<String>(photoPath),
      'uploadedUrl': serializer.toJson<String?>(uploadedUrl),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalVisitPhoto copyWith({
    String? id,
    Value<String?> visitId = const Value.absent(),
    String? photoPath,
    Value<String?> uploadedUrl = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalVisitPhoto(
    id: id ?? this.id,
    visitId: visitId.present ? visitId.value : this.visitId,
    photoPath: photoPath ?? this.photoPath,
    uploadedUrl: uploadedUrl.present ? uploadedUrl.value : this.uploadedUrl,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalVisitPhoto copyWithCompanion(LocalVisitPhotosCompanion data) {
    return LocalVisitPhoto(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      uploadedUrl: data.uploadedUrl.present
          ? data.uploadedUrl.value
          : this.uploadedUrl,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitPhoto(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('photoPath: $photoPath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    photoPath,
    uploadedUrl,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisitPhoto &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.photoPath == this.photoPath &&
          other.uploadedUrl == this.uploadedUrl &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalVisitPhotosCompanion extends UpdateCompanion<LocalVisitPhoto> {
  final Value<String> id;
  final Value<String?> visitId;
  final Value<String> photoPath;
  final Value<String?> uploadedUrl;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalVisitPhotosCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.uploadedUrl = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVisitPhotosCompanion.insert({
    required String id,
    this.visitId = const Value.absent(),
    required String photoPath,
    this.uploadedUrl = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       photoPath = Value(photoPath),
       createdAt = Value(createdAt);
  static Insertable<LocalVisitPhoto> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? photoPath,
    Expression<String>? uploadedUrl,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (photoPath != null) 'photo_path': photoPath,
      if (uploadedUrl != null) 'uploaded_url': uploadedUrl,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVisitPhotosCompanion copyWith({
    Value<String>? id,
    Value<String?>? visitId,
    Value<String>? photoPath,
    Value<String?>? uploadedUrl,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalVisitPhotosCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      photoPath: photoPath ?? this.photoPath,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (uploadedUrl.present) {
      map['uploaded_url'] = Variable<String>(uploadedUrl.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitPhotosCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('photoPath: $photoPath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFieldReportsTable extends LocalFieldReports
    with TableInfo<$LocalFieldReportsTable, LocalFieldReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFieldReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repIdMeta = const VerificationMeta('repId');
  @override
  late final GeneratedColumn<String> repId = GeneratedColumn<String>(
    'rep_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedUrlMeta = const VerificationMeta(
    'uploadedUrl',
  );
  @override
  late final GeneratedColumn<String> uploadedUrl = GeneratedColumn<String>(
    'uploaded_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repId,
    brandId,
    content,
    photoPath,
    uploadedUrl,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_field_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFieldReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rep_id')) {
      context.handle(
        _repIdMeta,
        repId.isAcceptableOrUnknown(data['rep_id']!, _repIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('uploaded_url')) {
      context.handle(
        _uploadedUrlMeta,
        uploadedUrl.isAcceptableOrUnknown(
          data['uploaded_url']!,
          _uploadedUrlMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalFieldReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFieldReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      uploadedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_url'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalFieldReportsTable createAlias(String alias) {
    return $LocalFieldReportsTable(attachedDatabase, alias);
  }
}

class LocalFieldReport extends DataClass
    implements Insertable<LocalFieldReport> {
  final String id;
  final String repId;
  final String? brandId;
  final String content;
  final String? photoPath;
  final String? uploadedUrl;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalFieldReport({
    required this.id,
    required this.repId,
    this.brandId,
    required this.content,
    this.photoPath,
    this.uploadedUrl,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rep_id'] = Variable<String>(repId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || uploadedUrl != null) {
      map['uploaded_url'] = Variable<String>(uploadedUrl);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalFieldReportsCompanion toCompanion(bool nullToAbsent) {
    return LocalFieldReportsCompanion(
      id: Value(id),
      repId: Value(repId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      content: Value(content),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      uploadedUrl: uploadedUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedUrl),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalFieldReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFieldReport(
      id: serializer.fromJson<String>(json['id']),
      repId: serializer.fromJson<String>(json['repId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      content: serializer.fromJson<String>(json['content']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      uploadedUrl: serializer.fromJson<String?>(json['uploadedUrl']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repId': serializer.toJson<String>(repId),
      'brandId': serializer.toJson<String?>(brandId),
      'content': serializer.toJson<String>(content),
      'photoPath': serializer.toJson<String?>(photoPath),
      'uploadedUrl': serializer.toJson<String?>(uploadedUrl),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalFieldReport copyWith({
    String? id,
    String? repId,
    Value<String?> brandId = const Value.absent(),
    String? content,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> uploadedUrl = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalFieldReport(
    id: id ?? this.id,
    repId: repId ?? this.repId,
    brandId: brandId.present ? brandId.value : this.brandId,
    content: content ?? this.content,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    uploadedUrl: uploadedUrl.present ? uploadedUrl.value : this.uploadedUrl,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalFieldReport copyWithCompanion(LocalFieldReportsCompanion data) {
    return LocalFieldReport(
      id: data.id.present ? data.id.value : this.id,
      repId: data.repId.present ? data.repId.value : this.repId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      content: data.content.present ? data.content.value : this.content,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      uploadedUrl: data.uploadedUrl.present
          ? data.uploadedUrl.value
          : this.uploadedUrl,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFieldReport(')
          ..write('id: $id, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('content: $content, ')
          ..write('photoPath: $photoPath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repId,
    brandId,
    content,
    photoPath,
    uploadedUrl,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFieldReport &&
          other.id == this.id &&
          other.repId == this.repId &&
          other.brandId == this.brandId &&
          other.content == this.content &&
          other.photoPath == this.photoPath &&
          other.uploadedUrl == this.uploadedUrl &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalFieldReportsCompanion extends UpdateCompanion<LocalFieldReport> {
  final Value<String> id;
  final Value<String> repId;
  final Value<String?> brandId;
  final Value<String> content;
  final Value<String?> photoPath;
  final Value<String?> uploadedUrl;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalFieldReportsCompanion({
    this.id = const Value.absent(),
    this.repId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.content = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.uploadedUrl = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFieldReportsCompanion.insert({
    required String id,
    required String repId,
    this.brandId = const Value.absent(),
    required String content,
    this.photoPath = const Value.absent(),
    this.uploadedUrl = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repId = Value(repId),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<LocalFieldReport> custom({
    Expression<String>? id,
    Expression<String>? repId,
    Expression<String>? brandId,
    Expression<String>? content,
    Expression<String>? photoPath,
    Expression<String>? uploadedUrl,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repId != null) 'rep_id': repId,
      if (brandId != null) 'brand_id': brandId,
      if (content != null) 'content': content,
      if (photoPath != null) 'photo_path': photoPath,
      if (uploadedUrl != null) 'uploaded_url': uploadedUrl,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFieldReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? repId,
    Value<String?>? brandId,
    Value<String>? content,
    Value<String?>? photoPath,
    Value<String?>? uploadedUrl,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalFieldReportsCompanion(
      id: id ?? this.id,
      repId: repId ?? this.repId,
      brandId: brandId ?? this.brandId,
      content: content ?? this.content,
      photoPath: photoPath ?? this.photoPath,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repId.present) {
      map['rep_id'] = Variable<String>(repId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (uploadedUrl.present) {
      map['uploaded_url'] = Variable<String>(uploadedUrl.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFieldReportsCompanion(')
          ..write('id: $id, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('content: $content, ')
          ..write('photoPath: $photoPath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpensesTable extends LocalExpenses
    with TableInfo<$LocalExpensesTable, LocalExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repIdMeta = const VerificationMeta('repId');
  @override
  late final GeneratedColumn<String> repId = GeneratedColumn<String>(
    'rep_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptImagePathMeta = const VerificationMeta(
    'receiptImagePath',
  );
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
    'receipt_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedUrlMeta = const VerificationMeta(
    'uploadedUrl',
  );
  @override
  late final GeneratedColumn<String> uploadedUrl = GeneratedColumn<String>(
    'uploaded_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _rejectionReasonMeta = const VerificationMeta(
    'rejectionReason',
  );
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
    'rejection_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresAdminApprovalMeta =
      const VerificationMeta('requiresAdminApproval');
  @override
  late final GeneratedColumn<bool> requiresAdminApproval =
      GeneratedColumn<bool>(
        'requires_admin_approval',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_admin_approval" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedAtMeta = const VerificationMeta(
    'approvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> approvedAt = GeneratedColumn<DateTime>(
    'approved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repNameMeta = const VerificationMeta(
    'repName',
  );
  @override
  late final GeneratedColumn<String> repName = GeneratedColumn<String>(
    'rep_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    repId,
    brandId,
    category,
    amount,
    description,
    receiptImagePath,
    uploadedUrl,
    status,
    rejectionReason,
    requiresAdminApproval,
    approvedBy,
    approvedAt,
    repName,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('rep_id')) {
      context.handle(
        _repIdMeta,
        repId.isAcceptableOrUnknown(data['rep_id']!, _repIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
        _receiptImagePathMeta,
        receiptImagePath.isAcceptableOrUnknown(
          data['receipt_image_path']!,
          _receiptImagePathMeta,
        ),
      );
    }
    if (data.containsKey('uploaded_url')) {
      context.handle(
        _uploadedUrlMeta,
        uploadedUrl.isAcceptableOrUnknown(
          data['uploaded_url']!,
          _uploadedUrlMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
        _rejectionReasonMeta,
        rejectionReason.isAcceptableOrUnknown(
          data['rejection_reason']!,
          _rejectionReasonMeta,
        ),
      );
    }
    if (data.containsKey('requires_admin_approval')) {
      context.handle(
        _requiresAdminApprovalMeta,
        requiresAdminApproval.isAcceptableOrUnknown(
          data['requires_admin_approval']!,
          _requiresAdminApprovalMeta,
        ),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('approved_at')) {
      context.handle(
        _approvedAtMeta,
        approvedAt.isAcceptableOrUnknown(data['approved_at']!, _approvedAtMeta),
      );
    }
    if (data.containsKey('rep_name')) {
      context.handle(
        _repNameMeta,
        repName.isAcceptableOrUnknown(data['rep_name']!, _repNameMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      repId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      receiptImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_path'],
      ),
      uploadedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rejectionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_reason'],
      ),
      requiresAdminApproval: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_admin_approval'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}approved_at'],
      ),
      repName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_name'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalExpensesTable createAlias(String alias) {
    return $LocalExpensesTable(attachedDatabase, alias);
  }
}

class LocalExpense extends DataClass implements Insertable<LocalExpense> {
  final String id;
  final String? visitId;
  final String repId;
  final String? brandId;
  final String category;
  final double amount;
  final String? description;
  final String? receiptImagePath;
  final String? uploadedUrl;
  final String status;
  final String? rejectionReason;
  final bool requiresAdminApproval;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? repName;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalExpense({
    required this.id,
    this.visitId,
    required this.repId,
    this.brandId,
    required this.category,
    required this.amount,
    this.description,
    this.receiptImagePath,
    this.uploadedUrl,
    required this.status,
    this.rejectionReason,
    required this.requiresAdminApproval,
    this.approvedBy,
    this.approvedAt,
    this.repName,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['rep_id'] = Variable<String>(repId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    if (!nullToAbsent || uploadedUrl != null) {
      map['uploaded_url'] = Variable<String>(uploadedUrl);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['requires_admin_approval'] = Variable<bool>(requiresAdminApproval);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<DateTime>(approvedAt);
    }
    if (!nullToAbsent || repName != null) {
      map['rep_name'] = Variable<String>(repName);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalExpensesCompanion toCompanion(bool nullToAbsent) {
    return LocalExpensesCompanion(
      id: Value(id),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      repId: Value(repId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
      uploadedUrl: uploadedUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedUrl),
      status: Value(status),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      requiresAdminApproval: Value(requiresAdminApproval),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      repName: repName == null && nullToAbsent
          ? const Value.absent()
          : Value(repName),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpense(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      repId: serializer.fromJson<String>(json['repId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
      uploadedUrl: serializer.fromJson<String?>(json['uploadedUrl']),
      status: serializer.fromJson<String>(json['status']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      requiresAdminApproval: serializer.fromJson<bool>(
        json['requiresAdminApproval'],
      ),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedAt: serializer.fromJson<DateTime?>(json['approvedAt']),
      repName: serializer.fromJson<String?>(json['repName']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String?>(visitId),
      'repId': serializer.toJson<String>(repId),
      'brandId': serializer.toJson<String?>(brandId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
      'uploadedUrl': serializer.toJson<String?>(uploadedUrl),
      'status': serializer.toJson<String>(status),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'requiresAdminApproval': serializer.toJson<bool>(requiresAdminApproval),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedAt': serializer.toJson<DateTime?>(approvedAt),
      'repName': serializer.toJson<String?>(repName),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalExpense copyWith({
    String? id,
    Value<String?> visitId = const Value.absent(),
    String? repId,
    Value<String?> brandId = const Value.absent(),
    String? category,
    double? amount,
    Value<String?> description = const Value.absent(),
    Value<String?> receiptImagePath = const Value.absent(),
    Value<String?> uploadedUrl = const Value.absent(),
    String? status,
    Value<String?> rejectionReason = const Value.absent(),
    bool? requiresAdminApproval,
    Value<String?> approvedBy = const Value.absent(),
    Value<DateTime?> approvedAt = const Value.absent(),
    Value<String?> repName = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalExpense(
    id: id ?? this.id,
    visitId: visitId.present ? visitId.value : this.visitId,
    repId: repId ?? this.repId,
    brandId: brandId.present ? brandId.value : this.brandId,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    receiptImagePath: receiptImagePath.present
        ? receiptImagePath.value
        : this.receiptImagePath,
    uploadedUrl: uploadedUrl.present ? uploadedUrl.value : this.uploadedUrl,
    status: status ?? this.status,
    rejectionReason: rejectionReason.present
        ? rejectionReason.value
        : this.rejectionReason,
    requiresAdminApproval: requiresAdminApproval ?? this.requiresAdminApproval,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
    repName: repName.present ? repName.value : this.repName,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalExpense copyWithCompanion(LocalExpensesCompanion data) {
    return LocalExpense(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      repId: data.repId.present ? data.repId.value : this.repId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
      uploadedUrl: data.uploadedUrl.present
          ? data.uploadedUrl.value
          : this.uploadedUrl,
      status: data.status.present ? data.status.value : this.status,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      requiresAdminApproval: data.requiresAdminApproval.present
          ? data.requiresAdminApproval.value
          : this.requiresAdminApproval,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      approvedAt: data.approvedAt.present
          ? data.approvedAt.value
          : this.approvedAt,
      repName: data.repName.present ? data.repName.value : this.repName,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpense(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('status: $status, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('requiresAdminApproval: $requiresAdminApproval, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('repName: $repName, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    repId,
    brandId,
    category,
    amount,
    description,
    receiptImagePath,
    uploadedUrl,
    status,
    rejectionReason,
    requiresAdminApproval,
    approvedBy,
    approvedAt,
    repName,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpense &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.repId == this.repId &&
          other.brandId == this.brandId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.receiptImagePath == this.receiptImagePath &&
          other.uploadedUrl == this.uploadedUrl &&
          other.status == this.status &&
          other.rejectionReason == this.rejectionReason &&
          other.requiresAdminApproval == this.requiresAdminApproval &&
          other.approvedBy == this.approvedBy &&
          other.approvedAt == this.approvedAt &&
          other.repName == this.repName &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalExpensesCompanion extends UpdateCompanion<LocalExpense> {
  final Value<String> id;
  final Value<String?> visitId;
  final Value<String> repId;
  final Value<String?> brandId;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  final Value<String?> receiptImagePath;
  final Value<String?> uploadedUrl;
  final Value<String> status;
  final Value<String?> rejectionReason;
  final Value<bool> requiresAdminApproval;
  final Value<String?> approvedBy;
  final Value<DateTime?> approvedAt;
  final Value<String?> repName;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalExpensesCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.repId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.uploadedUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.requiresAdminApproval = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.repName = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpensesCompanion.insert({
    required String id,
    this.visitId = const Value.absent(),
    required String repId,
    this.brandId = const Value.absent(),
    required String category,
    required double amount,
    this.description = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.uploadedUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.requiresAdminApproval = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.repName = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repId = Value(repId),
       category = Value(category),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<LocalExpense> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? repId,
    Expression<String>? brandId,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<String>? receiptImagePath,
    Expression<String>? uploadedUrl,
    Expression<String>? status,
    Expression<String>? rejectionReason,
    Expression<bool>? requiresAdminApproval,
    Expression<String>? approvedBy,
    Expression<DateTime>? approvedAt,
    Expression<String>? repName,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (repId != null) 'rep_id': repId,
      if (brandId != null) 'brand_id': brandId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (uploadedUrl != null) 'uploaded_url': uploadedUrl,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (requiresAdminApproval != null)
        'requires_admin_approval': requiresAdminApproval,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (repName != null) 'rep_name': repName,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpensesCompanion copyWith({
    Value<String>? id,
    Value<String?>? visitId,
    Value<String>? repId,
    Value<String?>? brandId,
    Value<String>? category,
    Value<double>? amount,
    Value<String?>? description,
    Value<String?>? receiptImagePath,
    Value<String?>? uploadedUrl,
    Value<String>? status,
    Value<String?>? rejectionReason,
    Value<bool>? requiresAdminApproval,
    Value<String?>? approvedBy,
    Value<DateTime?>? approvedAt,
    Value<String?>? repName,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalExpensesCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      repId: repId ?? this.repId,
      brandId: brandId ?? this.brandId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requiresAdminApproval:
          requiresAdminApproval ?? this.requiresAdminApproval,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      repName: repName ?? this.repName,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (repId.present) {
      map['rep_id'] = Variable<String>(repId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    if (uploadedUrl.present) {
      map['uploaded_url'] = Variable<String>(uploadedUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (requiresAdminApproval.present) {
      map['requires_admin_approval'] = Variable<bool>(
        requiresAdminApproval.value,
      );
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<DateTime>(approvedAt.value);
    }
    if (repName.present) {
      map['rep_name'] = Variable<String>(repName.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpensesCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('uploadedUrl: $uploadedUrl, ')
          ..write('status: $status, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('requiresAdminApproval: $requiresAdminApproval, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('repName: $repName, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSpecialRequestsTable extends LocalSpecialRequests
    with TableInfo<$LocalSpecialRequestsTable, LocalSpecialRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSpecialRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestTypeMeta = const VerificationMeta(
    'requestType',
  );
  @override
  late final GeneratedColumn<String> requestType = GeneratedColumn<String>(
    'request_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    requestType,
    description,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_special_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSpecialRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('request_type')) {
      context.handle(
        _requestTypeMeta,
        requestType.isAcceptableOrUnknown(
          data['request_type']!,
          _requestTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSpecialRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSpecialRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      requestType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
    );
  }

  @override
  $LocalSpecialRequestsTable createAlias(String alias) {
    return $LocalSpecialRequestsTable(attachedDatabase, alias);
  }
}

class LocalSpecialRequest extends DataClass
    implements Insertable<LocalSpecialRequest> {
  final String id;
  final String? visitId;
  final String requestType;
  final String? description;
  final bool synced;
  final DateTime createdAt;
  final String? syncError;
  final bool isAbandoned;
  const LocalSpecialRequest({
    required this.id,
    this.visitId,
    required this.requestType,
    this.description,
    required this.synced,
    required this.createdAt,
    this.syncError,
    required this.isAbandoned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['request_type'] = Variable<String>(requestType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    return map;
  }

  LocalSpecialRequestsCompanion toCompanion(bool nullToAbsent) {
    return LocalSpecialRequestsCompanion(
      id: Value(id),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      requestType: Value(requestType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      synced: Value(synced),
      createdAt: Value(createdAt),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
    );
  }

  factory LocalSpecialRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSpecialRequest(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      requestType: serializer.fromJson<String>(json['requestType']),
      description: serializer.fromJson<String?>(json['description']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String?>(visitId),
      'requestType': serializer.toJson<String>(requestType),
      'description': serializer.toJson<String?>(description),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
    };
  }

  LocalSpecialRequest copyWith({
    String? id,
    Value<String?> visitId = const Value.absent(),
    String? requestType,
    Value<String?> description = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
  }) => LocalSpecialRequest(
    id: id ?? this.id,
    visitId: visitId.present ? visitId.value : this.visitId,
    requestType: requestType ?? this.requestType,
    description: description.present ? description.value : this.description,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
  );
  LocalSpecialRequest copyWithCompanion(LocalSpecialRequestsCompanion data) {
    return LocalSpecialRequest(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      requestType: data.requestType.present
          ? data.requestType.value
          : this.requestType,
      description: data.description.present
          ? data.description.value
          : this.description,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSpecialRequest(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('requestType: $requestType, ')
          ..write('description: $description, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    requestType,
    description,
    synced,
    createdAt,
    syncError,
    isAbandoned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSpecialRequest &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.requestType == this.requestType &&
          other.description == this.description &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned);
}

class LocalSpecialRequestsCompanion
    extends UpdateCompanion<LocalSpecialRequest> {
  final Value<String> id;
  final Value<String?> visitId;
  final Value<String> requestType;
  final Value<String?> description;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<int> rowid;
  const LocalSpecialRequestsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.requestType = const Value.absent(),
    this.description = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSpecialRequestsCompanion.insert({
    required String id,
    this.visitId = const Value.absent(),
    required String requestType,
    this.description = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       requestType = Value(requestType),
       createdAt = Value(createdAt);
  static Insertable<LocalSpecialRequest> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? requestType,
    Expression<String>? description,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (requestType != null) 'request_type': requestType,
      if (description != null) 'description': description,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSpecialRequestsCompanion copyWith({
    Value<String>? id,
    Value<String?>? visitId,
    Value<String>? requestType,
    Value<String?>? description,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<int>? rowid,
  }) {
    return LocalSpecialRequestsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      requestType: requestType ?? this.requestType,
      description: description ?? this.description,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (requestType.present) {
      map['request_type'] = Variable<String>(requestType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSpecialRequestsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('requestType: $requestType, ')
          ..write('description: $description, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalClientsTable extends LocalClients
    with TableInfo<$LocalClientsTable, LocalClient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientTypeMeta = const VerificationMeta(
    'clientType',
  );
  @override
  late final GeneratedColumn<String> clientType = GeneratedColumn<String>(
    'client_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('doctor'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _repIdMeta = const VerificationMeta('repId');
  @override
  late final GeneratedColumn<String> repId = GeneratedColumn<String>(
    'rep_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _facilityNameMeta = const VerificationMeta(
    'facilityName',
  );
  @override
  late final GeneratedColumn<String> facilityName = GeneratedColumn<String>(
    'facility_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _facilityTypeMeta = const VerificationMeta(
    'facilityType',
  );
  @override
  late final GeneratedColumn<String> facilityType = GeneratedColumn<String>(
    'facility_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specialtyMeta = const VerificationMeta(
    'specialty',
  );
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
    'specialty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classTierMeta = const VerificationMeta(
    'classTier',
  );
  @override
  late final GeneratedColumn<String> classTier = GeneratedColumn<String>(
    'class_tier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relationshipTypeMeta = const VerificationMeta(
    'relationshipType',
  );
  @override
  late final GeneratedColumn<String> relationshipType = GeneratedColumn<String>(
    'relationship_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nearbyLandmarkMeta = const VerificationMeta(
    'nearbyLandmark',
  );
  @override
  late final GeneratedColumn<String> nearbyLandmark = GeneratedColumn<String>(
    'nearby_landmark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAbandonedMeta = const VerificationMeta(
    'isAbandoned',
  );
  @override
  late final GeneratedColumn<bool> isAbandoned = GeneratedColumn<bool>(
    'is_abandoned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_abandoned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _treatmentQualityMeta = const VerificationMeta(
    'treatmentQuality',
  );
  @override
  late final GeneratedColumn<String> treatmentQuality = GeneratedColumn<String>(
    'treatment_quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scientificInterestsMeta =
      const VerificationMeta('scientificInterests');
  @override
  late final GeneratedColumn<String> scientificInterests =
      GeneratedColumn<String>(
        'scientific_interests',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _productInterestsMeta = const VerificationMeta(
    'productInterests',
  );
  @override
  late final GeneratedColumn<String> productInterests = GeneratedColumn<String>(
    'product_interests',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pharmacyTypeMeta = const VerificationMeta(
    'pharmacyType',
  );
  @override
  late final GeneratedColumn<String> pharmacyType = GeneratedColumn<String>(
    'pharmacy_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _institutionTypeMeta = const VerificationMeta(
    'institutionType',
  );
  @override
  late final GeneratedColumn<String> institutionType = GeneratedColumn<String>(
    'institution_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyContactNameMeta = const VerificationMeta(
    'keyContactName',
  );
  @override
  late final GeneratedColumn<String> keyContactName = GeneratedColumn<String>(
    'key_contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyContactPositionMeta =
      const VerificationMeta('keyContactPosition');
  @override
  late final GeneratedColumn<String> keyContactPosition =
      GeneratedColumn<String>(
        'key_contact_position',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _keyContactPhoneMeta = const VerificationMeta(
    'keyContactPhone',
  );
  @override
  late final GeneratedColumn<String> keyContactPhone = GeneratedColumn<String>(
    'key_contact_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentsMeta = const VerificationMeta(
    'departments',
  );
  @override
  late final GeneratedColumn<String> departments = GeneratedColumn<String>(
    'departments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientType,
    status,
    repId,
    brandId,
    facilityName,
    facilityType,
    doctorName,
    specialty,
    birthDate,
    classTier,
    relationshipType,
    description,
    phoneNumber,
    region,
    area,
    street,
    nearbyLandmark,
    latitude,
    longitude,
    photoUrl,
    createdAt,
    updatedAt,
    synced,
    syncError,
    isAbandoned,
    gender,
    rating,
    treatmentQuality,
    scientificInterests,
    productInterests,
    pharmacyType,
    institutionType,
    keyContactName,
    keyContactPosition,
    keyContactPhone,
    departments,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalClient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_type')) {
      context.handle(
        _clientTypeMeta,
        clientType.isAcceptableOrUnknown(data['client_type']!, _clientTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('rep_id')) {
      context.handle(
        _repIdMeta,
        repId.isAcceptableOrUnknown(data['rep_id']!, _repIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('facility_name')) {
      context.handle(
        _facilityNameMeta,
        facilityName.isAcceptableOrUnknown(
          data['facility_name']!,
          _facilityNameMeta,
        ),
      );
    }
    if (data.containsKey('facility_type')) {
      context.handle(
        _facilityTypeMeta,
        facilityType.isAcceptableOrUnknown(
          data['facility_type']!,
          _facilityTypeMeta,
        ),
      );
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    }
    if (data.containsKey('specialty')) {
      context.handle(
        _specialtyMeta,
        specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('class_tier')) {
      context.handle(
        _classTierMeta,
        classTier.isAcceptableOrUnknown(data['class_tier']!, _classTierMeta),
      );
    }
    if (data.containsKey('relationship_type')) {
      context.handle(
        _relationshipTypeMeta,
        relationshipType.isAcceptableOrUnknown(
          data['relationship_type']!,
          _relationshipTypeMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    }
    if (data.containsKey('nearby_landmark')) {
      context.handle(
        _nearbyLandmarkMeta,
        nearbyLandmark.isAcceptableOrUnknown(
          data['nearby_landmark']!,
          _nearbyLandmarkMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('is_abandoned')) {
      context.handle(
        _isAbandonedMeta,
        isAbandoned.isAcceptableOrUnknown(
          data['is_abandoned']!,
          _isAbandonedMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('treatment_quality')) {
      context.handle(
        _treatmentQualityMeta,
        treatmentQuality.isAcceptableOrUnknown(
          data['treatment_quality']!,
          _treatmentQualityMeta,
        ),
      );
    }
    if (data.containsKey('scientific_interests')) {
      context.handle(
        _scientificInterestsMeta,
        scientificInterests.isAcceptableOrUnknown(
          data['scientific_interests']!,
          _scientificInterestsMeta,
        ),
      );
    }
    if (data.containsKey('product_interests')) {
      context.handle(
        _productInterestsMeta,
        productInterests.isAcceptableOrUnknown(
          data['product_interests']!,
          _productInterestsMeta,
        ),
      );
    }
    if (data.containsKey('pharmacy_type')) {
      context.handle(
        _pharmacyTypeMeta,
        pharmacyType.isAcceptableOrUnknown(
          data['pharmacy_type']!,
          _pharmacyTypeMeta,
        ),
      );
    }
    if (data.containsKey('institution_type')) {
      context.handle(
        _institutionTypeMeta,
        institutionType.isAcceptableOrUnknown(
          data['institution_type']!,
          _institutionTypeMeta,
        ),
      );
    }
    if (data.containsKey('key_contact_name')) {
      context.handle(
        _keyContactNameMeta,
        keyContactName.isAcceptableOrUnknown(
          data['key_contact_name']!,
          _keyContactNameMeta,
        ),
      );
    }
    if (data.containsKey('key_contact_position')) {
      context.handle(
        _keyContactPositionMeta,
        keyContactPosition.isAcceptableOrUnknown(
          data['key_contact_position']!,
          _keyContactPositionMeta,
        ),
      );
    }
    if (data.containsKey('key_contact_phone')) {
      context.handle(
        _keyContactPhoneMeta,
        keyContactPhone.isAcceptableOrUnknown(
          data['key_contact_phone']!,
          _keyContactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('departments')) {
      context.handle(
        _departmentsMeta,
        departments.isAcceptableOrUnknown(
          data['departments']!,
          _departmentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalClient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalClient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      repId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rep_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      facilityName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facility_name'],
      ),
      facilityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facility_type'],
      ),
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      ),
      specialty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialty'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      classTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_tier'],
      ),
      relationshipType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_type'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      ),
      nearbyLandmark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nearby_landmark'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      isAbandoned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_abandoned'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      treatmentQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}treatment_quality'],
      ),
      scientificInterests: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_interests'],
      ),
      productInterests: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_interests'],
      ),
      pharmacyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pharmacy_type'],
      ),
      institutionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_type'],
      ),
      keyContactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_contact_name'],
      ),
      keyContactPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_contact_position'],
      ),
      keyContactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_contact_phone'],
      ),
      departments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departments'],
      ),
    );
  }

  @override
  $LocalClientsTable createAlias(String alias) {
    return $LocalClientsTable(attachedDatabase, alias);
  }
}

class LocalClient extends DataClass implements Insertable<LocalClient> {
  final String id;
  final String clientType;
  final String status;
  final String repId;
  final String? brandId;
  final String? facilityName;
  final String? facilityType;
  final String? doctorName;
  final String? specialty;
  final DateTime? birthDate;
  final String? classTier;
  final String? relationshipType;
  final String? description;
  final String? phoneNumber;
  final String? region;
  final String? area;
  final String? street;
  final String? nearbyLandmark;
  final double? latitude;
  final double? longitude;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;
  final String? syncError;
  final bool isAbandoned;
  final String? gender;
  final int? rating;
  final String? treatmentQuality;
  final String? scientificInterests;
  final String? productInterests;
  final String? pharmacyType;
  final String? institutionType;
  final String? keyContactName;
  final String? keyContactPosition;
  final String? keyContactPhone;
  final String? departments;
  const LocalClient({
    required this.id,
    required this.clientType,
    required this.status,
    required this.repId,
    this.brandId,
    this.facilityName,
    this.facilityType,
    this.doctorName,
    this.specialty,
    this.birthDate,
    this.classTier,
    this.relationshipType,
    this.description,
    this.phoneNumber,
    this.region,
    this.area,
    this.street,
    this.nearbyLandmark,
    this.latitude,
    this.longitude,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
    this.syncError,
    required this.isAbandoned,
    this.gender,
    this.rating,
    this.treatmentQuality,
    this.scientificInterests,
    this.productInterests,
    this.pharmacyType,
    this.institutionType,
    this.keyContactName,
    this.keyContactPosition,
    this.keyContactPhone,
    this.departments,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_type'] = Variable<String>(clientType);
    map['status'] = Variable<String>(status);
    map['rep_id'] = Variable<String>(repId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || facilityName != null) {
      map['facility_name'] = Variable<String>(facilityName);
    }
    if (!nullToAbsent || facilityType != null) {
      map['facility_type'] = Variable<String>(facilityType);
    }
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || classTier != null) {
      map['class_tier'] = Variable<String>(classTier);
    }
    if (!nullToAbsent || relationshipType != null) {
      map['relationship_type'] = Variable<String>(relationshipType);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || nearbyLandmark != null) {
      map['nearby_landmark'] = Variable<String>(nearbyLandmark);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['is_abandoned'] = Variable<bool>(isAbandoned);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || treatmentQuality != null) {
      map['treatment_quality'] = Variable<String>(treatmentQuality);
    }
    if (!nullToAbsent || scientificInterests != null) {
      map['scientific_interests'] = Variable<String>(scientificInterests);
    }
    if (!nullToAbsent || productInterests != null) {
      map['product_interests'] = Variable<String>(productInterests);
    }
    if (!nullToAbsent || pharmacyType != null) {
      map['pharmacy_type'] = Variable<String>(pharmacyType);
    }
    if (!nullToAbsent || institutionType != null) {
      map['institution_type'] = Variable<String>(institutionType);
    }
    if (!nullToAbsent || keyContactName != null) {
      map['key_contact_name'] = Variable<String>(keyContactName);
    }
    if (!nullToAbsent || keyContactPosition != null) {
      map['key_contact_position'] = Variable<String>(keyContactPosition);
    }
    if (!nullToAbsent || keyContactPhone != null) {
      map['key_contact_phone'] = Variable<String>(keyContactPhone);
    }
    if (!nullToAbsent || departments != null) {
      map['departments'] = Variable<String>(departments);
    }
    return map;
  }

  LocalClientsCompanion toCompanion(bool nullToAbsent) {
    return LocalClientsCompanion(
      id: Value(id),
      clientType: Value(clientType),
      status: Value(status),
      repId: Value(repId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      facilityName: facilityName == null && nullToAbsent
          ? const Value.absent()
          : Value(facilityName),
      facilityType: facilityType == null && nullToAbsent
          ? const Value.absent()
          : Value(facilityType),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      classTier: classTier == null && nullToAbsent
          ? const Value.absent()
          : Value(classTier),
      relationshipType: relationshipType == null && nullToAbsent
          ? const Value.absent()
          : Value(relationshipType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      street: street == null && nullToAbsent
          ? const Value.absent()
          : Value(street),
      nearbyLandmark: nearbyLandmark == null && nullToAbsent
          ? const Value.absent()
          : Value(nearbyLandmark),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      isAbandoned: Value(isAbandoned),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      treatmentQuality: treatmentQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(treatmentQuality),
      scientificInterests: scientificInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(scientificInterests),
      productInterests: productInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(productInterests),
      pharmacyType: pharmacyType == null && nullToAbsent
          ? const Value.absent()
          : Value(pharmacyType),
      institutionType: institutionType == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionType),
      keyContactName: keyContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(keyContactName),
      keyContactPosition: keyContactPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(keyContactPosition),
      keyContactPhone: keyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(keyContactPhone),
      departments: departments == null && nullToAbsent
          ? const Value.absent()
          : Value(departments),
    );
  }

  factory LocalClient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalClient(
      id: serializer.fromJson<String>(json['id']),
      clientType: serializer.fromJson<String>(json['clientType']),
      status: serializer.fromJson<String>(json['status']),
      repId: serializer.fromJson<String>(json['repId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      facilityName: serializer.fromJson<String?>(json['facilityName']),
      facilityType: serializer.fromJson<String?>(json['facilityType']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      classTier: serializer.fromJson<String?>(json['classTier']),
      relationshipType: serializer.fromJson<String?>(json['relationshipType']),
      description: serializer.fromJson<String?>(json['description']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      region: serializer.fromJson<String?>(json['region']),
      area: serializer.fromJson<String?>(json['area']),
      street: serializer.fromJson<String?>(json['street']),
      nearbyLandmark: serializer.fromJson<String?>(json['nearbyLandmark']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      isAbandoned: serializer.fromJson<bool>(json['isAbandoned']),
      gender: serializer.fromJson<String?>(json['gender']),
      rating: serializer.fromJson<int?>(json['rating']),
      treatmentQuality: serializer.fromJson<String?>(json['treatmentQuality']),
      scientificInterests: serializer.fromJson<String?>(
        json['scientificInterests'],
      ),
      productInterests: serializer.fromJson<String?>(json['productInterests']),
      pharmacyType: serializer.fromJson<String?>(json['pharmacyType']),
      institutionType: serializer.fromJson<String?>(json['institutionType']),
      keyContactName: serializer.fromJson<String?>(json['keyContactName']),
      keyContactPosition: serializer.fromJson<String?>(
        json['keyContactPosition'],
      ),
      keyContactPhone: serializer.fromJson<String?>(json['keyContactPhone']),
      departments: serializer.fromJson<String?>(json['departments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientType': serializer.toJson<String>(clientType),
      'status': serializer.toJson<String>(status),
      'repId': serializer.toJson<String>(repId),
      'brandId': serializer.toJson<String?>(brandId),
      'facilityName': serializer.toJson<String?>(facilityName),
      'facilityType': serializer.toJson<String?>(facilityType),
      'doctorName': serializer.toJson<String?>(doctorName),
      'specialty': serializer.toJson<String?>(specialty),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'classTier': serializer.toJson<String?>(classTier),
      'relationshipType': serializer.toJson<String?>(relationshipType),
      'description': serializer.toJson<String?>(description),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'region': serializer.toJson<String?>(region),
      'area': serializer.toJson<String?>(area),
      'street': serializer.toJson<String?>(street),
      'nearbyLandmark': serializer.toJson<String?>(nearbyLandmark),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
      'syncError': serializer.toJson<String?>(syncError),
      'isAbandoned': serializer.toJson<bool>(isAbandoned),
      'gender': serializer.toJson<String?>(gender),
      'rating': serializer.toJson<int?>(rating),
      'treatmentQuality': serializer.toJson<String?>(treatmentQuality),
      'scientificInterests': serializer.toJson<String?>(scientificInterests),
      'productInterests': serializer.toJson<String?>(productInterests),
      'pharmacyType': serializer.toJson<String?>(pharmacyType),
      'institutionType': serializer.toJson<String?>(institutionType),
      'keyContactName': serializer.toJson<String?>(keyContactName),
      'keyContactPosition': serializer.toJson<String?>(keyContactPosition),
      'keyContactPhone': serializer.toJson<String?>(keyContactPhone),
      'departments': serializer.toJson<String?>(departments),
    };
  }

  LocalClient copyWith({
    String? id,
    String? clientType,
    String? status,
    String? repId,
    Value<String?> brandId = const Value.absent(),
    Value<String?> facilityName = const Value.absent(),
    Value<String?> facilityType = const Value.absent(),
    Value<String?> doctorName = const Value.absent(),
    Value<String?> specialty = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> classTier = const Value.absent(),
    Value<String?> relationshipType = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<String?> area = const Value.absent(),
    Value<String?> street = const Value.absent(),
    Value<String?> nearbyLandmark = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    Value<String?> syncError = const Value.absent(),
    bool? isAbandoned,
    Value<String?> gender = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    Value<String?> treatmentQuality = const Value.absent(),
    Value<String?> scientificInterests = const Value.absent(),
    Value<String?> productInterests = const Value.absent(),
    Value<String?> pharmacyType = const Value.absent(),
    Value<String?> institutionType = const Value.absent(),
    Value<String?> keyContactName = const Value.absent(),
    Value<String?> keyContactPosition = const Value.absent(),
    Value<String?> keyContactPhone = const Value.absent(),
    Value<String?> departments = const Value.absent(),
  }) => LocalClient(
    id: id ?? this.id,
    clientType: clientType ?? this.clientType,
    status: status ?? this.status,
    repId: repId ?? this.repId,
    brandId: brandId.present ? brandId.value : this.brandId,
    facilityName: facilityName.present ? facilityName.value : this.facilityName,
    facilityType: facilityType.present ? facilityType.value : this.facilityType,
    doctorName: doctorName.present ? doctorName.value : this.doctorName,
    specialty: specialty.present ? specialty.value : this.specialty,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    classTier: classTier.present ? classTier.value : this.classTier,
    relationshipType: relationshipType.present
        ? relationshipType.value
        : this.relationshipType,
    description: description.present ? description.value : this.description,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    region: region.present ? region.value : this.region,
    area: area.present ? area.value : this.area,
    street: street.present ? street.value : this.street,
    nearbyLandmark: nearbyLandmark.present
        ? nearbyLandmark.value
        : this.nearbyLandmark,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    synced: synced ?? this.synced,
    syncError: syncError.present ? syncError.value : this.syncError,
    isAbandoned: isAbandoned ?? this.isAbandoned,
    gender: gender.present ? gender.value : this.gender,
    rating: rating.present ? rating.value : this.rating,
    treatmentQuality: treatmentQuality.present
        ? treatmentQuality.value
        : this.treatmentQuality,
    scientificInterests: scientificInterests.present
        ? scientificInterests.value
        : this.scientificInterests,
    productInterests: productInterests.present
        ? productInterests.value
        : this.productInterests,
    pharmacyType: pharmacyType.present ? pharmacyType.value : this.pharmacyType,
    institutionType: institutionType.present
        ? institutionType.value
        : this.institutionType,
    keyContactName: keyContactName.present
        ? keyContactName.value
        : this.keyContactName,
    keyContactPosition: keyContactPosition.present
        ? keyContactPosition.value
        : this.keyContactPosition,
    keyContactPhone: keyContactPhone.present
        ? keyContactPhone.value
        : this.keyContactPhone,
    departments: departments.present ? departments.value : this.departments,
  );
  LocalClient copyWithCompanion(LocalClientsCompanion data) {
    return LocalClient(
      id: data.id.present ? data.id.value : this.id,
      clientType: data.clientType.present
          ? data.clientType.value
          : this.clientType,
      status: data.status.present ? data.status.value : this.status,
      repId: data.repId.present ? data.repId.value : this.repId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      facilityName: data.facilityName.present
          ? data.facilityName.value
          : this.facilityName,
      facilityType: data.facilityType.present
          ? data.facilityType.value
          : this.facilityType,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      classTier: data.classTier.present ? data.classTier.value : this.classTier,
      relationshipType: data.relationshipType.present
          ? data.relationshipType.value
          : this.relationshipType,
      description: data.description.present
          ? data.description.value
          : this.description,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      region: data.region.present ? data.region.value : this.region,
      area: data.area.present ? data.area.value : this.area,
      street: data.street.present ? data.street.value : this.street,
      nearbyLandmark: data.nearbyLandmark.present
          ? data.nearbyLandmark.value
          : this.nearbyLandmark,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      isAbandoned: data.isAbandoned.present
          ? data.isAbandoned.value
          : this.isAbandoned,
      gender: data.gender.present ? data.gender.value : this.gender,
      rating: data.rating.present ? data.rating.value : this.rating,
      treatmentQuality: data.treatmentQuality.present
          ? data.treatmentQuality.value
          : this.treatmentQuality,
      scientificInterests: data.scientificInterests.present
          ? data.scientificInterests.value
          : this.scientificInterests,
      productInterests: data.productInterests.present
          ? data.productInterests.value
          : this.productInterests,
      pharmacyType: data.pharmacyType.present
          ? data.pharmacyType.value
          : this.pharmacyType,
      institutionType: data.institutionType.present
          ? data.institutionType.value
          : this.institutionType,
      keyContactName: data.keyContactName.present
          ? data.keyContactName.value
          : this.keyContactName,
      keyContactPosition: data.keyContactPosition.present
          ? data.keyContactPosition.value
          : this.keyContactPosition,
      keyContactPhone: data.keyContactPhone.present
          ? data.keyContactPhone.value
          : this.keyContactPhone,
      departments: data.departments.present
          ? data.departments.value
          : this.departments,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalClient(')
          ..write('id: $id, ')
          ..write('clientType: $clientType, ')
          ..write('status: $status, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('facilityName: $facilityName, ')
          ..write('facilityType: $facilityType, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialty: $specialty, ')
          ..write('birthDate: $birthDate, ')
          ..write('classTier: $classTier, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('description: $description, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('region: $region, ')
          ..write('area: $area, ')
          ..write('street: $street, ')
          ..write('nearbyLandmark: $nearbyLandmark, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('gender: $gender, ')
          ..write('rating: $rating, ')
          ..write('treatmentQuality: $treatmentQuality, ')
          ..write('scientificInterests: $scientificInterests, ')
          ..write('productInterests: $productInterests, ')
          ..write('pharmacyType: $pharmacyType, ')
          ..write('institutionType: $institutionType, ')
          ..write('keyContactName: $keyContactName, ')
          ..write('keyContactPosition: $keyContactPosition, ')
          ..write('keyContactPhone: $keyContactPhone, ')
          ..write('departments: $departments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientType,
    status,
    repId,
    brandId,
    facilityName,
    facilityType,
    doctorName,
    specialty,
    birthDate,
    classTier,
    relationshipType,
    description,
    phoneNumber,
    region,
    area,
    street,
    nearbyLandmark,
    latitude,
    longitude,
    photoUrl,
    createdAt,
    updatedAt,
    synced,
    syncError,
    isAbandoned,
    gender,
    rating,
    treatmentQuality,
    scientificInterests,
    productInterests,
    pharmacyType,
    institutionType,
    keyContactName,
    keyContactPosition,
    keyContactPhone,
    departments,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalClient &&
          other.id == this.id &&
          other.clientType == this.clientType &&
          other.status == this.status &&
          other.repId == this.repId &&
          other.brandId == this.brandId &&
          other.facilityName == this.facilityName &&
          other.facilityType == this.facilityType &&
          other.doctorName == this.doctorName &&
          other.specialty == this.specialty &&
          other.birthDate == this.birthDate &&
          other.classTier == this.classTier &&
          other.relationshipType == this.relationshipType &&
          other.description == this.description &&
          other.phoneNumber == this.phoneNumber &&
          other.region == this.region &&
          other.area == this.area &&
          other.street == this.street &&
          other.nearbyLandmark == this.nearbyLandmark &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.photoUrl == this.photoUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced &&
          other.syncError == this.syncError &&
          other.isAbandoned == this.isAbandoned &&
          other.gender == this.gender &&
          other.rating == this.rating &&
          other.treatmentQuality == this.treatmentQuality &&
          other.scientificInterests == this.scientificInterests &&
          other.productInterests == this.productInterests &&
          other.pharmacyType == this.pharmacyType &&
          other.institutionType == this.institutionType &&
          other.keyContactName == this.keyContactName &&
          other.keyContactPosition == this.keyContactPosition &&
          other.keyContactPhone == this.keyContactPhone &&
          other.departments == this.departments);
}

class LocalClientsCompanion extends UpdateCompanion<LocalClient> {
  final Value<String> id;
  final Value<String> clientType;
  final Value<String> status;
  final Value<String> repId;
  final Value<String?> brandId;
  final Value<String?> facilityName;
  final Value<String?> facilityType;
  final Value<String?> doctorName;
  final Value<String?> specialty;
  final Value<DateTime?> birthDate;
  final Value<String?> classTier;
  final Value<String?> relationshipType;
  final Value<String?> description;
  final Value<String?> phoneNumber;
  final Value<String?> region;
  final Value<String?> area;
  final Value<String?> street;
  final Value<String?> nearbyLandmark;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> photoUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<String?> syncError;
  final Value<bool> isAbandoned;
  final Value<String?> gender;
  final Value<int?> rating;
  final Value<String?> treatmentQuality;
  final Value<String?> scientificInterests;
  final Value<String?> productInterests;
  final Value<String?> pharmacyType;
  final Value<String?> institutionType;
  final Value<String?> keyContactName;
  final Value<String?> keyContactPosition;
  final Value<String?> keyContactPhone;
  final Value<String?> departments;
  final Value<int> rowid;
  const LocalClientsCompanion({
    this.id = const Value.absent(),
    this.clientType = const Value.absent(),
    this.status = const Value.absent(),
    this.repId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.facilityName = const Value.absent(),
    this.facilityType = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.specialty = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.classTier = const Value.absent(),
    this.relationshipType = const Value.absent(),
    this.description = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.region = const Value.absent(),
    this.area = const Value.absent(),
    this.street = const Value.absent(),
    this.nearbyLandmark = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.gender = const Value.absent(),
    this.rating = const Value.absent(),
    this.treatmentQuality = const Value.absent(),
    this.scientificInterests = const Value.absent(),
    this.productInterests = const Value.absent(),
    this.pharmacyType = const Value.absent(),
    this.institutionType = const Value.absent(),
    this.keyContactName = const Value.absent(),
    this.keyContactPosition = const Value.absent(),
    this.keyContactPhone = const Value.absent(),
    this.departments = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalClientsCompanion.insert({
    required String id,
    this.clientType = const Value.absent(),
    this.status = const Value.absent(),
    required String repId,
    this.brandId = const Value.absent(),
    this.facilityName = const Value.absent(),
    this.facilityType = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.specialty = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.classTier = const Value.absent(),
    this.relationshipType = const Value.absent(),
    this.description = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.region = const Value.absent(),
    this.area = const Value.absent(),
    this.street = const Value.absent(),
    this.nearbyLandmark = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.photoUrl = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    this.isAbandoned = const Value.absent(),
    this.gender = const Value.absent(),
    this.rating = const Value.absent(),
    this.treatmentQuality = const Value.absent(),
    this.scientificInterests = const Value.absent(),
    this.productInterests = const Value.absent(),
    this.pharmacyType = const Value.absent(),
    this.institutionType = const Value.absent(),
    this.keyContactName = const Value.absent(),
    this.keyContactPosition = const Value.absent(),
    this.keyContactPhone = const Value.absent(),
    this.departments = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repId = Value(repId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalClient> custom({
    Expression<String>? id,
    Expression<String>? clientType,
    Expression<String>? status,
    Expression<String>? repId,
    Expression<String>? brandId,
    Expression<String>? facilityName,
    Expression<String>? facilityType,
    Expression<String>? doctorName,
    Expression<String>? specialty,
    Expression<DateTime>? birthDate,
    Expression<String>? classTier,
    Expression<String>? relationshipType,
    Expression<String>? description,
    Expression<String>? phoneNumber,
    Expression<String>? region,
    Expression<String>? area,
    Expression<String>? street,
    Expression<String>? nearbyLandmark,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? photoUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<String>? syncError,
    Expression<bool>? isAbandoned,
    Expression<String>? gender,
    Expression<int>? rating,
    Expression<String>? treatmentQuality,
    Expression<String>? scientificInterests,
    Expression<String>? productInterests,
    Expression<String>? pharmacyType,
    Expression<String>? institutionType,
    Expression<String>? keyContactName,
    Expression<String>? keyContactPosition,
    Expression<String>? keyContactPhone,
    Expression<String>? departments,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientType != null) 'client_type': clientType,
      if (status != null) 'status': status,
      if (repId != null) 'rep_id': repId,
      if (brandId != null) 'brand_id': brandId,
      if (facilityName != null) 'facility_name': facilityName,
      if (facilityType != null) 'facility_type': facilityType,
      if (doctorName != null) 'doctor_name': doctorName,
      if (specialty != null) 'specialty': specialty,
      if (birthDate != null) 'birth_date': birthDate,
      if (classTier != null) 'class_tier': classTier,
      if (relationshipType != null) 'relationship_type': relationshipType,
      if (description != null) 'description': description,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (region != null) 'region': region,
      if (area != null) 'area': area,
      if (street != null) 'street': street,
      if (nearbyLandmark != null) 'nearby_landmark': nearbyLandmark,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (syncError != null) 'sync_error': syncError,
      if (isAbandoned != null) 'is_abandoned': isAbandoned,
      if (gender != null) 'gender': gender,
      if (rating != null) 'rating': rating,
      if (treatmentQuality != null) 'treatment_quality': treatmentQuality,
      if (scientificInterests != null)
        'scientific_interests': scientificInterests,
      if (productInterests != null) 'product_interests': productInterests,
      if (pharmacyType != null) 'pharmacy_type': pharmacyType,
      if (institutionType != null) 'institution_type': institutionType,
      if (keyContactName != null) 'key_contact_name': keyContactName,
      if (keyContactPosition != null)
        'key_contact_position': keyContactPosition,
      if (keyContactPhone != null) 'key_contact_phone': keyContactPhone,
      if (departments != null) 'departments': departments,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalClientsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientType,
    Value<String>? status,
    Value<String>? repId,
    Value<String?>? brandId,
    Value<String?>? facilityName,
    Value<String?>? facilityType,
    Value<String?>? doctorName,
    Value<String?>? specialty,
    Value<DateTime?>? birthDate,
    Value<String?>? classTier,
    Value<String?>? relationshipType,
    Value<String?>? description,
    Value<String?>? phoneNumber,
    Value<String?>? region,
    Value<String?>? area,
    Value<String?>? street,
    Value<String?>? nearbyLandmark,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? photoUrl,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? synced,
    Value<String?>? syncError,
    Value<bool>? isAbandoned,
    Value<String?>? gender,
    Value<int?>? rating,
    Value<String?>? treatmentQuality,
    Value<String?>? scientificInterests,
    Value<String?>? productInterests,
    Value<String?>? pharmacyType,
    Value<String?>? institutionType,
    Value<String?>? keyContactName,
    Value<String?>? keyContactPosition,
    Value<String?>? keyContactPhone,
    Value<String?>? departments,
    Value<int>? rowid,
  }) {
    return LocalClientsCompanion(
      id: id ?? this.id,
      clientType: clientType ?? this.clientType,
      status: status ?? this.status,
      repId: repId ?? this.repId,
      brandId: brandId ?? this.brandId,
      facilityName: facilityName ?? this.facilityName,
      facilityType: facilityType ?? this.facilityType,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      birthDate: birthDate ?? this.birthDate,
      classTier: classTier ?? this.classTier,
      relationshipType: relationshipType ?? this.relationshipType,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      region: region ?? this.region,
      area: area ?? this.area,
      street: street ?? this.street,
      nearbyLandmark: nearbyLandmark ?? this.nearbyLandmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      syncError: syncError ?? this.syncError,
      isAbandoned: isAbandoned ?? this.isAbandoned,
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      treatmentQuality: treatmentQuality ?? this.treatmentQuality,
      scientificInterests: scientificInterests ?? this.scientificInterests,
      productInterests: productInterests ?? this.productInterests,
      pharmacyType: pharmacyType ?? this.pharmacyType,
      institutionType: institutionType ?? this.institutionType,
      keyContactName: keyContactName ?? this.keyContactName,
      keyContactPosition: keyContactPosition ?? this.keyContactPosition,
      keyContactPhone: keyContactPhone ?? this.keyContactPhone,
      departments: departments ?? this.departments,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientType.present) {
      map['client_type'] = Variable<String>(clientType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (repId.present) {
      map['rep_id'] = Variable<String>(repId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (facilityName.present) {
      map['facility_name'] = Variable<String>(facilityName.value);
    }
    if (facilityType.present) {
      map['facility_type'] = Variable<String>(facilityType.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (classTier.present) {
      map['class_tier'] = Variable<String>(classTier.value);
    }
    if (relationshipType.present) {
      map['relationship_type'] = Variable<String>(relationshipType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (nearbyLandmark.present) {
      map['nearby_landmark'] = Variable<String>(nearbyLandmark.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (isAbandoned.present) {
      map['is_abandoned'] = Variable<bool>(isAbandoned.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (treatmentQuality.present) {
      map['treatment_quality'] = Variable<String>(treatmentQuality.value);
    }
    if (scientificInterests.present) {
      map['scientific_interests'] = Variable<String>(scientificInterests.value);
    }
    if (productInterests.present) {
      map['product_interests'] = Variable<String>(productInterests.value);
    }
    if (pharmacyType.present) {
      map['pharmacy_type'] = Variable<String>(pharmacyType.value);
    }
    if (institutionType.present) {
      map['institution_type'] = Variable<String>(institutionType.value);
    }
    if (keyContactName.present) {
      map['key_contact_name'] = Variable<String>(keyContactName.value);
    }
    if (keyContactPosition.present) {
      map['key_contact_position'] = Variable<String>(keyContactPosition.value);
    }
    if (keyContactPhone.present) {
      map['key_contact_phone'] = Variable<String>(keyContactPhone.value);
    }
    if (departments.present) {
      map['departments'] = Variable<String>(departments.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalClientsCompanion(')
          ..write('id: $id, ')
          ..write('clientType: $clientType, ')
          ..write('status: $status, ')
          ..write('repId: $repId, ')
          ..write('brandId: $brandId, ')
          ..write('facilityName: $facilityName, ')
          ..write('facilityType: $facilityType, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialty: $specialty, ')
          ..write('birthDate: $birthDate, ')
          ..write('classTier: $classTier, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('description: $description, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('region: $region, ')
          ..write('area: $area, ')
          ..write('street: $street, ')
          ..write('nearbyLandmark: $nearbyLandmark, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('isAbandoned: $isAbandoned, ')
          ..write('gender: $gender, ')
          ..write('rating: $rating, ')
          ..write('treatmentQuality: $treatmentQuality, ')
          ..write('scientificInterests: $scientificInterests, ')
          ..write('productInterests: $productInterests, ')
          ..write('pharmacyType: $pharmacyType, ')
          ..write('institutionType: $institutionType, ')
          ..write('keyContactName: $keyContactName, ')
          ..write('keyContactPosition: $keyContactPosition, ')
          ..write('keyContactPhone: $keyContactPhone, ')
          ..write('departments: $departments, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserSignaturesTable extends LocalUserSignatures
    with TableInfo<$LocalUserSignaturesTable, LocalUserSignature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserSignaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsJsonMeta = const VerificationMeta(
    'pointsJson',
  );
  @override
  late final GeneratedColumn<String> pointsJson = GeneratedColumn<String>(
    'points_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pointsJson,
    imagePath,
    createdAt,
    updatedAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_signatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserSignature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('points_json')) {
      context.handle(
        _pointsJsonMeta,
        pointsJson.isAcceptableOrUnknown(data['points_json']!, _pointsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsJsonMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserSignature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserSignature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pointsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}points_json'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $LocalUserSignaturesTable createAlias(String alias) {
    return $LocalUserSignaturesTable(attachedDatabase, alias);
  }
}

class LocalUserSignature extends DataClass
    implements Insertable<LocalUserSignature> {
  final String id;
  final String pointsJson;
  final String imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;
  const LocalUserSignature({
    required this.id,
    required this.pointsJson,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['points_json'] = Variable<String>(pointsJson);
    map['image_path'] = Variable<String>(imagePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  LocalUserSignaturesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserSignaturesCompanion(
      id: Value(id),
      pointsJson: Value(pointsJson),
      imagePath: Value(imagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
    );
  }

  factory LocalUserSignature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserSignature(
      id: serializer.fromJson<String>(json['id']),
      pointsJson: serializer.fromJson<String>(json['pointsJson']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pointsJson': serializer.toJson<String>(pointsJson),
      'imagePath': serializer.toJson<String>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  LocalUserSignature copyWith({
    String? id,
    String? pointsJson,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) => LocalUserSignature(
    id: id ?? this.id,
    pointsJson: pointsJson ?? this.pointsJson,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    synced: synced ?? this.synced,
  );
  LocalUserSignature copyWithCompanion(LocalUserSignaturesCompanion data) {
    return LocalUserSignature(
      id: data.id.present ? data.id.value : this.id,
      pointsJson: data.pointsJson.present
          ? data.pointsJson.value
          : this.pointsJson,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserSignature(')
          ..write('id: $id, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pointsJson, imagePath, createdAt, updatedAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserSignature &&
          other.id == this.id &&
          other.pointsJson == this.pointsJson &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced);
}

class LocalUserSignaturesCompanion extends UpdateCompanion<LocalUserSignature> {
  final Value<String> id;
  final Value<String> pointsJson;
  final Value<String> imagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const LocalUserSignaturesCompanion({
    this.id = const Value.absent(),
    this.pointsJson = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserSignaturesCompanion.insert({
    required String id,
    required String pointsJson,
    required String imagePath,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pointsJson = Value(pointsJson),
       imagePath = Value(imagePath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalUserSignature> custom({
    Expression<String>? id,
    Expression<String>? pointsJson,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pointsJson != null) 'points_json': pointsJson,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserSignaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? pointsJson,
    Value<String>? imagePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return LocalUserSignaturesCompanion(
      id: id ?? this.id,
      pointsJson: pointsJson ?? this.pointsJson,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pointsJson.present) {
      map['points_json'] = Variable<String>(pointsJson.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserSignaturesCompanion(')
          ..write('id: $id, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalVisitsTable localVisits = $LocalVisitsTable(this);
  late final $LocalVisitItemsTable localVisitItems = $LocalVisitItemsTable(
    this,
  );
  late final $LocalPharmacyStockChecksTable localPharmacyStockChecks =
      $LocalPharmacyStockChecksTable(this);
  late final $LocalCentersTable localCenters = $LocalCentersTable(this);
  late final $LocalAppointmentsTable localAppointments =
      $LocalAppointmentsTable(this);
  late final $LocalNotificationsTable localNotifications =
      $LocalNotificationsTable(this);
  late final $LocalProductsTable localProducts = $LocalProductsTable(this);
  late final $LocalVisitPhotosTable localVisitPhotos = $LocalVisitPhotosTable(
    this,
  );
  late final $LocalFieldReportsTable localFieldReports =
      $LocalFieldReportsTable(this);
  late final $LocalExpensesTable localExpenses = $LocalExpensesTable(this);
  late final $LocalSpecialRequestsTable localSpecialRequests =
      $LocalSpecialRequestsTable(this);
  late final $LocalClientsTable localClients = $LocalClientsTable(this);
  late final $LocalUserSignaturesTable localUserSignatures =
      $LocalUserSignaturesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localVisits,
    localVisitItems,
    localPharmacyStockChecks,
    localCenters,
    localAppointments,
    localNotifications,
    localProducts,
    localVisitPhotos,
    localFieldReports,
    localExpenses,
    localSpecialRequests,
    localClients,
    localUserSignatures,
  ];
}

typedef $$LocalVisitsTableCreateCompanionBuilder =
    LocalVisitsCompanion Function({
      required String id,
      Value<String?> referenceCode,
      required String repId,
      Value<String?> brandId,
      required String centerId,
      Value<String?> appointmentId,
      required DateTime visitDate,
      Value<DateTime?> arrivalTime,
      Value<DateTime?> completionTime,
      required String status,
      Value<String?> notes,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isFlagged,
      Value<String?> supervisorNote,
      Value<String?> signaturePath,
      Value<String?> signatureUrl,
      Value<String?> retroactiveReason,
      Value<double?> saveLocationLat,
      Value<double?> saveLocationLng,
      Value<bool> synced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<String?> clientId,
      Value<String> visitType,
      Value<String?> visitReason,
      Value<String?> interestedProductIds,
      Value<String?> taskId,
      Value<int> rowid,
    });
typedef $$LocalVisitsTableUpdateCompanionBuilder =
    LocalVisitsCompanion Function({
      Value<String> id,
      Value<String?> referenceCode,
      Value<String> repId,
      Value<String?> brandId,
      Value<String> centerId,
      Value<String?> appointmentId,
      Value<DateTime> visitDate,
      Value<DateTime?> arrivalTime,
      Value<DateTime?> completionTime,
      Value<String> status,
      Value<String?> notes,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isFlagged,
      Value<String?> supervisorNote,
      Value<String?> signaturePath,
      Value<String?> signatureUrl,
      Value<String?> retroactiveReason,
      Value<double?> saveLocationLat,
      Value<double?> saveLocationLng,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<String?> clientId,
      Value<String> visitType,
      Value<String?> visitReason,
      Value<String?> interestedProductIds,
      Value<String?> taskId,
      Value<int> rowid,
    });

class $$LocalVisitsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get centerId => $composableBuilder(
    column: $table.centerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFlagged => $composableBuilder(
    column: $table.isFlagged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signatureUrl => $composableBuilder(
    column: $table.signatureUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get retroactiveReason => $composableBuilder(
    column: $table.retroactiveReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saveLocationLat => $composableBuilder(
    column: $table.saveLocationLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saveLocationLng => $composableBuilder(
    column: $table.saveLocationLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitType => $composableBuilder(
    column: $table.visitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitReason => $composableBuilder(
    column: $table.visitReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interestedProductIds => $composableBuilder(
    column: $table.interestedProductIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get centerId => $composableBuilder(
    column: $table.centerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFlagged => $composableBuilder(
    column: $table.isFlagged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signatureUrl => $composableBuilder(
    column: $table.signatureUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get retroactiveReason => $composableBuilder(
    column: $table.retroactiveReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saveLocationLat => $composableBuilder(
    column: $table.saveLocationLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saveLocationLng => $composableBuilder(
    column: $table.saveLocationLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitType => $composableBuilder(
    column: $table.visitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitReason => $composableBuilder(
    column: $table.visitReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interestedProductIds => $composableBuilder(
    column: $table.interestedProductIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repId =>
      $composableBuilder(column: $table.repId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get centerId =>
      $composableBuilder(column: $table.centerId, builder: (column) => column);

  GeneratedColumn<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get visitDate =>
      $composableBuilder(column: $table.visitDate, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isFlagged =>
      $composableBuilder(column: $table.isFlagged, builder: (column) => column);

  GeneratedColumn<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signatureUrl => $composableBuilder(
    column: $table.signatureUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get retroactiveReason => $composableBuilder(
    column: $table.retroactiveReason,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saveLocationLat => $composableBuilder(
    column: $table.saveLocationLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saveLocationLng => $composableBuilder(
    column: $table.saveLocationLng,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get visitType =>
      $composableBuilder(column: $table.visitType, builder: (column) => column);

  GeneratedColumn<String> get visitReason => $composableBuilder(
    column: $table.visitReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get interestedProductIds => $composableBuilder(
    column: $table.interestedProductIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);
}

class $$LocalVisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVisitsTable,
          LocalVisit,
          $$LocalVisitsTableFilterComposer,
          $$LocalVisitsTableOrderingComposer,
          $$LocalVisitsTableAnnotationComposer,
          $$LocalVisitsTableCreateCompanionBuilder,
          $$LocalVisitsTableUpdateCompanionBuilder,
          (
            LocalVisit,
            BaseReferences<_$AppDatabase, $LocalVisitsTable, LocalVisit>,
          ),
          LocalVisit,
          PrefetchHooks Function()
        > {
  $$LocalVisitsTableTableManager(_$AppDatabase db, $LocalVisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String> repId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String> centerId = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<DateTime> visitDate = const Value.absent(),
                Value<DateTime?> arrivalTime = const Value.absent(),
                Value<DateTime?> completionTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isFlagged = const Value.absent(),
                Value<String?> supervisorNote = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String?> signatureUrl = const Value.absent(),
                Value<String?> retroactiveReason = const Value.absent(),
                Value<double?> saveLocationLat = const Value.absent(),
                Value<double?> saveLocationLng = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String> visitType = const Value.absent(),
                Value<String?> visitReason = const Value.absent(),
                Value<String?> interestedProductIds = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitsCompanion(
                id: id,
                referenceCode: referenceCode,
                repId: repId,
                brandId: brandId,
                centerId: centerId,
                appointmentId: appointmentId,
                visitDate: visitDate,
                arrivalTime: arrivalTime,
                completionTime: completionTime,
                status: status,
                notes: notes,
                latitude: latitude,
                longitude: longitude,
                isFlagged: isFlagged,
                supervisorNote: supervisorNote,
                signaturePath: signaturePath,
                signatureUrl: signatureUrl,
                retroactiveReason: retroactiveReason,
                saveLocationLat: saveLocationLat,
                saveLocationLng: saveLocationLng,
                synced: synced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                clientId: clientId,
                visitType: visitType,
                visitReason: visitReason,
                interestedProductIds: interestedProductIds,
                taskId: taskId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> referenceCode = const Value.absent(),
                required String repId,
                Value<String?> brandId = const Value.absent(),
                required String centerId,
                Value<String?> appointmentId = const Value.absent(),
                required DateTime visitDate,
                Value<DateTime?> arrivalTime = const Value.absent(),
                Value<DateTime?> completionTime = const Value.absent(),
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isFlagged = const Value.absent(),
                Value<String?> supervisorNote = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String?> signatureUrl = const Value.absent(),
                Value<String?> retroactiveReason = const Value.absent(),
                Value<double?> saveLocationLat = const Value.absent(),
                Value<double?> saveLocationLng = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String> visitType = const Value.absent(),
                Value<String?> visitReason = const Value.absent(),
                Value<String?> interestedProductIds = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitsCompanion.insert(
                id: id,
                referenceCode: referenceCode,
                repId: repId,
                brandId: brandId,
                centerId: centerId,
                appointmentId: appointmentId,
                visitDate: visitDate,
                arrivalTime: arrivalTime,
                completionTime: completionTime,
                status: status,
                notes: notes,
                latitude: latitude,
                longitude: longitude,
                isFlagged: isFlagged,
                supervisorNote: supervisorNote,
                signaturePath: signaturePath,
                signatureUrl: signatureUrl,
                retroactiveReason: retroactiveReason,
                saveLocationLat: saveLocationLat,
                saveLocationLng: saveLocationLng,
                synced: synced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                clientId: clientId,
                visitType: visitType,
                visitReason: visitReason,
                interestedProductIds: interestedProductIds,
                taskId: taskId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVisitsTable,
      LocalVisit,
      $$LocalVisitsTableFilterComposer,
      $$LocalVisitsTableOrderingComposer,
      $$LocalVisitsTableAnnotationComposer,
      $$LocalVisitsTableCreateCompanionBuilder,
      $$LocalVisitsTableUpdateCompanionBuilder,
      (
        LocalVisit,
        BaseReferences<_$AppDatabase, $LocalVisitsTable, LocalVisit>,
      ),
      LocalVisit,
      PrefetchHooks Function()
    >;
typedef $$LocalVisitItemsTableCreateCompanionBuilder =
    LocalVisitItemsCompanion Function({
      required String id,
      Value<String?> visitId,
      required String productId,
      Value<int> qtySold,
      Value<int> qtyFree,
      Value<double?> priceAtSale,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalVisitItemsTableUpdateCompanionBuilder =
    LocalVisitItemsCompanion Function({
      Value<String> id,
      Value<String?> visitId,
      Value<String> productId,
      Value<int> qtySold,
      Value<int> qtyFree,
      Value<double?> priceAtSale,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalVisitItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVisitItemsTable> {
  $$LocalVisitItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtySold => $composableBuilder(
    column: $table.qtySold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyFree => $composableBuilder(
    column: $table.qtyFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceAtSale => $composableBuilder(
    column: $table.priceAtSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVisitItemsTable> {
  $$LocalVisitItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtySold => $composableBuilder(
    column: $table.qtySold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyFree => $composableBuilder(
    column: $table.qtyFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceAtSale => $composableBuilder(
    column: $table.priceAtSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVisitItemsTable> {
  $$LocalVisitItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qtySold =>
      $composableBuilder(column: $table.qtySold, builder: (column) => column);

  GeneratedColumn<int> get qtyFree =>
      $composableBuilder(column: $table.qtyFree, builder: (column) => column);

  GeneratedColumn<double> get priceAtSale => $composableBuilder(
    column: $table.priceAtSale,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalVisitItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVisitItemsTable,
          LocalVisitItem,
          $$LocalVisitItemsTableFilterComposer,
          $$LocalVisitItemsTableOrderingComposer,
          $$LocalVisitItemsTableAnnotationComposer,
          $$LocalVisitItemsTableCreateCompanionBuilder,
          $$LocalVisitItemsTableUpdateCompanionBuilder,
          (
            LocalVisitItem,
            BaseReferences<
              _$AppDatabase,
              $LocalVisitItemsTable,
              LocalVisitItem
            >,
          ),
          LocalVisitItem,
          PrefetchHooks Function()
        > {
  $$LocalVisitItemsTableTableManager(
    _$AppDatabase db,
    $LocalVisitItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVisitItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVisitItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVisitItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qtySold = const Value.absent(),
                Value<int> qtyFree = const Value.absent(),
                Value<double?> priceAtSale = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitItemsCompanion(
                id: id,
                visitId: visitId,
                productId: productId,
                qtySold: qtySold,
                qtyFree: qtyFree,
                priceAtSale: priceAtSale,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> visitId = const Value.absent(),
                required String productId,
                Value<int> qtySold = const Value.absent(),
                Value<int> qtyFree = const Value.absent(),
                Value<double?> priceAtSale = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitItemsCompanion.insert(
                id: id,
                visitId: visitId,
                productId: productId,
                qtySold: qtySold,
                qtyFree: qtyFree,
                priceAtSale: priceAtSale,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVisitItemsTable,
      LocalVisitItem,
      $$LocalVisitItemsTableFilterComposer,
      $$LocalVisitItemsTableOrderingComposer,
      $$LocalVisitItemsTableAnnotationComposer,
      $$LocalVisitItemsTableCreateCompanionBuilder,
      $$LocalVisitItemsTableUpdateCompanionBuilder,
      (
        LocalVisitItem,
        BaseReferences<_$AppDatabase, $LocalVisitItemsTable, LocalVisitItem>,
      ),
      LocalVisitItem,
      PrefetchHooks Function()
    >;
typedef $$LocalPharmacyStockChecksTableCreateCompanionBuilder =
    LocalPharmacyStockChecksCompanion Function({
      required String id,
      Value<String?> visitId,
      Value<String?> productId,
      Value<String?> competitorProductName,
      Value<int> observedQty,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalPharmacyStockChecksTableUpdateCompanionBuilder =
    LocalPharmacyStockChecksCompanion Function({
      Value<String> id,
      Value<String?> visitId,
      Value<String?> productId,
      Value<String?> competitorProductName,
      Value<int> observedQty,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalPharmacyStockChecksTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPharmacyStockChecksTable> {
  $$LocalPharmacyStockChecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get competitorProductName => $composableBuilder(
    column: $table.competitorProductName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get observedQty => $composableBuilder(
    column: $table.observedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPharmacyStockChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPharmacyStockChecksTable> {
  $$LocalPharmacyStockChecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get competitorProductName => $composableBuilder(
    column: $table.competitorProductName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get observedQty => $composableBuilder(
    column: $table.observedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPharmacyStockChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPharmacyStockChecksTable> {
  $$LocalPharmacyStockChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get competitorProductName => $composableBuilder(
    column: $table.competitorProductName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get observedQty => $composableBuilder(
    column: $table.observedQty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalPharmacyStockChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPharmacyStockChecksTable,
          LocalPharmacyStockCheck,
          $$LocalPharmacyStockChecksTableFilterComposer,
          $$LocalPharmacyStockChecksTableOrderingComposer,
          $$LocalPharmacyStockChecksTableAnnotationComposer,
          $$LocalPharmacyStockChecksTableCreateCompanionBuilder,
          $$LocalPharmacyStockChecksTableUpdateCompanionBuilder,
          (
            LocalPharmacyStockCheck,
            BaseReferences<
              _$AppDatabase,
              $LocalPharmacyStockChecksTable,
              LocalPharmacyStockCheck
            >,
          ),
          LocalPharmacyStockCheck,
          PrefetchHooks Function()
        > {
  $$LocalPharmacyStockChecksTableTableManager(
    _$AppDatabase db,
    $LocalPharmacyStockChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPharmacyStockChecksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPharmacyStockChecksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPharmacyStockChecksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> competitorProductName = const Value.absent(),
                Value<int> observedQty = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPharmacyStockChecksCompanion(
                id: id,
                visitId: visitId,
                productId: productId,
                competitorProductName: competitorProductName,
                observedQty: observedQty,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> visitId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> competitorProductName = const Value.absent(),
                Value<int> observedQty = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPharmacyStockChecksCompanion.insert(
                id: id,
                visitId: visitId,
                productId: productId,
                competitorProductName: competitorProductName,
                observedQty: observedQty,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPharmacyStockChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPharmacyStockChecksTable,
      LocalPharmacyStockCheck,
      $$LocalPharmacyStockChecksTableFilterComposer,
      $$LocalPharmacyStockChecksTableOrderingComposer,
      $$LocalPharmacyStockChecksTableAnnotationComposer,
      $$LocalPharmacyStockChecksTableCreateCompanionBuilder,
      $$LocalPharmacyStockChecksTableUpdateCompanionBuilder,
      (
        LocalPharmacyStockCheck,
        BaseReferences<
          _$AppDatabase,
          $LocalPharmacyStockChecksTable,
          LocalPharmacyStockCheck
        >,
      ),
      LocalPharmacyStockCheck,
      PrefetchHooks Function()
    >;
typedef $$LocalCentersTableCreateCompanionBuilder =
    LocalCentersCompanion Function({
      required String id,
      required String name,
      Value<String?> region,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<String?> assignedRepId,
      Value<String> status,
      Value<String?> rejectionReason,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> synced,
      Value<String?> brandId,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalCentersTableUpdateCompanionBuilder =
    LocalCentersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> region,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<String?> assignedRepId,
      Value<String> status,
      Value<String?> rejectionReason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> synced,
      Value<String?> brandId,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalCentersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCentersTable> {
  $$LocalCentersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedRepId => $composableBuilder(
    column: $table.assignedRepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCentersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCentersTable> {
  $$LocalCentersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedRepId => $composableBuilder(
    column: $table.assignedRepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCentersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCentersTable> {
  $$LocalCentersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get assignedRepId => $composableBuilder(
    column: $table.assignedRepId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalCentersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCentersTable,
          LocalCenter,
          $$LocalCentersTableFilterComposer,
          $$LocalCentersTableOrderingComposer,
          $$LocalCentersTableAnnotationComposer,
          $$LocalCentersTableCreateCompanionBuilder,
          $$LocalCentersTableUpdateCompanionBuilder,
          (
            LocalCenter,
            BaseReferences<_$AppDatabase, $LocalCentersTable, LocalCenter>,
          ),
          LocalCenter,
          PrefetchHooks Function()
        > {
  $$LocalCentersTableTableManager(_$AppDatabase db, $LocalCentersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCentersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCentersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCentersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> assignedRepId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCentersCompanion(
                id: id,
                name: name,
                region: region,
                latitude: latitude,
                longitude: longitude,
                address: address,
                assignedRepId: assignedRepId,
                status: status,
                rejectionReason: rejectionReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                brandId: brandId,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> region = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> assignedRepId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> synced = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCentersCompanion.insert(
                id: id,
                name: name,
                region: region,
                latitude: latitude,
                longitude: longitude,
                address: address,
                assignedRepId: assignedRepId,
                status: status,
                rejectionReason: rejectionReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                brandId: brandId,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCentersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCentersTable,
      LocalCenter,
      $$LocalCentersTableFilterComposer,
      $$LocalCentersTableOrderingComposer,
      $$LocalCentersTableAnnotationComposer,
      $$LocalCentersTableCreateCompanionBuilder,
      $$LocalCentersTableUpdateCompanionBuilder,
      (
        LocalCenter,
        BaseReferences<_$AppDatabase, $LocalCentersTable, LocalCenter>,
      ),
      LocalCenter,
      PrefetchHooks Function()
    >;
typedef $$LocalAppointmentsTableCreateCompanionBuilder =
    LocalAppointmentsCompanion Function({
      required String id,
      Value<String?> referenceCode,
      required String repId,
      Value<String?> brandId,
      Value<String?> clientId,
      Value<String?> centerId,
      Value<String?> centerName,
      required DateTime apptDate,
      required String apptTime,
      Value<int> reminderMinutesBefore,
      Value<String?> notes,
      Value<String?> suggestedProductId,
      Value<String?> suggestedProductName,
      Value<String> status,
      Value<String?> supervisorNote,
      Value<bool> synced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalAppointmentsTableUpdateCompanionBuilder =
    LocalAppointmentsCompanion Function({
      Value<String> id,
      Value<String?> referenceCode,
      Value<String> repId,
      Value<String?> brandId,
      Value<String?> clientId,
      Value<String?> centerId,
      Value<String?> centerName,
      Value<DateTime> apptDate,
      Value<String> apptTime,
      Value<int> reminderMinutesBefore,
      Value<String?> notes,
      Value<String?> suggestedProductId,
      Value<String?> suggestedProductName,
      Value<String> status,
      Value<String?> supervisorNote,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalAppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get centerId => $composableBuilder(
    column: $table.centerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get centerName => $composableBuilder(
    column: $table.centerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get apptDate => $composableBuilder(
    column: $table.apptDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apptTime => $composableBuilder(
    column: $table.apptTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedProductId => $composableBuilder(
    column: $table.suggestedProductId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedProductName => $composableBuilder(
    column: $table.suggestedProductName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get centerId => $composableBuilder(
    column: $table.centerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get centerName => $composableBuilder(
    column: $table.centerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get apptDate => $composableBuilder(
    column: $table.apptDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apptTime => $composableBuilder(
    column: $table.apptTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedProductId => $composableBuilder(
    column: $table.suggestedProductId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedProductName => $composableBuilder(
    column: $table.suggestedProductName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repId =>
      $composableBuilder(column: $table.repId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get centerId =>
      $composableBuilder(column: $table.centerId, builder: (column) => column);

  GeneratedColumn<String> get centerName => $composableBuilder(
    column: $table.centerName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get apptDate =>
      $composableBuilder(column: $table.apptDate, builder: (column) => column);

  GeneratedColumn<String> get apptTime =>
      $composableBuilder(column: $table.apptTime, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get suggestedProductId => $composableBuilder(
    column: $table.suggestedProductId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedProductName => $composableBuilder(
    column: $table.suggestedProductName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get supervisorNote => $composableBuilder(
    column: $table.supervisorNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalAppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAppointmentsTable,
          LocalAppointment,
          $$LocalAppointmentsTableFilterComposer,
          $$LocalAppointmentsTableOrderingComposer,
          $$LocalAppointmentsTableAnnotationComposer,
          $$LocalAppointmentsTableCreateCompanionBuilder,
          $$LocalAppointmentsTableUpdateCompanionBuilder,
          (
            LocalAppointment,
            BaseReferences<
              _$AppDatabase,
              $LocalAppointmentsTable,
              LocalAppointment
            >,
          ),
          LocalAppointment,
          PrefetchHooks Function()
        > {
  $$LocalAppointmentsTableTableManager(
    _$AppDatabase db,
    $LocalAppointmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAppointmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String> repId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> centerId = const Value.absent(),
                Value<String?> centerName = const Value.absent(),
                Value<DateTime> apptDate = const Value.absent(),
                Value<String> apptTime = const Value.absent(),
                Value<int> reminderMinutesBefore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> suggestedProductId = const Value.absent(),
                Value<String?> suggestedProductName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> supervisorNote = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppointmentsCompanion(
                id: id,
                referenceCode: referenceCode,
                repId: repId,
                brandId: brandId,
                clientId: clientId,
                centerId: centerId,
                centerName: centerName,
                apptDate: apptDate,
                apptTime: apptTime,
                reminderMinutesBefore: reminderMinutesBefore,
                notes: notes,
                suggestedProductId: suggestedProductId,
                suggestedProductName: suggestedProductName,
                status: status,
                supervisorNote: supervisorNote,
                synced: synced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> referenceCode = const Value.absent(),
                required String repId,
                Value<String?> brandId = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> centerId = const Value.absent(),
                Value<String?> centerName = const Value.absent(),
                required DateTime apptDate,
                required String apptTime,
                Value<int> reminderMinutesBefore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> suggestedProductId = const Value.absent(),
                Value<String?> suggestedProductName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> supervisorNote = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppointmentsCompanion.insert(
                id: id,
                referenceCode: referenceCode,
                repId: repId,
                brandId: brandId,
                clientId: clientId,
                centerId: centerId,
                centerName: centerName,
                apptDate: apptDate,
                apptTime: apptTime,
                reminderMinutesBefore: reminderMinutesBefore,
                notes: notes,
                suggestedProductId: suggestedProductId,
                suggestedProductName: suggestedProductName,
                status: status,
                supervisorNote: supervisorNote,
                synced: synced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAppointmentsTable,
      LocalAppointment,
      $$LocalAppointmentsTableFilterComposer,
      $$LocalAppointmentsTableOrderingComposer,
      $$LocalAppointmentsTableAnnotationComposer,
      $$LocalAppointmentsTableCreateCompanionBuilder,
      $$LocalAppointmentsTableUpdateCompanionBuilder,
      (
        LocalAppointment,
        BaseReferences<
          _$AppDatabase,
          $LocalAppointmentsTable,
          LocalAppointment
        >,
      ),
      LocalAppointment,
      PrefetchHooks Function()
    >;
typedef $$LocalNotificationsTableCreateCompanionBuilder =
    LocalNotificationsCompanion Function({
      required String id,
      required String userId,
      required String type,
      required String title,
      Value<String?> message,
      Value<String?> relatedId,
      Value<bool> isRead,
      required DateTime createdAt,
      Value<bool> synced,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalNotificationsTableUpdateCompanionBuilder =
    LocalNotificationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> type,
      Value<String> title,
      Value<String?> message,
      Value<String?> relatedId,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<bool> synced,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get relatedId =>
      $composableBuilder(column: $table.relatedId, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalNotificationsTable,
          LocalNotification,
          $$LocalNotificationsTableFilterComposer,
          $$LocalNotificationsTableOrderingComposer,
          $$LocalNotificationsTableAnnotationComposer,
          $$LocalNotificationsTableCreateCompanionBuilder,
          $$LocalNotificationsTableUpdateCompanionBuilder,
          (
            LocalNotification,
            BaseReferences<
              _$AppDatabase,
              $LocalNotificationsTable,
              LocalNotification
            >,
          ),
          LocalNotification,
          PrefetchHooks Function()
        > {
  $$LocalNotificationsTableTableManager(
    _$AppDatabase db,
    $LocalNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> relatedId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion(
                id: id,
                userId: userId,
                type: type,
                title: title,
                message: message,
                relatedId: relatedId,
                isRead: isRead,
                createdAt: createdAt,
                synced: synced,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String type,
                required String title,
                Value<String?> message = const Value.absent(),
                Value<String?> relatedId = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                required DateTime createdAt,
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                title: title,
                message: message,
                relatedId: relatedId,
                isRead: isRead,
                createdAt: createdAt,
                synced: synced,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalNotificationsTable,
      LocalNotification,
      $$LocalNotificationsTableFilterComposer,
      $$LocalNotificationsTableOrderingComposer,
      $$LocalNotificationsTableAnnotationComposer,
      $$LocalNotificationsTableCreateCompanionBuilder,
      $$LocalNotificationsTableUpdateCompanionBuilder,
      (
        LocalNotification,
        BaseReferences<
          _$AppDatabase,
          $LocalNotificationsTable,
          LocalNotification
        >,
      ),
      LocalNotification,
      PrefetchHooks Function()
    >;
typedef $$LocalProductsTableCreateCompanionBuilder =
    LocalProductsCompanion Function({
      required String id,
      required String name,
      Value<String?> category,
      Value<double?> unitPrice,
      Value<int> stockQty,
      Value<bool> isLowStock,
      Value<String?> imageUrl,
      Value<bool> isActive,
      Value<String?> barcode,
      Value<String?> brandId,
      Value<int> rowid,
    });
typedef $$LocalProductsTableUpdateCompanionBuilder =
    LocalProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> category,
      Value<double?> unitPrice,
      Value<int> stockQty,
      Value<bool> isLowStock,
      Value<String?> imageUrl,
      Value<bool> isActive,
      Value<String?> barcode,
      Value<String?> brandId,
      Value<int> rowid,
    });

class $$LocalProductsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLowStock => $composableBuilder(
    column: $table.isLowStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLowStock => $composableBuilder(
    column: $table.isLowStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<bool> get isLowStock => $composableBuilder(
    column: $table.isLowStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);
}

class $$LocalProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProductsTable,
          LocalProduct,
          $$LocalProductsTableFilterComposer,
          $$LocalProductsTableOrderingComposer,
          $$LocalProductsTableAnnotationComposer,
          $$LocalProductsTableCreateCompanionBuilder,
          $$LocalProductsTableUpdateCompanionBuilder,
          (
            LocalProduct,
            BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>,
          ),
          LocalProduct,
          PrefetchHooks Function()
        > {
  $$LocalProductsTableTableManager(_$AppDatabase db, $LocalProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<bool> isLowStock = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion(
                id: id,
                name: name,
                category: category,
                unitPrice: unitPrice,
                stockQty: stockQty,
                isLowStock: isLowStock,
                imageUrl: imageUrl,
                isActive: isActive,
                barcode: barcode,
                brandId: brandId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> category = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<bool> isLowStock = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion.insert(
                id: id,
                name: name,
                category: category,
                unitPrice: unitPrice,
                stockQty: stockQty,
                isLowStock: isLowStock,
                imageUrl: imageUrl,
                isActive: isActive,
                barcode: barcode,
                brandId: brandId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProductsTable,
      LocalProduct,
      $$LocalProductsTableFilterComposer,
      $$LocalProductsTableOrderingComposer,
      $$LocalProductsTableAnnotationComposer,
      $$LocalProductsTableCreateCompanionBuilder,
      $$LocalProductsTableUpdateCompanionBuilder,
      (
        LocalProduct,
        BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>,
      ),
      LocalProduct,
      PrefetchHooks Function()
    >;
typedef $$LocalVisitPhotosTableCreateCompanionBuilder =
    LocalVisitPhotosCompanion Function({
      required String id,
      Value<String?> visitId,
      required String photoPath,
      Value<String?> uploadedUrl,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalVisitPhotosTableUpdateCompanionBuilder =
    LocalVisitPhotosCompanion Function({
      Value<String> id,
      Value<String?> visitId,
      Value<String> photoPath,
      Value<String?> uploadedUrl,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalVisitPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVisitPhotosTable> {
  $$LocalVisitPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVisitPhotosTable> {
  $$LocalVisitPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVisitPhotosTable> {
  $$LocalVisitPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalVisitPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVisitPhotosTable,
          LocalVisitPhoto,
          $$LocalVisitPhotosTableFilterComposer,
          $$LocalVisitPhotosTableOrderingComposer,
          $$LocalVisitPhotosTableAnnotationComposer,
          $$LocalVisitPhotosTableCreateCompanionBuilder,
          $$LocalVisitPhotosTableUpdateCompanionBuilder,
          (
            LocalVisitPhoto,
            BaseReferences<
              _$AppDatabase,
              $LocalVisitPhotosTable,
              LocalVisitPhoto
            >,
          ),
          LocalVisitPhoto,
          PrefetchHooks Function()
        > {
  $$LocalVisitPhotosTableTableManager(
    _$AppDatabase db,
    $LocalVisitPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVisitPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVisitPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVisitPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<String?> uploadedUrl = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitPhotosCompanion(
                id: id,
                visitId: visitId,
                photoPath: photoPath,
                uploadedUrl: uploadedUrl,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> visitId = const Value.absent(),
                required String photoPath,
                Value<String?> uploadedUrl = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitPhotosCompanion.insert(
                id: id,
                visitId: visitId,
                photoPath: photoPath,
                uploadedUrl: uploadedUrl,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVisitPhotosTable,
      LocalVisitPhoto,
      $$LocalVisitPhotosTableFilterComposer,
      $$LocalVisitPhotosTableOrderingComposer,
      $$LocalVisitPhotosTableAnnotationComposer,
      $$LocalVisitPhotosTableCreateCompanionBuilder,
      $$LocalVisitPhotosTableUpdateCompanionBuilder,
      (
        LocalVisitPhoto,
        BaseReferences<_$AppDatabase, $LocalVisitPhotosTable, LocalVisitPhoto>,
      ),
      LocalVisitPhoto,
      PrefetchHooks Function()
    >;
typedef $$LocalFieldReportsTableCreateCompanionBuilder =
    LocalFieldReportsCompanion Function({
      required String id,
      required String repId,
      Value<String?> brandId,
      required String content,
      Value<String?> photoPath,
      Value<String?> uploadedUrl,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalFieldReportsTableUpdateCompanionBuilder =
    LocalFieldReportsCompanion Function({
      Value<String> id,
      Value<String> repId,
      Value<String?> brandId,
      Value<String> content,
      Value<String?> photoPath,
      Value<String?> uploadedUrl,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalFieldReportsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFieldReportsTable> {
  $$LocalFieldReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFieldReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFieldReportsTable> {
  $$LocalFieldReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFieldReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFieldReportsTable> {
  $$LocalFieldReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get repId =>
      $composableBuilder(column: $table.repId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalFieldReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFieldReportsTable,
          LocalFieldReport,
          $$LocalFieldReportsTableFilterComposer,
          $$LocalFieldReportsTableOrderingComposer,
          $$LocalFieldReportsTableAnnotationComposer,
          $$LocalFieldReportsTableCreateCompanionBuilder,
          $$LocalFieldReportsTableUpdateCompanionBuilder,
          (
            LocalFieldReport,
            BaseReferences<
              _$AppDatabase,
              $LocalFieldReportsTable,
              LocalFieldReport
            >,
          ),
          LocalFieldReport,
          PrefetchHooks Function()
        > {
  $$LocalFieldReportsTableTableManager(
    _$AppDatabase db,
    $LocalFieldReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFieldReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFieldReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFieldReportsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> uploadedUrl = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFieldReportsCompanion(
                id: id,
                repId: repId,
                brandId: brandId,
                content: content,
                photoPath: photoPath,
                uploadedUrl: uploadedUrl,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repId,
                Value<String?> brandId = const Value.absent(),
                required String content,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> uploadedUrl = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFieldReportsCompanion.insert(
                id: id,
                repId: repId,
                brandId: brandId,
                content: content,
                photoPath: photoPath,
                uploadedUrl: uploadedUrl,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFieldReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFieldReportsTable,
      LocalFieldReport,
      $$LocalFieldReportsTableFilterComposer,
      $$LocalFieldReportsTableOrderingComposer,
      $$LocalFieldReportsTableAnnotationComposer,
      $$LocalFieldReportsTableCreateCompanionBuilder,
      $$LocalFieldReportsTableUpdateCompanionBuilder,
      (
        LocalFieldReport,
        BaseReferences<
          _$AppDatabase,
          $LocalFieldReportsTable,
          LocalFieldReport
        >,
      ),
      LocalFieldReport,
      PrefetchHooks Function()
    >;
typedef $$LocalExpensesTableCreateCompanionBuilder =
    LocalExpensesCompanion Function({
      required String id,
      Value<String?> visitId,
      required String repId,
      Value<String?> brandId,
      required String category,
      required double amount,
      Value<String?> description,
      Value<String?> receiptImagePath,
      Value<String?> uploadedUrl,
      Value<String> status,
      Value<String?> rejectionReason,
      Value<bool> requiresAdminApproval,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<String?> repName,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalExpensesTableUpdateCompanionBuilder =
    LocalExpensesCompanion Function({
      Value<String> id,
      Value<String?> visitId,
      Value<String> repId,
      Value<String?> brandId,
      Value<String> category,
      Value<double> amount,
      Value<String?> description,
      Value<String?> receiptImagePath,
      Value<String?> uploadedUrl,
      Value<String> status,
      Value<String?> rejectionReason,
      Value<bool> requiresAdminApproval,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<String?> repName,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresAdminApproval => $composableBuilder(
    column: $table.requiresAdminApproval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repName => $composableBuilder(
    column: $table.repName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresAdminApproval => $composableBuilder(
    column: $table.requiresAdminApproval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repName => $composableBuilder(
    column: $table.repName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get repId =>
      $composableBuilder(column: $table.repId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
    column: $table.receiptImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadedUrl => $composableBuilder(
    column: $table.uploadedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresAdminApproval => $composableBuilder(
    column: $table.requiresAdminApproval,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repName =>
      $composableBuilder(column: $table.repName, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpensesTable,
          LocalExpense,
          $$LocalExpensesTableFilterComposer,
          $$LocalExpensesTableOrderingComposer,
          $$LocalExpensesTableAnnotationComposer,
          $$LocalExpensesTableCreateCompanionBuilder,
          $$LocalExpensesTableUpdateCompanionBuilder,
          (
            LocalExpense,
            BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
          ),
          LocalExpense,
          PrefetchHooks Function()
        > {
  $$LocalExpensesTableTableManager(_$AppDatabase db, $LocalExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> repId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<String?> uploadedUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<bool> requiresAdminApproval = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<String?> repName = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion(
                id: id,
                visitId: visitId,
                repId: repId,
                brandId: brandId,
                category: category,
                amount: amount,
                description: description,
                receiptImagePath: receiptImagePath,
                uploadedUrl: uploadedUrl,
                status: status,
                rejectionReason: rejectionReason,
                requiresAdminApproval: requiresAdminApproval,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                repName: repName,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> visitId = const Value.absent(),
                required String repId,
                Value<String?> brandId = const Value.absent(),
                required String category,
                required double amount,
                Value<String?> description = const Value.absent(),
                Value<String?> receiptImagePath = const Value.absent(),
                Value<String?> uploadedUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<bool> requiresAdminApproval = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<String?> repName = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion.insert(
                id: id,
                visitId: visitId,
                repId: repId,
                brandId: brandId,
                category: category,
                amount: amount,
                description: description,
                receiptImagePath: receiptImagePath,
                uploadedUrl: uploadedUrl,
                status: status,
                rejectionReason: rejectionReason,
                requiresAdminApproval: requiresAdminApproval,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                repName: repName,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpensesTable,
      LocalExpense,
      $$LocalExpensesTableFilterComposer,
      $$LocalExpensesTableOrderingComposer,
      $$LocalExpensesTableAnnotationComposer,
      $$LocalExpensesTableCreateCompanionBuilder,
      $$LocalExpensesTableUpdateCompanionBuilder,
      (
        LocalExpense,
        BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
      ),
      LocalExpense,
      PrefetchHooks Function()
    >;
typedef $$LocalSpecialRequestsTableCreateCompanionBuilder =
    LocalSpecialRequestsCompanion Function({
      required String id,
      Value<String?> visitId,
      required String requestType,
      Value<String?> description,
      Value<bool> synced,
      required DateTime createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });
typedef $$LocalSpecialRequestsTableUpdateCompanionBuilder =
    LocalSpecialRequestsCompanion Function({
      Value<String> id,
      Value<String?> visitId,
      Value<String> requestType,
      Value<String?> description,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<int> rowid,
    });

class $$LocalSpecialRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSpecialRequestsTable> {
  $$LocalSpecialRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSpecialRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSpecialRequestsTable> {
  $$LocalSpecialRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSpecialRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSpecialRequestsTable> {
  $$LocalSpecialRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get requestType => $composableBuilder(
    column: $table.requestType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );
}

class $$LocalSpecialRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSpecialRequestsTable,
          LocalSpecialRequest,
          $$LocalSpecialRequestsTableFilterComposer,
          $$LocalSpecialRequestsTableOrderingComposer,
          $$LocalSpecialRequestsTableAnnotationComposer,
          $$LocalSpecialRequestsTableCreateCompanionBuilder,
          $$LocalSpecialRequestsTableUpdateCompanionBuilder,
          (
            LocalSpecialRequest,
            BaseReferences<
              _$AppDatabase,
              $LocalSpecialRequestsTable,
              LocalSpecialRequest
            >,
          ),
          LocalSpecialRequest,
          PrefetchHooks Function()
        > {
  $$LocalSpecialRequestsTableTableManager(
    _$AppDatabase db,
    $LocalSpecialRequestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSpecialRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSpecialRequestsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalSpecialRequestsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> requestType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSpecialRequestsCompanion(
                id: id,
                visitId: visitId,
                requestType: requestType,
                description: description,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> visitId = const Value.absent(),
                required String requestType,
                Value<String?> description = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSpecialRequestsCompanion.insert(
                id: id,
                visitId: visitId,
                requestType: requestType,
                description: description,
                synced: synced,
                createdAt: createdAt,
                syncError: syncError,
                isAbandoned: isAbandoned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSpecialRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSpecialRequestsTable,
      LocalSpecialRequest,
      $$LocalSpecialRequestsTableFilterComposer,
      $$LocalSpecialRequestsTableOrderingComposer,
      $$LocalSpecialRequestsTableAnnotationComposer,
      $$LocalSpecialRequestsTableCreateCompanionBuilder,
      $$LocalSpecialRequestsTableUpdateCompanionBuilder,
      (
        LocalSpecialRequest,
        BaseReferences<
          _$AppDatabase,
          $LocalSpecialRequestsTable,
          LocalSpecialRequest
        >,
      ),
      LocalSpecialRequest,
      PrefetchHooks Function()
    >;
typedef $$LocalClientsTableCreateCompanionBuilder =
    LocalClientsCompanion Function({
      required String id,
      Value<String> clientType,
      Value<String> status,
      required String repId,
      Value<String?> brandId,
      Value<String?> facilityName,
      Value<String?> facilityType,
      Value<String?> doctorName,
      Value<String?> specialty,
      Value<DateTime?> birthDate,
      Value<String?> classTier,
      Value<String?> relationshipType,
      Value<String?> description,
      Value<String?> phoneNumber,
      Value<String?> region,
      Value<String?> area,
      Value<String?> street,
      Value<String?> nearbyLandmark,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> photoUrl,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> synced,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<String?> gender,
      Value<int?> rating,
      Value<String?> treatmentQuality,
      Value<String?> scientificInterests,
      Value<String?> productInterests,
      Value<String?> pharmacyType,
      Value<String?> institutionType,
      Value<String?> keyContactName,
      Value<String?> keyContactPosition,
      Value<String?> keyContactPhone,
      Value<String?> departments,
      Value<int> rowid,
    });
typedef $$LocalClientsTableUpdateCompanionBuilder =
    LocalClientsCompanion Function({
      Value<String> id,
      Value<String> clientType,
      Value<String> status,
      Value<String> repId,
      Value<String?> brandId,
      Value<String?> facilityName,
      Value<String?> facilityType,
      Value<String?> doctorName,
      Value<String?> specialty,
      Value<DateTime?> birthDate,
      Value<String?> classTier,
      Value<String?> relationshipType,
      Value<String?> description,
      Value<String?> phoneNumber,
      Value<String?> region,
      Value<String?> area,
      Value<String?> street,
      Value<String?> nearbyLandmark,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> photoUrl,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> synced,
      Value<String?> syncError,
      Value<bool> isAbandoned,
      Value<String?> gender,
      Value<int?> rating,
      Value<String?> treatmentQuality,
      Value<String?> scientificInterests,
      Value<String?> productInterests,
      Value<String?> pharmacyType,
      Value<String?> institutionType,
      Value<String?> keyContactName,
      Value<String?> keyContactPosition,
      Value<String?> keyContactPhone,
      Value<String?> departments,
      Value<int> rowid,
    });

class $$LocalClientsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facilityType => $composableBuilder(
    column: $table.facilityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classTier => $composableBuilder(
    column: $table.classTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nearbyLandmark => $composableBuilder(
    column: $table.nearbyLandmark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get treatmentQuality => $composableBuilder(
    column: $table.treatmentQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificInterests => $composableBuilder(
    column: $table.scientificInterests,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productInterests => $composableBuilder(
    column: $table.productInterests,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pharmacyType => $composableBuilder(
    column: $table.pharmacyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionType => $composableBuilder(
    column: $table.institutionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyContactName => $composableBuilder(
    column: $table.keyContactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyContactPosition => $composableBuilder(
    column: $table.keyContactPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyContactPhone => $composableBuilder(
    column: $table.keyContactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departments => $composableBuilder(
    column: $table.departments,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repId => $composableBuilder(
    column: $table.repId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facilityType => $composableBuilder(
    column: $table.facilityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classTier => $composableBuilder(
    column: $table.classTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nearbyLandmark => $composableBuilder(
    column: $table.nearbyLandmark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treatmentQuality => $composableBuilder(
    column: $table.treatmentQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificInterests => $composableBuilder(
    column: $table.scientificInterests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productInterests => $composableBuilder(
    column: $table.productInterests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pharmacyType => $composableBuilder(
    column: $table.pharmacyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionType => $composableBuilder(
    column: $table.institutionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyContactName => $composableBuilder(
    column: $table.keyContactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyContactPosition => $composableBuilder(
    column: $table.keyContactPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyContactPhone => $composableBuilder(
    column: $table.keyContactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departments => $composableBuilder(
    column: $table.departments,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalClientsTable> {
  $$LocalClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get repId =>
      $composableBuilder(column: $table.repId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get facilityName => $composableBuilder(
    column: $table.facilityName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get facilityType => $composableBuilder(
    column: $table.facilityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get classTier =>
      $composableBuilder(column: $table.classTier, builder: (column) => column);

  GeneratedColumn<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get nearbyLandmark => $composableBuilder(
    column: $table.nearbyLandmark,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<bool> get isAbandoned => $composableBuilder(
    column: $table.isAbandoned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get treatmentQuality => $composableBuilder(
    column: $table.treatmentQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scientificInterests => $composableBuilder(
    column: $table.scientificInterests,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productInterests => $composableBuilder(
    column: $table.productInterests,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pharmacyType => $composableBuilder(
    column: $table.pharmacyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionType => $composableBuilder(
    column: $table.institutionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyContactName => $composableBuilder(
    column: $table.keyContactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyContactPosition => $composableBuilder(
    column: $table.keyContactPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyContactPhone => $composableBuilder(
    column: $table.keyContactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departments => $composableBuilder(
    column: $table.departments,
    builder: (column) => column,
  );
}

class $$LocalClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalClientsTable,
          LocalClient,
          $$LocalClientsTableFilterComposer,
          $$LocalClientsTableOrderingComposer,
          $$LocalClientsTableAnnotationComposer,
          $$LocalClientsTableCreateCompanionBuilder,
          $$LocalClientsTableUpdateCompanionBuilder,
          (
            LocalClient,
            BaseReferences<_$AppDatabase, $LocalClientsTable, LocalClient>,
          ),
          LocalClient,
          PrefetchHooks Function()
        > {
  $$LocalClientsTableTableManager(_$AppDatabase db, $LocalClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> repId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> facilityName = const Value.absent(),
                Value<String?> facilityType = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> classTier = const Value.absent(),
                Value<String?> relationshipType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> nearbyLandmark = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> treatmentQuality = const Value.absent(),
                Value<String?> scientificInterests = const Value.absent(),
                Value<String?> productInterests = const Value.absent(),
                Value<String?> pharmacyType = const Value.absent(),
                Value<String?> institutionType = const Value.absent(),
                Value<String?> keyContactName = const Value.absent(),
                Value<String?> keyContactPosition = const Value.absent(),
                Value<String?> keyContactPhone = const Value.absent(),
                Value<String?> departments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalClientsCompanion(
                id: id,
                clientType: clientType,
                status: status,
                repId: repId,
                brandId: brandId,
                facilityName: facilityName,
                facilityType: facilityType,
                doctorName: doctorName,
                specialty: specialty,
                birthDate: birthDate,
                classTier: classTier,
                relationshipType: relationshipType,
                description: description,
                phoneNumber: phoneNumber,
                region: region,
                area: area,
                street: street,
                nearbyLandmark: nearbyLandmark,
                latitude: latitude,
                longitude: longitude,
                photoUrl: photoUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                syncError: syncError,
                isAbandoned: isAbandoned,
                gender: gender,
                rating: rating,
                treatmentQuality: treatmentQuality,
                scientificInterests: scientificInterests,
                productInterests: productInterests,
                pharmacyType: pharmacyType,
                institutionType: institutionType,
                keyContactName: keyContactName,
                keyContactPosition: keyContactPosition,
                keyContactPhone: keyContactPhone,
                departments: departments,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> clientType = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String repId,
                Value<String?> brandId = const Value.absent(),
                Value<String?> facilityName = const Value.absent(),
                Value<String?> facilityType = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> classTier = const Value.absent(),
                Value<String?> relationshipType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> nearbyLandmark = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<bool> isAbandoned = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> treatmentQuality = const Value.absent(),
                Value<String?> scientificInterests = const Value.absent(),
                Value<String?> productInterests = const Value.absent(),
                Value<String?> pharmacyType = const Value.absent(),
                Value<String?> institutionType = const Value.absent(),
                Value<String?> keyContactName = const Value.absent(),
                Value<String?> keyContactPosition = const Value.absent(),
                Value<String?> keyContactPhone = const Value.absent(),
                Value<String?> departments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalClientsCompanion.insert(
                id: id,
                clientType: clientType,
                status: status,
                repId: repId,
                brandId: brandId,
                facilityName: facilityName,
                facilityType: facilityType,
                doctorName: doctorName,
                specialty: specialty,
                birthDate: birthDate,
                classTier: classTier,
                relationshipType: relationshipType,
                description: description,
                phoneNumber: phoneNumber,
                region: region,
                area: area,
                street: street,
                nearbyLandmark: nearbyLandmark,
                latitude: latitude,
                longitude: longitude,
                photoUrl: photoUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                syncError: syncError,
                isAbandoned: isAbandoned,
                gender: gender,
                rating: rating,
                treatmentQuality: treatmentQuality,
                scientificInterests: scientificInterests,
                productInterests: productInterests,
                pharmacyType: pharmacyType,
                institutionType: institutionType,
                keyContactName: keyContactName,
                keyContactPosition: keyContactPosition,
                keyContactPhone: keyContactPhone,
                departments: departments,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalClientsTable,
      LocalClient,
      $$LocalClientsTableFilterComposer,
      $$LocalClientsTableOrderingComposer,
      $$LocalClientsTableAnnotationComposer,
      $$LocalClientsTableCreateCompanionBuilder,
      $$LocalClientsTableUpdateCompanionBuilder,
      (
        LocalClient,
        BaseReferences<_$AppDatabase, $LocalClientsTable, LocalClient>,
      ),
      LocalClient,
      PrefetchHooks Function()
    >;
typedef $$LocalUserSignaturesTableCreateCompanionBuilder =
    LocalUserSignaturesCompanion Function({
      required String id,
      required String pointsJson,
      required String imagePath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$LocalUserSignaturesTableUpdateCompanionBuilder =
    LocalUserSignaturesCompanion Function({
      Value<String> id,
      Value<String> pointsJson,
      Value<String> imagePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$LocalUserSignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserSignaturesTable> {
  $$LocalUserSignaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserSignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserSignaturesTable> {
  $$LocalUserSignaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserSignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserSignaturesTable> {
  $$LocalUserSignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$LocalUserSignaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserSignaturesTable,
          LocalUserSignature,
          $$LocalUserSignaturesTableFilterComposer,
          $$LocalUserSignaturesTableOrderingComposer,
          $$LocalUserSignaturesTableAnnotationComposer,
          $$LocalUserSignaturesTableCreateCompanionBuilder,
          $$LocalUserSignaturesTableUpdateCompanionBuilder,
          (
            LocalUserSignature,
            BaseReferences<
              _$AppDatabase,
              $LocalUserSignaturesTable,
              LocalUserSignature
            >,
          ),
          LocalUserSignature,
          PrefetchHooks Function()
        > {
  $$LocalUserSignaturesTableTableManager(
    _$AppDatabase db,
    $LocalUserSignaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserSignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserSignaturesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalUserSignaturesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pointsJson = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserSignaturesCompanion(
                id: id,
                pointsJson: pointsJson,
                imagePath: imagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pointsJson,
                required String imagePath,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserSignaturesCompanion.insert(
                id: id,
                pointsJson: pointsJson,
                imagePath: imagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserSignaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserSignaturesTable,
      LocalUserSignature,
      $$LocalUserSignaturesTableFilterComposer,
      $$LocalUserSignaturesTableOrderingComposer,
      $$LocalUserSignaturesTableAnnotationComposer,
      $$LocalUserSignaturesTableCreateCompanionBuilder,
      $$LocalUserSignaturesTableUpdateCompanionBuilder,
      (
        LocalUserSignature,
        BaseReferences<
          _$AppDatabase,
          $LocalUserSignaturesTable,
          LocalUserSignature
        >,
      ),
      LocalUserSignature,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalVisitsTableTableManager get localVisits =>
      $$LocalVisitsTableTableManager(_db, _db.localVisits);
  $$LocalVisitItemsTableTableManager get localVisitItems =>
      $$LocalVisitItemsTableTableManager(_db, _db.localVisitItems);
  $$LocalPharmacyStockChecksTableTableManager get localPharmacyStockChecks =>
      $$LocalPharmacyStockChecksTableTableManager(
        _db,
        _db.localPharmacyStockChecks,
      );
  $$LocalCentersTableTableManager get localCenters =>
      $$LocalCentersTableTableManager(_db, _db.localCenters);
  $$LocalAppointmentsTableTableManager get localAppointments =>
      $$LocalAppointmentsTableTableManager(_db, _db.localAppointments);
  $$LocalNotificationsTableTableManager get localNotifications =>
      $$LocalNotificationsTableTableManager(_db, _db.localNotifications);
  $$LocalProductsTableTableManager get localProducts =>
      $$LocalProductsTableTableManager(_db, _db.localProducts);
  $$LocalVisitPhotosTableTableManager get localVisitPhotos =>
      $$LocalVisitPhotosTableTableManager(_db, _db.localVisitPhotos);
  $$LocalFieldReportsTableTableManager get localFieldReports =>
      $$LocalFieldReportsTableTableManager(_db, _db.localFieldReports);
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db, _db.localExpenses);
  $$LocalSpecialRequestsTableTableManager get localSpecialRequests =>
      $$LocalSpecialRequestsTableTableManager(_db, _db.localSpecialRequests);
  $$LocalClientsTableTableManager get localClients =>
      $$LocalClientsTableTableManager(_db, _db.localClients);
  $$LocalUserSignaturesTableTableManager get localUserSignatures =>
      $$LocalUserSignaturesTableTableManager(_db, _db.localUserSignatures);
}
