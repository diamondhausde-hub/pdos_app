import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# We need to replace class _AddTaskSheetState extends State<_AddTaskSheet> ...
# down to the end of _save() method.

# Find start of class
start_idx = content.find('class _AddTaskSheetState extends State<_AddTaskSheet> {')
# Find the end of _save method (which ends with class _TaskDetailsSheet extends StatefulWidget {)
end_idx = content.find('class _TaskDetailsSheet extends StatefulWidget {')

if start_idx == -1 or end_idx == -1:
    print("Could not find start or end index.")
    exit(1)

new_state_code = '''class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRepId;
  String? _selectedProductId;
  String _taskType = 'sales';
  int? _quantity;
  DateTime? _dueDate;
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
                Text('OO O U?Oc U.UU.Oc OO_USO_Oc', style: AppTextStyles.h3, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'U+U^O1 O U,U.UU.Oc', border: OutlineInputBorder()),
                          value: _taskType,
                          items: const [
                            DropdownMenuItem(value: 'visit', child: Text('OUSO OOc')),
                            DropdownMenuItem(value: 'sales', child: Text('U.O"USO1O O')),
                            DropdownMenuItem(value: 'stock', child: Text('OOO_')),
                          ],
                          onChanged: (v) => setState(() => _taskType = v!),
                        ),
                        const SizedBox(height: 16),
                        reps.when(
                          data: (list) => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'O U,U.U+O_U^O"', border: OutlineInputBorder()),
                            value: _selectedRepId,
                            items: list.map((r) => DropdownMenuItem(value: r.id, child: Text(r.fullName))).toList(),
                            onChanged: (v) => setState(() => _selectedRepId = v),
                            validator: (v) => v == null ? 'U.OU,U^O"' : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const Text('OrOO U?US OO-U.USU, O U,U.U+O O_USO"'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Target Search Autocomplete
                        TextFormField(
                          controller: _targetSearchController,
                          decoration: InputDecoration(
                            labelText: 'O U,UO_U? / O U,OUSO OOc',
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
                              decoration: const InputDecoration(labelText: 'O U,U.U+OO', border: OutlineInputBorder()),
                              value: _selectedProductId,
                              items: list.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                              onChanged: (v) => setState(() => _selectedProductId = v),
                              validator: (v) => (_taskType == 'sales' || _taskType == 'stock') && v == null ? 'U.OU,U^O"' : null,
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const Text('OrOO U?US OO-U.USU, O U,U.U+OOO O'),
                          ),
                        if (_taskType == 'sales') const SizedBox(height: 16),
                        if (_taskType == 'sales')
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'O U,UU.USOc O U,U.O3OUO_U?Oc', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => _quantity = int.tryParse(v),
                            validator: (v) => _taskType == 'sales' && (v == null || int.tryParse(v) == null) ? 'U.OU,U^O"' : null,
                          ),
                        const SizedBox(height: 16),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(_dueDate == null ? 'OO OUSOr O U,O O3OO-U,O U,' : intl.DateFormat('yyyy-MM-dd').format(_dueDate!)),
                            trailing: const Icon(Icons.calendar_today),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() => _dueDate = date);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'U.U,O O-O,O O', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('O-U?O, O U,U.UU.Oc'),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('USOOU% O OrOUSO O OO OUSOr O U,O O3OO-U,O U,')));
      return;
    }

    setState(() => _isSaving = true);
    
    final taskData = {
      'rep_id': _selectedRepId!,
      'task_type': _taskType,
      'product_id': _selectedProductId,
      'quantity_target': _quantity,
      'due_date': _dueDate!.toIso8601String(),
      'notes': _notesController.text,
    };
    
    if (_selectedTarget != null) {
      taskData['target_id'] = _selectedTarget!['id'];
      taskData['target_type'] = _selectedTarget!['type'];
    }

    try {
      await widget.parentRef.read(taskRepositoryProvider).createTask(taskData);
      widget.parentRef.invalidate(tasksProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('U?O'U, O U,O-U?O,: ')));
      }
    }
  }
}

'''

content = content[:start_idx] + new_state_code + content[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Rewrote _AddTaskSheetState")
