import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix t.brandId, t.repId, t.taskType -> t?.brandId etc.
content = content.replace('t.brandId != _selectedBrand', 't?.brandId != _selectedBrand')
content = content.replace('t.repId != _selectedRep', 't?.repId != _selectedRep')
content = content.replace('t.taskType != _selectedType', 't?.taskType != _selectedType')

# Replace 'value:' inside DropdownButtonFormField to 'initialValue:'? No, DropdownButtonFormField uses 'value'. 
# Wait, the error is: "value is deprecated and shouldn't be used. Use initialValue instead. This feature was deprecated after v3.33.0-1.0.pre."
# Yes, for DropdownMenu 'value' might be deprecated, or DropdownButtonFormField 'value' is deprecated in favor of 'initialSelection' or something?
# Oh, the error says: "value is deprecated and shouldn't be used. Use initialValue instead."
# So I should change alue: to initialValue: if it's indeed DropdownMenu or whatever widget it is.

