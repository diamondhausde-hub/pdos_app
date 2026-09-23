import sqlite3
conn = sqlite3.connect(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db')
cursor = conn.cursor()
cursor.execute("SELECT id, email, role, supervisor_id FROM users")
for r in cursor.fetchall():
    print(r)
