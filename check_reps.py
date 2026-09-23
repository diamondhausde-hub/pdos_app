import sqlite3
conn = sqlite3.connect(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db')
cursor = conn.cursor()
cursor.execute("SELECT email, full_name, role, brand_id FROM users WHERE role='rep'")
for r in cursor.fetchall():
    print(r)
