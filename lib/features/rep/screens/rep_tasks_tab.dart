import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/task_history_model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../widgets/task_card_widget.dart';

class RepTasksTab extends ConsumerStatefulWidget {
  const RepTasksTab({super.key});

  @override
  ConsumerState<RepTasksTab> createState() => _RepTasksTabState();
}

class _RepTasksTabState extends ConsumerState<RepTasksTab> {
  String _selectedFilter = 'pending';

  void _showTaskDetails(BuildContext context, WidgetRef ref, SupervisorTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskDetailSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مهامي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Badge
          tasksAsync.maybeWhen(data: (tasks) {
            final newCount = tasks.where((t) => t.status == 'pending').length;
            if (newCount == 0) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(left: 16.0), // RTL
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$newCount',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }, orElse: () => const SizedBox()),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFilterChip('معلقة', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('مجدولة', 'scheduled'),
                    const SizedBox(width: 8),
                    _buildFilterChip('قيد التنفيذ', 'in_progress'),
                    const SizedBox(width: 8),
                    _buildFilterChip('مكتملة', 'completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('مرفوضة', 'rejected'),
                  ],
                ),
              ),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(tasksProvider);
              },
              child: tasksAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('حدث خطأ: $e')),
                data: (tasks) {
                  final filteredTasks = tasks.where((t) {
                    if (_selectedFilter == 'pending') return t.status == 'pending';
                    if (_selectedFilter == 'scheduled') return t.status == 'accepted' || t.status == 'scheduled';
                    if (_selectedFilter == 'in_progress') return t.status == 'in_progress';
                    if (_selectedFilter == 'completed') return t.status == 'completed' || t.status == 'done';
                    if (_selectedFilter == 'rejected') return t.status == 'rejected';
                    return false;
                  }).toList();
                  
                  if (_selectedFilter == 'completed') {
                    filteredTasks.sort((a, b) => (b.completedAt ?? DateTime.now()).compareTo(a.completedAt ?? DateTime.now()));
                  }
                  
                  if (filteredTasks.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in, size: 80, color: AppColors.outlineVariant),
                              const SizedBox(height: 16),
                              Text('لا توجد مهام حالياً', style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCardWidget(
                        task: filteredTasks[index],
                        onTap: () => _showTaskDetails(context, ref, filteredTasks[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.onSurface),
    );
  }
}

class _TaskDetailSheet extends ConsumerStatefulWidget {
  final SupervisorTask task;

  const _TaskDetailSheet({required this.task});

  @override
  ConsumerState<_TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends ConsumerState<_TaskDetailSheet> {
  final TextEditingController _noteController = TextEditingController();
  List<TaskHistoryModel> _history = [];
  bool _isLoadingHistory = true;
  Map<String, dynamic>? _visitData;
  bool _isLoadingVisit = true;
  
  @override
  void initState() {
    super.initState();
    _noteController.text = widget.task.progressNote ?? '';
    _loadHistory();
    _loadVisitData();
  }

  Future<void> _loadVisitData() async {
    if (widget.task.visitId == null) {
      if (mounted) setState(() => _isLoadingVisit = false);
      return;
    }
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.dio.get('/visits/${widget.task.visitId}');
      if (mounted) {
        setState(() {
          _visitData = response.data;
          _isLoadingVisit = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingVisit = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.dio.get('/tasks/${widget.task.id}/history');
      final data = response.data as List;
      if (mounted) {
        setState(() {
          _history = data.map((e) => TaskHistoryModel.fromJson(e)).toList();
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  Future<void> _updateTask(String status) async {
    try {
      await ref.read(taskRepositoryProvider).updateTaskStatus(
        widget.task.id, 
        status, 
        progressNote: _noteController.text,
      );
      ref.invalidate(tasksProvider);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('تفاصيل المهمة', style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('نوع المهمة', widget.task.taskType),
                      if (widget.task.targetName != null)
                        _buildDetailRow('الهدف', widget.task.targetName!),
                      if (widget.task.brandName != null)
                        _buildDetailRow('البراند', widget.task.brandName!),
                      if (widget.task.productName != null)
                        _buildDetailRow('المنتج', widget.task.productName!),
                      if (widget.task.dueDate != null)
                        _buildDetailRow('تاريخ التسليم', DateFormat('yyyy-MM-dd').format(widget.task.dueDate!)),
                      if (widget.task.priority != null)
                        _buildDetailRow('الأولوية', widget.task.priority!),
                      if (widget.task.scheduledDatetime != null)
                        _buildDetailRow('موعد التنفيذ', DateFormat('yyyy-MM-dd HH:mm').format(widget.task.scheduledDatetime!.toLocal())),
                      if (widget.task.purpose != null)
                        _buildDetailRow('الغرض', widget.task.purposeLabel),
                      if (widget.task.visitSubtype != null)
                        _buildDetailRow('نوع الزيارة', widget.task.visitSubtypeLabel),
                      if (widget.task.reminderOffset != null)
                        _buildDetailRow('التذكير', widget.task.reminderOffset!),
                      _buildDetailRow('الحالة', _getStatusName(widget.task.status)),
                      if (widget.task.status == 'rejected' && (widget.task.rejectionReport != null || (widget.task.notes != null && widget.task.notes!.isNotEmpty)))
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1), 
                            borderRadius: BorderRadius.circular(8), 
                            border: Border.all(color: Colors.red.withValues(alpha: 0.5))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 100, child: Text('سبب الرفض', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                              Expanded(child: Text(widget.task.rejectionReport ?? widget.task.notes ?? '', style: const TextStyle(color: Colors.red))),
                            ],
                          ),
                        ),
                      if (widget.task.status != 'rejected' && widget.task.notes != null && widget.task.notes!.isNotEmpty)
                        _buildDetailRow('ملاحظات المشرف', widget.task.notes!),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                if (widget.task.visitId != null) ...[
                  Text('بيانات الزيارة المرتبطة', style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (_isLoadingVisit)
                    const Center(child: CircularProgressIndicator())
                  else if (_visitData == null)
                    const Center(child: Text('لا يمكن تحميل بيانات الزيارة'))
                  else
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_visitData!['arrival_time'] != null)
                            _buildDetailRow('وقت الوصول', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(_visitData!['arrival_time']).toLocal())),
                          if (_visitData!['completion_time'] != null)
                            _buildDetailRow('وقت الإنهاء', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(_visitData!['completion_time']).toLocal())),
                          if (_visitData!['status'] != null)
                            _buildDetailRow('حالة الزيارة', _visitData!['status']),
                          if (_visitData!['latitude'] != null && _visitData!['longitude'] != null)
                            _buildDetailRow('الموقع', '${_visitData!['latitude']}, ${_visitData!['longitude']}'),
                          if (_visitData!['notes'] != null && (_visitData!['notes'] as String).isNotEmpty)
                            _buildDetailRow('ملاحظات الزيارة', (_visitData!['notes'] as String).split('---DATA---').first.trim()),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                Text('تحديث التقدم', style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب ملاحظاتك عن تنفيذ المهمة هنا...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                
                if (widget.task.status != 'completed' && widget.task.status != 'done' && widget.task.status != 'rejected') ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.task.status == 'in_progress')
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateTask('done'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                            child: const Text('إكمال المهمة'),
                          ),
                        )
                      else
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateTask(widget.task.status), // Just update note
                            child: const Text('تحديث الملاحظة'),
                          ),
                        ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 24),
                Text('سجل المهمة', style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                
                if (_isLoadingHistory)
                  const Center(child: CircularProgressIndicator())
                else if (_history.isEmpty)
                  const Center(child: Text('لا يوجد سجل'))
                else
                  ..._history.map((h) => _buildHistoryItem(h)),
                  
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _getStatusName(String status) {
    switch (status) {
      case 'new': return 'جديدة';
      case 'pending': return 'معلقة';
      case 'accepted': return 'مقبولة';
      case 'scheduled': return 'مجدولة';
      case 'in_progress': return 'قيد التنفيذ';
      case 'completed': return 'مكتملة';
      case 'done': return 'مكتملة';
      case 'rejected': return 'مرفوضة';
      case 'late': return 'متأخرة';
      default: return status;
    }
  }

  Widget _buildHistoryItem(TaskHistoryModel history) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getActionText(history),
                  style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'بواسطة: ${history.changedByName ?? history.changedBy}',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
                if (history.note != null && history.note!.isNotEmpty)
                  Text(
                    'ملاحظة: ${history.note}',
                    style: AppTextStyles.bodySm,
                  ),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(history.createdAt.toLocal()),
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getActionText(TaskHistoryModel history) {
    switch (history.action) {
      case 'created':
        return 'تم إنشاء المهمة';
      case 'status_changed':
        return 'تم تغيير الحالة من ${_getStatusName(history.oldStatus ?? '')} إلى ${_getStatusName(history.newStatus ?? '')}';
      case 'updated':
        return 'تم تحديث المهمة';
      default:
        return 'تم تحديث المهمة';
    }
  }
}
