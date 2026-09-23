import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the mess in _AddTaskFormState
old_mess = '''if (_taskType == 'visit') ...[
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
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'O"OO U+O_ (Brand)'),
                items: const [
                  DropdownMenuItem(value: 'brand_a', child: Text('O"OO U+O_ A')),
                  DropdownMenuItem(value: 'brand_b', child: Text('O"OO U+O_ B')),
                ],
                onChanged: (val) {},
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'U.U,O O-O,Oc U,U,U.U+O_U^O"'),
              ),
            ]'''

# Restore the targetCtrl and noteCtrl, and put the Brand/Rep dropdowns OUTSIDE the if (_taskType == 'visit') so they apply to ALL task types!
new_mess = '''
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
                decoration: const InputDecoration(labelText: 'المندوب (Rep)'),
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
              ]'''

content = content.replace(old_mess, new_mess)

# Wait, if there are target and event blocks, we need to check if the mockup brand was also there?
# No, DeepCoder only put the mock brand in the isit block.

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed _AddTaskForm")
