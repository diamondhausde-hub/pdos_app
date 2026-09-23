file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\supervisor_home_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

start = content.find('إضافة طبيب')
print(content[max(0, start-400):start+400].encode('utf-8', 'ignore'))
