import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix Arabic strings
content = content.replace(\"Text('OO O U?Oc U.UU.Oc OO_USO_Oc'\", \"Text('إضافة مهمة جديدة'\")
content = content.replace(\"labelText: 'U+U^O1 O U,U.UU.Oc'\", \"labelText: 'نوع المهمة'\")
content = content.replace(\"Text('OUSO OOc')\", \"Text('زيارة')\")
content = content.replace(\"Text('U.O\"USO1O O')\", \"Text('مبيعات')\")
content = content.replace(\"Text('OOO_')\", \"Text('جرد')\")
content = content.replace(\"labelText: 'O U,U.U+O_U^O\"'\", \"labelText: 'المندوب'\")
content = content.replace(\"'U.OU,U^O\"'\", \"'مطلوب'\")
content = content.replace(\"Text('OrOO U?US OO-U.USU, O U,U.U+O O_USO\"')\", \"Text('فشل تحميل المندوبين')\")
content = content.replace(\"labelText: 'O U,UO_U? / O U,OUSO OOc'\", \"labelText: 'الهدف / الزيارة'\")
content = content.replace(\"labelText: 'O U,U.U+OO'\", \"labelText: 'المنتج'\")
content = content.replace(\"Text('OrOO U?US OO-U.USU, O U,U.U+OOO O')\", \"Text('فشل تحميل المنتجات')\")
content = content.replace(\"labelText: 'O U,UU.USOc O U,U.O3OUO_U?Oc'\", \"labelText: 'الكمية المستهدفة'\")
content = content.replace(\"Text(_dueDate == null ? 'OO OUSOr O U,O O3OO-U,O U,' :\", \"Text(_dueDate == null ? 'تاريخ الاستحقاق' :\")
content = content.replace(\"labelText: 'U.U,O O-O,O O'\", \"labelText: 'ملاحظات'\")
content = content.replace(\"Text('O-U?O, O U,U.UU.Oc')\", \"Text('حفظ المهمة')\")
content = content.replace(\"Text('USOOU% O OrOUSO O OO OUSOr O U,O O3OO-U,O U,')\", \"Text('يرجى اختيار تاريخ الاستحقاق')\")
content = content.replace(\"Text('U?O\\'U, O U,O-U?O,: \')\", \"Text('فشل الحفظ: \')\")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print(\"Fixed Arabic strings\")
