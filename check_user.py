import sqlite3
conn = sqlite3.connect(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db')
cursor = conn.cursor()
cursor.execute('SELECT id, name FROM users WHERE id = "38063a08-6fff-4fd0-be60-23226b663e53"')
print(cursor.fetchall())
