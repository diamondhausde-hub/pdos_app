file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\supervisor_home_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

start = content.find('final cardWidth')
end = content.find('],', start) + 2
print(content[start:end+200].encode('utf-8', 'ignore'))
