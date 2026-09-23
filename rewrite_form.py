import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# The build method of _AddTaskFormState starts around line 457, let's find it exactly
start_idx = -1
end_idx = -1
for i, line in enumerate(lines):
    if 'Widget build(BuildContext context) {' in line and 'final teamAsync = ref.watch(myTeamProvider);' in lines[i+1]:
        start_idx = i
        break

for i in range(start_idx, len(lines)):
    if 'class _' in lines[i] or i == len(lines) - 1:
        # We need to find the end of the build method. It ends with the end of the class.
        pass

# Actually, _AddTaskFormState is the last class in the file.
end_idx = len(lines)

new_build = '''  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(myTeamProvider);
    final brandsAsync = ref.watch(brandsProvider);
    
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
            const Text('إضافة مهمة جديدة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _taskType,
              decoration: const InputDecoration(labelText: 'نوع المهمة'),
              items: const [
                DropdownMenuItem(value: 'visit', child: Text('زيارة (Visit)')),
                DropdownMenuItem(value: 'target', child: Text('تحقيق منتج (Target)')),
                DropdownMenuItem(value: 'event', child: Text('فعالية (Event)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _taskType = val);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'البراند (Brand)'),
              value: _selectedBrandId,
              items: brandsAsync.maybeWhen(
                data: (brands) => brands.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                orElse: () => [],
              ),
              onChanged: (val) => setState(() => _selectedBrandId = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'المندوب (Assign to)'),
              value: _selectedRepId,
              items: teamAsync.maybeWhen(
                data: (team) => team.map((u) => DropdownMenuItem(value: u.id, child: Text(u.fullName))).toList(),
                orElse: () => [],
              ),
              onChanged: (val) => setState(() => _selectedRepId = val),
            ),
            const SizedBox(height: 16),
            
            if (_taskType == 'visit') ...[
              TextField(
                controller: _targetCtrl,
                decoration: const InputDecoration(labelText: 'اسم الطبيب / المركز'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'ملاحظة للمندوب (اختياري)'),
              ),
            ] else if (_taskType == 'target') ...[
              TextField(
                controller: _productCtrl,
                decoration: const InputDecoration(labelText: 'المنتج'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'الكمية المستهدفة'),
              ),
            ] else if (_taskType == 'event') ...[
              TextField(
                controller: _targetCtrl,
                decoration: const InputDecoration(labelText: 'اسم الفعالية / المكان'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteCtrl, 
                decoration: const InputDecoration(labelText: 'تفاصيل إضافية'),
              ),
            ],
            
            if (_taskType == 'target' || _taskType == 'event') ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_selectedDate == null ? 'تاريخ التسليم / الفعالية' : _selectedDate!.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
            ],
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedRepId == null || _selectedBrandId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المندوب والبراند')));
                    return;
                  }
                  final newTaskData = <String, dynamic>{
                    'rep_id': _selectedRepId,
                    'brand_id': _selectedBrandId,
                    'task_type': _taskType,
                    'status': 'new',
                  };
                  if (_taskType == 'visit' || _taskType == 'event') {
                    newTaskData['target_name'] = _targetCtrl.text;
                    if (_noteCtrl.text.isNotEmpty) newTaskData['notes'] = _noteCtrl.text;
                  }
                  if (_taskType == 'target') {
                    newTaskData['product_name'] = _productCtrl.text;
                    if (_qtyCtrl.text.isNotEmpty) newTaskData['quantity_target'] = int.tryParse(_qtyCtrl.text);
                  }
                  if (_selectedDate != null) {
                    newTaskData['due_date'] = _selectedDate!.toIso8601String();
                  }
                  
                  Navigator.pop(context, newTaskData);
                },
                child: const Text('إضافة المهمة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'''

new_lines = lines[:start_idx] + [new_build]
with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
print("Complete rewrite of _AddTaskFormState build method!")
