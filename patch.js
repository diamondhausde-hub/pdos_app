const fs = require('fs');

const file = 'lib/core/local_db/app_database.g.dart';
let content = fs.readFileSync(file, 'utf8');

// 1. Add _taskIdMeta and taskId column
content = content.replace(
  /(\s*static const VerificationMeta _interestedProductIdsMeta =[\s\S]*?;\s*@override\s*late final GeneratedColumn<String> interestedProductIds =[\s\S]*?;)/,
  `$1
  static const VerificationMeta _taskIdMeta =
      const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );`
);

// 2. Add to $columns
content = content.replace(
  /(\s*interestedProductIds,)/,
  `$1
    taskId,`
);

// 3. validateIntegrity
content = content.replace(
  /(\s*if \(data\.containsKey\('interested_product_ids'\)\) \{[\s\S]*?\})/,
  `$1
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }`
);

// 4. map
content = content.replace(
  /(\s*interestedProductIds: attachedDatabase\.typeMapping\.read\([\s\S]*?,\s*\),)/,
  `$1
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['\${effectivePrefix}task_id'],
      ),`
);

// 5. LocalVisit class properties
content = content.replace(
  /(\s*final String\? interestedProductIds;)/,
  `$1
  final String? taskId;`
);

// 6. LocalVisit constructor
content = content.replace(
  /(\s*this\.interestedProductIds,)/,
  `$1
    this.taskId,`
);

// 7. LocalVisit toColumns
content = content.replace(
  /(\s*if \(!nullToAbsent \|\| interestedProductIds != null\) \{[\s\S]*?\})/,
  `$1
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }`
);

// 8. LocalVisit fromJson
content = content.replace(
  /(\s*interestedProductIds: [\s\S]*?,)/,
  `$1
      taskId: serializer.fromJson<String?>(json['taskId']),`
);

// 9. LocalVisit toJson
content = content.replace(
  /(\s*'interestedProductIds':[\s\S]*?,)/,
  `$1
      'taskId': serializer.toJson<String?>(taskId),`
);

// 10. LocalVisit copyWith
content = content.replace(
  /(\s*Value<String\?> interestedProductIds = const Value\.absent\(\),)/,
  `$1
    Value<String?> taskId = const Value.absent(),`
);
content = content.replace(
  /(\s*interestedProductIds: interestedProductIds\.present[\s\S]*?: this\.interestedProductIds,)/,
  `$1
      taskId: taskId.present ? taskId.value : this.taskId,`
);

// 11. copyWith companion
content = content.replace(
  /(\s*interestedProductIds: data\.interestedProductIds\.present[\s\S]*?: this\.interestedProductIds,)/,
  `$1
      taskId: data.taskId.present ? data.taskId.value : this.taskId,`
);

// 12. LocalVisit toString
content = content.replace(
  /(\s*\.\.write\('interestedProductIds: \$interestedProductIds'\))/,
  `$1
          ..write(', taskId: $taskId')`
);

// 13. LocalVisit hashCode
content = content.replace(
  /(\s*interestedProductIds,)/,
  `$1
    taskId,`
);

// 14. LocalVisit ==
content = content.replace(
  /(\s*other\.interestedProductIds == this\.interestedProductIds\);)/,
  `
          other.interestedProductIds == this.interestedProductIds &&
          other.taskId == this.taskId);`
);

// 15. LocalVisitsCompanion properties
content = content.replace(
  /(\s*final Value<String\?> interestedProductIds;)/,
  `$1
  final Value<String?> taskId;`
);

// 16. LocalVisitsCompanion constructor
content = content.replace(
  /(\s*this\.interestedProductIds = const Value\.absent\(\),)/,
  `$1
    this.taskId = const Value.absent(),`
);

// 17. LocalVisitsCompanion insert
content = content.replace(
  /(\s*Value<String\?>\? interestedProductIds,)/,
  `$1
    Value<String?>? taskId,`
);
content = content.replace(
  /(\s*interestedProductIds: interestedProductIds \?\? this\.interestedProductIds,)/,
  `$1
      taskId: taskId ?? this.taskId,`
);

// 18. LocalVisitsCompanion custom
content = content.replace(
  /(\s*Expression<String>\? interestedProductIds,)/,
  `$1
    Expression<String>? taskId,`
);
content = content.replace(
  /(\s*if \(interestedProductIds != null\)[\s\S]*?'interested_product_ids': interestedProductIds,)/,
  `$1
      if (taskId != null) 'task_id': taskId,`
);

// 19. LocalVisitsCompanion toColumns
content = content.replace(
  /(\s*if \(interestedProductIds\.present\) \{[\s\S]*?\})/,
  `$1
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }`
);

// 20. LocalVisitsCompanion toString
content = content.replace(
  /(\s*\.\.write\('interestedProductIds: \$interestedProductIds, '\))/,
  `$1
          ..write('taskId: $taskId, ')`
);

// 21. filters and orderings
content = content.replace(
  /(\s*ColumnFilters<String> get interestedProductIds => \$composableBuilder\([\s\S]*?column: \$table\.interestedProductIds,\s*\);)/,
  `$1
  ColumnFilters<String> get taskId => $composableBuilder(
        column: $table.taskId,
        builder: (column) => ColumnFilters(column),
      );`
);

content = content.replace(
  /(\s*ColumnOrderings<String> get interestedProductIds => \$composableBuilder\([\s\S]*?column: \$table\.interestedProductIds,\s*\);)/,
  `$1
  ColumnOrderings<String> get taskId => $composableBuilder(
        column: $table.taskId,
        builder: (column) => ColumnOrderings(column),
      );`
);

content = content.replace(
  /(\s*GeneratedColumn<String> get interestedProductIds => \$composableBuilder\([\s\S]*?column: \$table\.interestedProductIds,\s*\);)/,
  `$1
  GeneratedColumn<String> get taskId => $composableBuilder(
        column: $table.taskId,
        builder: (column) => column,
      );`
);

fs.writeFileSync(file, content, 'utf8');
console.log('Patched successfully');
