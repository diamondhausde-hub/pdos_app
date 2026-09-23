import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\schemas.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

schemas_to_add = '''
class TaskBase(BaseModel):
    rep_id: str
    brand_id: str
    supervisor_id: Optional[str] = None
    task_type: str
    target_type: Optional[str] = None
    target_id: Optional[str] = None
    product_id: Optional[str] = None
    quantity_target: Optional[int] = None
    due_date: Optional[datetime] = None
    status: str = 'new'

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseModel):
    status: Optional[str] = None
    completed_at: Optional[datetime] = None

class TaskResponse(TaskBase):
    id: str
    created_at: datetime
    completed_at: Optional[datetime] = None
    class Config:
        from_attributes = True

class ActivityLogBase(BaseModel):
    rep_id: Optional[str] = None
    brand_id: str
    task_id: Optional[str] = None
    activity_type: Optional[str] = None
    target_type: Optional[str] = None
    target_id: Optional[str] = None
    notes: Optional[str] = None
    status: str = 'completed'

class ActivityLogCreate(ActivityLogBase):
    pass

class ActivityLogResponse(ActivityLogBase):
    id: str
    logged_at: datetime
    class Config:
        from_attributes = True
'''

if 'class TaskBase' not in content:
    content += schemas_to_add

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('schemas.py updated')
