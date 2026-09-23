import sqlite3

db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

try:
    cursor.execute("ALTER TABLE clients ADD COLUMN brand_id VARCHAR REFERENCES brands(id);")
except Exception as e:
    print(f"Error adding column: {e}")

# Assign a brand_id to existing clients based on the rep's primary brand_id
cursor.execute("UPDATE clients SET brand_id = (SELECT brand_id FROM users WHERE users.id = clients.rep_id) WHERE brand_id IS NULL;")
conn.commit()
print("Backend DB altered successfully.")
