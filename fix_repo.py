import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\repositories\task_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'import \'../models/activity_log_model.dart\';' not in content:
    content = "import '../models/activity_log_model.dart';\n" + content

new_method = '''
  Future<List<ActivityLogModel>> getActivityLogs({String? brandId, String? repId, String? dateFilter}) async {
    final query = <String, dynamic>{};
    if (brandId != null && brandId != 'All') query['brand_id'] = brandId;
    if (repId != null && repId != 'All') query['rep_id'] = repId;
    if (dateFilter != null) {
      if (dateFilter == 'Today' || dateFilter == 'OUUSU^U?') query['date_filter'] = 'today';
      else if (dateFilter == 'This Week' || dateFilter == 'OOO OUO_O3OU^O') query['date_filter'] = 'week';
      else if (dateFilter == 'This Month' || dateFilter == 'OOO OUO_UO1') query['date_filter'] = 'month';
    }

    final response = await api.dio.get('/tasks/logs', queryParameters: query);
    final data = response.data as List;
    return data.map((e) => ActivityLogModel.fromJson(e)).toList();
  }
}
'''
content = content.replace('\n}', new_method)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("task_repository.dart fixed")
