import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\supervisor_home_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will use a regex to remove the first two _buildActionCard from the Wrap.
# Looking for:
#                 _buildActionCard(
#                   context: context,
#                   width: cardWidth,
#                   icon: Icons.group_add_rounded,
#                   ...
#                 ),
#                 _buildActionCard(
#                   context: context,
#                   ... Icons.add_business_rounded ...
#                 ),

pattern = r"                _buildActionCard\(\s*context: context,\s*width: cardWidth,\s*icon: Icons.group_add_rounded,.*?\),\s*_buildActionCard\(\s*context: context,\s*width: cardWidth,\s*icon: Icons.add_business_rounded,.*?\),\s*"

content = re.sub(pattern, "", content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Removed buttons")
