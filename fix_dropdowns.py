with open("lib/features/shared/screens/client_form_screen.dart", "r", encoding="utf-8") as f:
    content = f.read()

# Fix _specialties
content = content.replace(
    "items: _specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),",
    "items: [..._specialties, if (_specialty != null && !_specialties.contains(_specialty)) _specialty!].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),"
)

# Fix classTier
content = content.replace(
    "items: ['A', 'B', 'C', 'D'].map((c) => DropdownMenuItem(value: c, child: Text('Class $c'))).toList(),",
    "items: ['A', 'B', 'C', 'D', if (_classTier != null && !['A', 'B', 'C', 'D'].contains(_classTier)) _classTier!].map((c) => DropdownMenuItem(value: c, child: Text('Class $c'))).toList(),"
)

# Fix relationshipType
content = content.replace(
    "items: _relationshipTypes.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),",
    "items: [..._relationshipTypes, if (_relationshipType != null && !_relationshipTypes.contains(_relationshipType)) _relationshipType!].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),"
)

# Fix facilityType
content = content.replace(
    "items: _facilityTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),",
    "items: [..._facilityTypes, if (_facilityType != null && !_facilityTypes.contains(_facilityType)) _facilityType!].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),"
)

with open("lib/features/shared/screens/client_form_screen.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Done")
