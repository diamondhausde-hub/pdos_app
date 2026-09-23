import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\start_unscheduled_visit_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove doctor filter
content = content.replace("if (type == 'doctor') return false; // Doctors don't do unscheduled visits", "")

# 2. Add doctor to search filter logic
content = content.replace("if (_typeFilter == 'Pharmacies' && type != 'pharmacy') return false;", "if (_typeFilter == 'Doctors' && type != 'doctor') return false;\n              if (_typeFilter == 'Pharmacies' && type != 'pharmacy') return false;")

# 3. Add Doctors chip
chip_code = '''ChoiceChip(
                        label: const Text('Doctors'),
                        selected: _typeFilter == 'Doctors',
                        onSelected: (b) { if (b) setState(() => _typeFilter = 'Doctors'); },
                        avatar: Icon(Icons.person_rounded, size: 18, color: _typeFilter == 'Doctors' ? Colors.white : null),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: _typeFilter == 'Doctors' ? Colors.white : null),
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      const SizedBox(width: 8),'''

content = content.replace("ChoiceChip(\n                        label: const Text(AppStrings.pharmacies),", chip_code + "\n                      ChoiceChip(\n                        label: const Text(AppStrings.pharmacies),")

# 4. Fix route for New Client
content = content.replace("if (_typeFilter == 'Pharmacies') q = '?type=pharmacy';", "if (_typeFilter == 'Doctors') q = '?type=doctor';\n                              if (_typeFilter == 'Pharmacies') q = '?type=pharmacy';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("start_unscheduled_visit_screen.dart fixed")
