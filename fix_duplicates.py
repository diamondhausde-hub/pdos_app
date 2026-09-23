import os

models_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\models.py'
with open(models_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Find the start of the Task and ActivityLog block I appended
start_idx = content.find('class Task(Base):\n    __tablename__ = "tasks"')
if start_idx != -1:
    content = content[:start_idx] # Remove the appended block

# Add back Task and BrandActivityLog
new_models = '''class Task(Base):
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
    completed_at = Column(DateTime, nullable=True)

class BrandActivityLog(Base):
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
'''
content += new_models
with open(models_path, 'w', encoding='utf-8') as f:
    f.write(content)


schemas_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\schemas.py'
with open(schemas_path, 'r', encoding='utf-8') as f:
    content = f.read()

start_idx = content.find('class TaskBase(BaseModel):')
if start_idx != -1:
    content = content[:start_idx]

new_schemas = '''class TaskBase(BaseModel):
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

class BrandActivityLogBase(BaseModel):
    rep_id: Optional[str] = None
    brand_id: str
    task_id: Optional[str] = None
    activity_type: Optional[str] = None
    target_type: Optional[str] = None
    target_id: Optional[str] = None
    notes: Optional[str] = None
    status: str = 'completed'

class BrandActivityLogCreate(BrandActivityLogBase):
    pass

class BrandActivityLogResponse(BrandActivityLogBase):
    id: str
    logged_at: datetime
    class Config:
        from_attributes = True
'''
content += new_schemas
with open(schemas_path, 'w', encoding='utf-8') as f:
    f.write(content)


router_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\tasks_router.py'
router_code = '''from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
import datetime

from database import get_db
import models
import schemas
from auth import get_current_user

router = APIRouter(prefix="/tasks", tags=["Tasks & Brand Activity Logs"])

@router.post("/", response_model=schemas.TaskResponse)
def create_task(task: schemas.TaskCreate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    db_task = models.Task(**task.dict())
    if not db_task.supervisor_id:
        db_task.supervisor_id = current_user.id
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/", response_model=List[schemas.TaskResponse])
def get_tasks(rep_id: Optional[str] = None, brand_id: Optional[str] = None, db: Session = Depends(get_db)):
    query = db.query(models.Task)
    if rep_id:
        query = query.filter(models.Task.rep_id == rep_id)
    if brand_id:
        query = query.filter(models.Task.brand_id == brand_id)
    return query.order_by(models.Task.created_at.desc()).all()

@router.patch("/{task_id}", response_model=schemas.TaskResponse)
def update_task_status(task_id: str, task_update: schemas.TaskUpdate, db: Session = Depends(get_db)):
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    if task_update.status:
        db_task.status = task_update.status
        if task_update.status == 'done' and not db_task.completed_at:
            db_task.completed_at = datetime.datetime.utcnow()
    
    db.commit()
    db.refresh(db_task)
    return db_task

@router.post("/logs", response_model=schemas.BrandActivityLogResponse)
def create_activity_log(log: schemas.BrandActivityLogCreate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    db_log = models.BrandActivityLog(**log.dict())
    if not db_log.rep_id:
        db_log.rep_id = current_user.id
    db.add(db_log)
    
    if db_log.task_id:
        db_task = db.query(models.Task).filter(models.Task.id == db_log.task_id).first()
        if db_task and db_task.status != 'done':
            db_task.status = 'done'
            db_task.completed_at = datetime.datetime.utcnow()
            
    db.commit()
    db.refresh(db_log)
    return db_log

@router.get("/logs", response_model=List[schemas.BrandActivityLogResponse])
def get_activity_logs(brand_id: Optional[str] = None, rep_id: Optional[str] = None, date_filter: Optional[str] = None, db: Session = Depends(get_db)):
    query = db.query(models.BrandActivityLog)
    if brand_id:
        query = query.filter(models.BrandActivityLog.brand_id == brand_id)
    if rep_id:
        query = query.filter(models.BrandActivityLog.rep_id == rep_id)
        
    if date_filter == 'today':
        today = datetime.datetime.utcnow().date()
        query = query.filter(models.BrandActivityLog.logged_at >= today)
    elif date_filter == 'week':
        week_ago = datetime.datetime.utcnow() - datetime.timedelta(days=7)
        query = query.filter(models.BrandActivityLog.logged_at >= week_ago)
    elif date_filter == 'month':
        month_ago = datetime.datetime.utcnow() - datetime.timedelta(days=30)
        query = query.filter(models.BrandActivityLog.logged_at >= month_ago)
        
    return query.order_by(models.BrandActivityLog.logged_at.desc()).all()
'''
with open(router_path, 'w', encoding='utf-8') as f:
    f.write(router_code)

import sqlite3
db_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\pdos.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()
cursor.execute('''
CREATE TABLE IF NOT EXISTS brand_activity_logs (
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

print('All Python backend files updated and DB created.')
