import sys
import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Fix overflow in Kanban board
old_rep_row = '''Row(
                                          children: [
                                            Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                                            const SizedBox(width: 4),
                                            Text(task.repName ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                          ],
                                        )'''
new_rep_row = '''Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                                              const SizedBox(width: 4),
                                              Flexible(child: Text(task.repName ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                        )'''
content = content.replace(old_rep_row, new_rep_row)


# 2. Add Delete button to _showTaskDetails
old_details_top = '''void _showTaskDetails(SupervisorTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: ['''
new_details_top = '''void _showTaskDetails(SupervisorTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Task Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Task?'),
                            content: const Text('Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ref.read(taskRepositoryProvider).deleteTask(task.id);
                          ref.invalidate(tasksProvider);
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: ['''
content = content.replace(old_details_top, new_details_top)


# 3. Fix _AddTaskForm
old_form = '''class _AddTaskFormState extends ConsumerState<_AddTaskForm> {
  String _taskType = 'visit';
  final _noteCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(); 
  final _productCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {'''
new_form = '''class _AddTaskFormState extends ConsumerState<_AddTaskForm> {
  String _taskType = 'visit';
  String? _selectedBrandId;
  String? _selectedRepId;
  final _noteCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(); 
  final _productCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(myTeamProvider);
    final brandsAsync = ref.watch(brandsProvider);'''
content = content.replace(old_form, new_form)

old_form_body_1 = '''              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'O"OO U+O_ (Brand)'),
                items: const [
                  DropdownMenuItem(value: 'brand_a', child: Text('O"OO U+O_ A')),
                  DropdownMenuItem(value: 'brand_b', child: Text('O"OO U+O_ B')),
                ],
                onChanged: (val) {},
              ),'''
old_form_body_1_utf8 = '''              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'براند (Brand)'),
                items: const [
                  DropdownMenuItem(value: 'brand_a', child: Text('براند A')),
                  DropdownMenuItem(value: 'brand_b', child: Text('براند B')),
                ],
                onChanged: (val) {},
              ),'''

# Let's just use regex to replace the mock dropdowns up to TextField _noteCtrl
content = re.sub(r'if \(_taskType == \'visit\'\) \.\.\.\[.*?const SizedBox\(height: 12\),', 
'''if (_taskType == 'visit') ...[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Brand'),
                value: _selectedBrandId,
                items: brandsAsync.maybeWhen(
                  data: (brands) => brands.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                  orElse: () => [],
                ),
                onChanged: (val) => setState(() => _selectedBrandId = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Rep (Assign to)'),
                value: _selectedRepId,
                items: teamAsync.maybeWhen(
                  data: (team) => team.map((u) => DropdownMenuItem(value: u.id, child: Text(u.fullName))).toList(),
                  orElse: () => [],
                ),
                onChanged: (val) => setState(() => _selectedRepId = val),
              ),
              const SizedBox(height: 12),''', content, flags=re.DOTALL)

old_save = '''                  final newTaskData = <String, dynamic>{
                    'rep_id': 'rep_1', // In a real app, this should come from a dropdown
                    'brand_id': 'brand_a', // And this
                    'task_type': _taskType,
                    'status': 'new',
                  };'''
new_save = '''                  if (_selectedRepId == null || _selectedBrandId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Brand and Rep')));
                    return;
                  }
                  final newTaskData = <String, dynamic>{
                    'rep_id': _selectedRepId,
                    'brand_id': _selectedBrandId,
                    'task_type': _taskType,
                    'status': 'new',
                  };'''
content = content.replace(old_save, new_save)


with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated successfully")
