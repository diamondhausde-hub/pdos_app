import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace _updateStatus
new_method = """  Future<void> _updateStatus(String newStatus) async {
    if (_isUpdatingStatus) return;
    setState(() => _isUpdatingStatus = true);
    try {
      final updated = await widget.parentRef.read(taskRepositoryProvider).updateTaskStatus(
        _currentTask.id, 
        newStatus,
        progressNote: _progressNoteController.text,
      );
      widget.parentRef.invalidate(tasksProvider);
      if (mounted) {
        setState(() {
          _currentTask = updated;
          _isUpdatingStatus = false;
        });
        Navigator.pop(context);
        if (widget.onStatusChanged != null) {
          widget.onStatusChanged!(newStatus);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUpdatingStatus = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل التحديث: $e')));
      }
    }
  }
"""

content = re.sub(r'Future<void> _updateStatus\(String newStatus\) async \{.*?\n  \}\n', new_method, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Replaced _updateStatus")
