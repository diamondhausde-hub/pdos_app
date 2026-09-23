import sqlite3
import bcrypt

conn = sqlite3.connect(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db')
cursor = conn.cursor()

# Hashed password for '12345678'
hashed = bcrypt.hashpw('12345678'.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

# Update rep and supervisor
rep_id = '38063a08-6fff-4fd0-be60-23226b663e53'
sup_id = 'bf6244c0-14e5-48c9-b8a5-d78ee2adc203'
cebelia = '11111111-cebe-lia0-0000-000000000001'
gamarde = '22222222-gama-rde0-0000-000000000002'

cursor.execute("UPDATE users SET hashed_password = ? WHERE id IN (?, ?)", (hashed, rep_id, sup_id))

# Add to user_brands (ignore if already exists)
cursor.execute("INSERT OR IGNORE INTO user_brands (user_id, brand_id) VALUES (?, ?)", (rep_id, cebelia))
cursor.execute("INSERT OR IGNORE INTO user_brands (user_id, brand_id) VALUES (?, ?)", (rep_id, gamarde))
cursor.execute("INSERT OR IGNORE INTO user_brands (user_id, brand_id) VALUES (?, ?)", (sup_id, cebelia))
cursor.execute("INSERT OR IGNORE INTO user_brands (user_id, brand_id) VALUES (?, ?)", (sup_id, gamarde))

conn.commit()
print("Passwords updated and brands linked.")
