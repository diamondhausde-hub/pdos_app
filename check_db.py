import sqlite3

db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

cursor.execute("PRAGMA table_info(activity_logs);")
columns = cursor.fetchall()
print("Columns in activity_logs:")
for col in columns:
    print(col[1])

