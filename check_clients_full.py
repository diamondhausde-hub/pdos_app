import sqlite3
db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()
cursor.execute("PRAGMA table_info(clients);")
print(cursor.fetchall())
cursor.execute("SELECT * FROM clients;")
print(cursor.fetchall())
