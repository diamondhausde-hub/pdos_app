import sqlite3

db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Create tasks table
cursor.execute('''
CREATE TABLE IF NOT EXISTS tasks (
    id VARCHAR PRIMARY KEY,
    rep_id VARCHAR NOT NULL REFERENCES users(id),
    brand_id VARCHAR NOT NULL REFERENCES brands(id),
    supervisor_id VARCHAR REFERENCES users(id),
    task_type VARCHAR(30) NOT NULL,
    target_type VARCHAR(20),
    target_id VARCHAR,
    product_id VARCHAR REFERENCES products(id),
    quantity_target INTEGER,
    due_date DATE,
    status VARCHAR(20) DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);
''')

# Create activity_logs table
cursor.execute('''
CREATE TABLE IF NOT EXISTS activity_logs (
    id VARCHAR PRIMARY KEY,
    rep_id VARCHAR REFERENCES users(id),
    brand_id VARCHAR NOT NULL REFERENCES brands(id),
    task_id VARCHAR REFERENCES tasks(id),
    activity_type VARCHAR(30),
    target_type VARCHAR(20),
    target_id VARCHAR,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'completed'
);
''')

conn.commit()
conn.close()
print('SQLite tables created.')
