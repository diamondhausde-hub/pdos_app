import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update _TaskManagementScreenState build to pass onStatusChanged
content = content.replace("return _TaskCard(task: task);", "return _TaskCard(task: task, onStatusChanged: (status) {\n                if (status == 'new') _tabController.animateTo(1);\n                else if (status == 'in_progress') _tabController.animateTo(2);\n                else if (status == 'done') _tabController.animateTo(3);\n              });")

# 2. Update _TaskCard
content = content.replace("class _TaskCard extends ConsumerWidget {\n  final SupervisorTask task;\n  const _TaskCard({required this.task});", "class _TaskCard extends ConsumerWidget {\n  final SupervisorTask task;\n  final Function(String)? onStatusChanged;\n  const _TaskCard({required this.task, this.onStatusChanged});")

# 3. Update _showTaskDetails in _TaskCard
content = content.replace("builder: (context) => _TaskDetailsSheet(task: task, parentRef: ref),", "builder: (context) => _TaskDetailsSheet(task: task, parentRef: ref, onStatusChanged: onStatusChanged),")

# 4. Update _TaskDetailsSheet
content = content.replace("class _TaskDetailsSheet extends StatefulWidget {\n  final SupervisorTask task;\n  final WidgetRef parentRef;\n  const _TaskDetailsSheet({required this.task, required this.parentRef});", "class _TaskDetailsSheet extends StatefulWidget {\n  final SupervisorTask task;\n  final WidgetRef parentRef;\n  final Function(String)? onStatusChanged;\n  const _TaskDetailsSheet({required this.task, required this.parentRef, this.onStatusChanged});")

# 5. Update _updateStatus in _TaskDetailsSheet
new_update = """      try {
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
          // Close sheet and animate to new tab
          Navigator.pop(context);
          if (widget.onStatusChanged != null) {
            widget.onStatusChanged!(newStatus);
          }
        }
      } catch (e) {"""

old_update = """      try {
        final updated = await widget.parentRef.read(taskRepositoryProvider).updateTaskStatus(
          _currentTask.id, 
          newStatus,
          progressNote: _progressNoteController.text,
        );
        widget.parentRef.invalidate(tasksProvider);
        setState(() {
          _currentTask = updated;
          _isUpdatingStatus = false;
        });
        _fetchHistory();
      } catch (e) {"""

content = content.replace(old_update, new_update)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated task management screen callbacks")
