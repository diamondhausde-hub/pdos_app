import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\models.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace Task
content = content.replace(
'''class Task(Base):
    __tablename__ = "tasks"

    id = Column(String, primary_key=True, default=generate_uuid)
    rep_id = Column(String, ForeignKey("users.id"), nullable=False)
    brand_id = Column(String, ForeignKey("brands.id"), nullable=False)
    supervisor_id = Column(String, ForeignKey("users.id"), nullable=True)
    task_type = Column(String(30), nullable=False)
    target_type = Column(String(20), nullable=True)
    target_id = Column(String, nullable=True)
    product_id = Column(String, ForeignKey("products.id"), nullable=True)
    quantity_target = Column(Integer, nullable=True)
    due_date = Column(DateTime, nullable=True)
    status = Column(String(20), default='new')
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)''',
'''class Task(Base):
    __tablename__ = "tasks"

    id = Column(String, primary_key=True, default=generate_uuid)
    rep_id = Column(String, ForeignKey("users.id"), nullable=False)
    brand_id = Column(String, ForeignKey("brands.id"), nullable=False)
    supervisor_id = Column(String, ForeignKey("users.id"), nullable=True)
    task_type = Column(String(30), nullable=False)
    target_type = Column(String(20), nullable=True)
    target_id = Column(String, nullable=True)
    product_id = Column(String, ForeignKey("products.id"), nullable=True)
    quantity_target = Column(Integer, nullable=True)
    due_date = Column(DateTime, nullable=True)
    status = Column(String(20), default='new')
    priority = Column(String(20), nullable=True, default='normal')
    progress_note = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    rep = relationship("User", foreign_keys=[rep_id])
    brand = relationship("Brand", foreign_keys=[brand_id])
    supervisor = relationship("User", foreign_keys=[supervisor_id])'''
)

# Replace BrandActivityLog
content = content.replace(
'''class BrandActivityLog(Base):
    __tablename__ = "brand_activity_logs"

    id = Column(String, primary_key=True, default=generate_uuid)
    rep_id = Column(String, ForeignKey("users.id"), nullable=True)
    brand_id = Column(String, ForeignKey("brands.id"), nullable=False)
    task_id = Column(String, ForeignKey("tasks.id"), nullable=True)
    activity_type = Column(String(30), nullable=True)
    target_type = Column(String(20), nullable=True)
    target_id = Column(String, nullable=True)
    logged_at = Column(DateTime, default=datetime.datetime.utcnow)
    notes = Column(Text, nullable=True)
    status = Column(String(20), default='completed')''',
'''class BrandActivityLog(Base):
    __tablename__ = "brand_activity_logs"

    id = Column(String, primary_key=True, default=generate_uuid)
    rep_id = Column(String, ForeignKey("users.id"), nullable=True)
    brand_id = Column(String, ForeignKey("brands.id"), nullable=False)
    task_id = Column(String, ForeignKey("tasks.id"), nullable=True)
    activity_type = Column(String(30), nullable=True)
    target_type = Column(String(20), nullable=True)
    target_id = Column(String, nullable=True)
    logged_at = Column(DateTime, default=datetime.datetime.utcnow)
    notes = Column(Text, nullable=True)
    status = Column(String(20), default='completed')

    rep = relationship("User", foreign_keys=[rep_id])
    brand = relationship("Brand", foreign_keys=[brand_id])'''
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)


schemas_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\schemas.py'
with open(schemas_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(
'''class BrandActivityLogResponse(BrandActivityLogBase):
    id: str
    logged_at: datetime
    class Config:
        from_attributes = True''',
'''class BrandActivityLogResponse(BrandActivityLogBase):
    id: str
    logged_at: datetime
    rep_name: Optional[str] = None
    brand_name: Optional[str] = None
    class Config:
        from_attributes = True'''
)
with open(schemas_path, 'w', encoding='utf-8') as f:
    f.write(content)
