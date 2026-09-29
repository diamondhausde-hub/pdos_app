import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../../core/models/task_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/services/api_service.dart';

class TaskManagementScreen extends ConsumerStatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  ConsumerState<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends ConsumerState<TaskManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المهام'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'بحث عن مندوب أو منتج...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'الكل'),
                    Tab(text: 'معلقة'),
                    Tab(text: 'مقبولة'),
                    Tab(text: 'مجدولة'),
                    Tab(text: 'قيد التنفيذ'),
                    Tab(text: 'مرفوضة'),
                    Tab(text: 'مكتملة'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: tasksAsync.when(
          data: (tasks) {
            var filtered = tasks.where((t) {
              final query = _searchQuery.toLowerCase().trim();
              
              bool matchSearch = true;
              if (query.isNotEmpty) {
                matchSearch = (t.repName?.toLowerCase().contains(query) == true) ||
                    (t.productName?.toLowerCase().contains(query) == true) ||
                    (t.targetName?.toLowerCase().contains(query) == true);
              }
              
              if (!matchSearch) return false;

              if (_tabController.index == 0) return true;
              if (_tabController.index == 1) return t.status == 'pending';
              if (_tabController.index == 2) return t.status == 'accepted';
              if (_tabController.index == 3) return t.status == 'scheduled';
              if (_tabController.index == 4) return t.status == 'in_progress';
              if (_tabController.index == 5) return t.status == 'rejected';
              if (_tabController.index == 6) return t.status == 'completed' || t.status == 'done';
              return true;
            }).toList();

            if (filtered.isEmpty) {
              return const Center(child: Text('لا توجد مهام مطابقة'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final task = filtered[index];
                return _TaskCard(task: task, onStatusChanged: (status) {
                  if (status == 'pending') { _tabController.animateTo(1); }
                  else if (status == 'accepted') { _tabController.animateTo(2); }
                  else if (status == 'scheduled') { _tabController.animateTo(3); }
                  else if (status == 'in_progress') { _tabController.animateTo(4); }
                  else if (status == 'rejected') { _tabController.animateTo(5); }
                  else if (status == 'completed' || status == 'done') { _tabController.animateTo(6); }
                });
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('خطأ: $e')),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddTaskSheet(context),
          label: const Text('مهمة جديدة'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddTaskSheet(parentRef: ref),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final SupervisorTask task;
  final Function(String)? onStatusChanged;
  const _TaskCard({required this.task, this.onStatusChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor = Colors.grey;
    String statusText = 'غير معروف';

    switch (task.status) {
      case 'new':
      case 'pending':
        statusColor = Colors.blue;
        statusText = 'معلقة';
        break;
      case 'accepted':
        statusColor = Colors.cyan;
        statusText = 'مقبولة';
        break;
      case 'scheduled':
        statusColor = Colors.purple;
        statusText = 'مجدولة';
        break;
      case 'in_progress':
        statusColor = Colors.orange;
        statusText = 'قيد التنفيذ';
        break;
      case 'completed':
      case 'done':
        statusColor = Colors.green;
        statusText = 'مكتملة';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'مرفوضة';
        break;
      case 'late':
        statusColor = Colors.deepOrange;
        statusText = 'متأخرة';
        break;
    }

    Color brandColor = AppColors.primary;
    if (task.brandColor != null && task.brandColor!.isNotEmpty) {
      try {
        brandColor = Color(int.parse(task.brandColor!.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: () => _showTaskDetails(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.targetName ?? 'بدون عنوان', style: AppTextStyles.h4),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: brandColor),
                            const SizedBox(width: 4),
                            Text(task.repName ?? 'بدون مندوب', style: AppTextStyles.bodySmall.copyWith(color: brandColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (task.dueDate != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(intl.DateFormat('yyyy-MM-dd').format(task.dueDate!), style: AppTextStyles.bodySmall),
                      ],
                    ),
                  if (task.quantityTarget != null)
                    Text('الهدف: ${task.quantityTarget}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskDetailsSheet(task: task, parentRef: ref, onStatusChanged: onStatusChanged),
    );
  }
}

class _AddTaskSheet extends StatefulWidget {
  final WidgetRef parentRef;
  const _AddTaskSheet({required this.parentRef});

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRepId;
  String? _selectedProductId;
  String _taskType = 'sales';
  String _priority = 'normal';
  int? _quantity;
  DateTime? _dueDate;
  TimeOfDay? _scheduledTime;
  String? _visitSubtype;
  String? _purpose;
  final _notesController = TextEditingController();
  final _targetSearchController = TextEditingController();
  bool _isSaving = false;
  
  // Autocomplete variables
  Timer? _debounce;
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _selectedTarget;
  bool _isSearching = false;

  @override
  void dispose() {
    _notesController.dispose();
    _targetSearchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchTargets(query);
    });
  }

  Future<void> _searchTargets(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    
    setState(() => _isSearching = true);
    
    try {
      final response = await ApiService.instance.dio.get(
        '/tasks/search-targets',
        queryParameters: {'q': query},
      );
      if (mounted) {
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(response.data);
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reps = widget.parentRef.watch(myTeamProvider);
    final products = widget.parentRef.watch(productsProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('إضافة مهمة جديدة', style: AppTextStyles.h3, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'نوع المهمة', border: OutlineInputBorder()),
                          value: _taskType,
                          items: const [
                            DropdownMenuItem(value: 'visit', child: Text('زيارة')),
                            DropdownMenuItem(value: 'sales', child: Text('مبيعات')),
                            DropdownMenuItem(value: 'stock', child: Text('جرد')),
                          ],
                          onChanged: (v) => setState(() {
                            _taskType = v!;
                            if (_taskType != 'visit') _visitSubtype = null;
                          }),
                        ),
                        if (_taskType == 'visit') ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'نوع الزيارة', border: OutlineInputBorder()),
                            value: _visitSubtype,
                            items: const [
                              DropdownMenuItem(value: 'doctor', child: Text('طبيب')),
                              DropdownMenuItem(value: 'pharmacy', child: Text('صيدلية')),
                            ],
                            onChanged: (v) => setState(() => _visitSubtype = v),
                          ),
                        ],
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'الغرض', border: OutlineInputBorder()),
                          value: _purpose,
                          items: const [
                            DropdownMenuItem(value: 'product', child: Text('منتج معين')),
                            DropdownMenuItem(value: 'targeting', child: Text('استهداف')),
                            DropdownMenuItem(value: 'accounting', child: Text('حسابات')),
                          ],
                          onChanged: (v) => setState(() => _purpose = v),
                        ),
                        const SizedBox(height: 16),
                        reps.when(
                          data: (list) => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'المندوب', border: OutlineInputBorder()),
                            value: _selectedRepId,
                            items: list.map((r) => DropdownMenuItem(value: r.id, child: Text(r.fullName))).toList(),
                            onChanged: (v) => setState(() => _selectedRepId = v),
                            validator: (v) => v == null ? 'مطلوب' : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const Text('فشل تحميل المندوبين'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Target Search Autocomplete
                        TextFormField(
                          controller: _targetSearchController,
                          decoration: InputDecoration(
                            labelText: 'الهدف / الزيارة',
                            border: const OutlineInputBorder(),
                            suffixIcon: _isSearching
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : (_selectedTarget != null
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _selectedTarget = null;
                                            _targetSearchController.clear();
                                            _searchResults = [];
                                          });
                                        },
                                      )
                                    : const Icon(Icons.search)),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                        if (_searchResults.isNotEmpty && _selectedTarget == null)
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final item = _searchResults[index];
                                return Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    title: Text(item['name'] ?? ''),
                                    subtitle: Text(item['type'] ?? ''),
                                    onTap: () {
                                      setState(() {
                                        _selectedTarget = item;
                                        _targetSearchController.text = item['name'] ?? '';
                                        _searchResults = [];
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        
                        if (_taskType == 'sales' || _taskType == 'stock')
                          products.when(
                            data: (list) => DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'المنتج', border: OutlineInputBorder()),
                              value: _selectedProductId,
                              items: list.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                              onChanged: (v) => setState(() => _selectedProductId = v),
                              validator: (v) => (_taskType == 'sales' || _taskType == 'stock') && v == null ? 'مطلوب' : null,
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const Text('فشل تحميل المنتجات'),
                          ),
                        if (_taskType == 'sales') const SizedBox(height: 16),
                        if (_taskType == 'sales')
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'الكمية المستهدفة', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => _quantity = int.tryParse(v),
                            validator: (v) => _taskType == 'sales' && (v == null || int.tryParse(v) == null) ? 'مطلوب' : null,
                          ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'الأولوية', border: OutlineInputBorder()),
                          value: _priority,
                          items: const [
                            DropdownMenuItem(value: 'normal', child: Text('عادي')),
                            DropdownMenuItem(value: 'medium', child: Text('مهم')),
                            DropdownMenuItem(value: 'urgent', child: Text('عاجل')),
                          ],
                          onChanged: (v) => setState(() => _priority = v!),
                        ),
                        const SizedBox(height: 16),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(_dueDate == null ? 'تاريخ ووقت التنفيذ' : '${intl.DateFormat('yyyy-MM-dd').format(_dueDate!)}${_scheduledTime != null ? ' - ${_scheduledTime!.format(context)}' : ''}'),
                            trailing: const Icon(Icons.calendar_today),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null && mounted) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _dueDate = date;
                                    _scheduledTime = time;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'ملاحظات', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ المهمة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى اختيار تاريخ الاستحقاق')));
      return;
    }

    setState(() => _isSaving = true);
    
    final taskData = {
      'brand_id': widget.parentRef.read(selectedBrandIdProvider),
      'rep_id': _selectedRepId!,
      'task_type': _taskType,
      'priority': _priority,
      'product_id': _selectedProductId,
      'quantity_target': _quantity,
      'due_date': _dueDate!.toIso8601String(),
      'notes': _notesController.text,
      if (_visitSubtype != null) 'visit_subtype': _visitSubtype,
      if (_purpose != null) 'purpose': _purpose,
      if (_dueDate != null && _scheduledTime != null)
        'scheduled_datetime': DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day, _scheduledTime!.hour, _scheduledTime!.minute).toIso8601String(),
    };
    
    if (_selectedTarget != null) {
      taskData['target_id'] = _selectedTarget!['id'];
      taskData['target_type'] = _selectedTarget!['type'];
      taskData['target_name'] = _selectedTarget!['name'];
    }

    try {
      await widget.parentRef.read(taskRepositoryProvider).createTask(taskData);
      widget.parentRef.invalidate(tasksProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الحفظ: $e')));
      }
    }
  }
}

class _TaskDetailsSheet extends StatefulWidget {
  final SupervisorTask task;
  final WidgetRef parentRef;
  final Function(String)? onStatusChanged;
  const _TaskDetailsSheet({required this.task, required this.parentRef, this.onStatusChanged});

  @override
  State<_TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<_TaskDetailsSheet> {
  late SupervisorTask _currentTask;
  List<dynamic> _history = [];
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _fetchHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final res = await ApiService.instance.dio.get('/tasks/${_currentTask.id}/history');
      if (mounted) {
        setState(() {
          _history = res.data as List;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }



  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف المهمة'),
          content: const Text('هل أنت متأكد من حذف هذه المهمة؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );

    if (confirm == true) {
      try {
        await widget.parentRef.read(taskRepositoryProvider).deleteTask(_currentTask.id);
        widget.parentRef.invalidate(tasksProvider);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الحذف: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color brandColor = AppColors.primary;
    if (_currentTask.brandColor != null && _currentTask.brandColor!.isNotEmpty) {
      try {
        brandColor = Color(int.parse(_currentTask.brandColor!.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: brandColor.withOpacity(0.2),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currentTask.repName ?? 'بدون مندوب', style: AppTextStyles.h3),
                          Text(_currentTask.brandName ?? '', style: AppTextStyles.bodySmall.copyWith(color: brandColor)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(_currentTask.taskType),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: _deleteTask,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('الهدف', _currentTask.targetName ?? '-'),
                      if (_currentTask.productId != null) _buildDetailRow('المنتج', _currentTask.productName ?? '-'),
                      if (_currentTask.quantityTarget != null) _buildDetailRow('الكمية المستهدفة', '${_currentTask.quantityTarget}'),
                      _buildDetailRow('تاريخ الاستحقاق', _currentTask.dueDate != null ? intl.DateFormat('yyyy-MM-dd').format(_currentTask.dueDate!) : '-'),
                      if (_currentTask.scheduledDatetime != null)
                        _buildDetailRow('موعد التنفيذ', intl.DateFormat('yyyy-MM-dd HH:mm').format(_currentTask.scheduledDatetime!.toLocal())),
                      if (_currentTask.purpose != null)
                        _buildDetailRow('الغرض', _currentTask.purposeLabel),
                      if (_currentTask.visitSubtype != null)
                        _buildDetailRow('نوع الزيارة', _currentTask.visitSubtypeLabel),
                      if (_currentTask.reminderOffset != null)
                        _buildDetailRow('التذكير', _currentTask.reminderOffset!),
                      if (_currentTask.status == 'rejected' && (_currentTask.rejectionReport != null || (_currentTask.notes != null && _currentTask.notes!.isNotEmpty)))
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withOpacity(0.5))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 100, child: Text('سبب الرفض', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                              Expanded(child: Text(_currentTask.rejectionReport ?? _currentTask.notes ?? '', style: const TextStyle(color: Colors.red))),
                            ],
                          ),
                        ),
                      if (_currentTask.status != 'rejected' && _currentTask.notes != null && _currentTask.notes!.isNotEmpty)
                        _buildDetailRow('ملاحظات المشرف', _currentTask.notes!),
                      if (_currentTask.progressNote != null && _currentTask.progressNote!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildDetailRow('ملاحظات التقدم', _currentTask.progressNote!),
                      ],
                      const Divider(height: 40),
                      Text('سجل المهمة', style: AppTextStyles.h4),
                      const SizedBox(height: 12),
                      if (_isLoadingHistory)
                        const Center(child: CircularProgressIndicator())
                      else if (_history.isEmpty)
                        const Text('لا يوجد سجل')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final h = _history[index];
                            final date = h['created_at'] != null ? intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(h['created_at'])) : '';
                            return ListTile(
                              leading: const Icon(Icons.history, color: AppColors.primary),
                              title: Text(h['action'] ?? h['status'] ?? ''),
                              subtitle: Text(date),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant))),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
