import sqlite3

db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

cursor.execute("SELECT id, facility_name, doctor_name, client_type FROM clients LIMIT 10;")
rows = cursor.fetchall()
print(f"Total clients in DB: {len(rows)}")
for row in rows:
    print(row)

