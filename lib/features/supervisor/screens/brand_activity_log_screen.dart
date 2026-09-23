import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/models/brand_activity_log_model.dart';
import '../../../core/providers/data_providers.dart';

// Mock model based on SQL schema: activity_logs
/*class BrandActivityLogModel {
  final String id;
  final String repId;
  final String repName; // Added for UI convenience
  final String brandId;
  final String activityType; // visit / call / event / order
  final String targetType; // doctor / pharmacy / center
  final String? targetName; // Added for UI convenience
  final DateTime loggedAt;
  final String notes;
  final String status;
  final String? taskId; // Added to establish linkage to tasks

  BrandActivityLogModel({
    required this.id,
    required this.repId,
    required this.repName,
    required this.brandId,
    required this.activityType,
    required this.targetType,
    this.targetName,
    required this.loggedAt,
    required this.notes,
    required this.status,
    this.taskId,
  });
}*/

class BrandActivityLogScreen extends ConsumerStatefulWidget {
  const BrandActivityLogScreen({super.key});

  @override
  ConsumerState<BrandActivityLogScreen> createState() => _BrandActivityLogScreenState();
}

class _BrandActivityLogScreenState extends ConsumerState<BrandActivityLogScreen> {
  String _dateFilter = 'Today'; // Today, Week, Month

  // Mock data generator
  /*List<BrandActivityLogModel> _getMockLogs(String brandId) {
    return [
      BrandActivityLogModel(
        id: '1',
        repId: 'rep_1',
        repName: 'أحمد محمود',
        brandId: brandId,
        activityType: 'زيارة',
        targetType: 'doctor',
        targetName: 'د. أحمد - عيادة X',
        loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
        notes: 'ترويج Panadol Extra',
        status: 'مكتملة',
      ),
      BrandActivityLogModel(
        id: '2',
        repId: 'rep_1',
        repName: 'أحمد محمود',
        brandId: brandId,
        activityType: 'زيارة',
        targetType: 'pharmacy',
        targetName: 'صيدلية النور',
        loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
        notes: 'طلبية 50 علبة',
        status: 'معلقة',
      ),
      BrandActivityLogModel(
        id: '3',
        repId: 'rep_2',
        repName: 'سارة خالد',
        brandId: brandId,
        activityType: 'فعالية',
        targetType: 'center',
        targetName: 'مركز طبي Y',
        loggedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        notes: 'عرض توضيحي',
        status: 'مكتملة',
      ),
    ];
  }*/

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المندوبين'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text('الفترة: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                _buildDateFilterChip('Today', 'اليوم'),
                const SizedBox(width: 8),
                _buildDateFilterChip('Week', 'أسبوع'),
                const SizedBox(width: 8),
                _buildDateFilterChip('Month', 'شهر'),
              ],
            ),
          ),
        ),
      ),
      body: brandsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('خطأ: $e')),
        data: (brands) {
          if (brands.isEmpty) {
            return const Center(child: Text('لا توجد براندات'));
          }
          return DefaultTabController(
            length: brands.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: brands.map((b) => Tab(text: b.name)).toList(),
                  labelColor: AppColors.primary,
                  indicatorColor: AppColors.primary,
                ),
                Expanded(
                  child: TabBarView(
                    children: brands.map((b) {
                      final logs = ref.watch(activityLogsProvider({'brandId': b.id, 'dateFilter': _dateFilter})).value ?? [];
                      // Group by rep
                      final Map<String, List<BrandActivityLogModel>> groupedByRep = {};
                      for (var log in logs) {
                        groupedByRep.putIfAbsent(log.repName ?? 'Unknown', () => []).add(log);
                      }

                      return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: groupedByRep.entries.map((entry) {
                          final repName = entry.key;
                          final repLogs = entry.value;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              title: Text(repName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${repLogs.length} نشاط'),
                              leading: const CircleAvatar(child: Icon(Icons.person)),
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('الوقت')),
                                      DataColumn(label: Text('النوع')),
                                      DataColumn(label: Text('الجهة')),
                                      DataColumn(label: Text('التفاصيل')),
                                      DataColumn(label: Text('الحالة')),
                                    ],
                                    rows: repLogs.map((log) {
                                      final timeStr = '${log.loggedAt?.hour.toString().padLeft(2, '0')}:${log.loggedAt?.minute.toString().padLeft(2, '0')}';
                                      return DataRow(cells: [
                                        DataCell(Text(timeStr)),
                                        DataCell(Text(log.activityType ?? '-')),
                                        DataCell(Text(log.targetId ?? '-')),
                                        DataCell(Text(log.notes ?? '-')),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: log.status == 'مكتملة' ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              log.status,
                                              style: TextStyle(
                                                color: log.status == 'مكتملة' ? AppColors.success : AppColors.warning,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateFilterChip(String value, String label) {
    final isSelected = _dateFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _dateFilter = value);
        }
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
