import os

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\tasks_router.py'

router_code = '''
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
import datetime

from database import get_db
import models
import schemas
from auth import get_current_user

router = APIRouter(prefix="/tasks", tags=["Tasks & Activity Logs"])

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

@router.post("/logs", response_model=schemas.ActivityLogResponse)
def create_activity_log(log: schemas.ActivityLogCreate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    db_log = models.ActivityLog(**log.dict())
    if not db_log.rep_id:
        db_log.rep_id = current_user.id
    db.add(db_log)
    
    # Auto-link to task completion if task_id provided
    if db_log.task_id:
        db_task = db.query(models.Task).filter(models.Task.id == db_log.task_id).first()
        if db_task and db_task.status != 'done':
            db_task.status = 'done'
            db_task.completed_at = datetime.datetime.utcnow()
            
    db.commit()
    db.refresh(db_log)
    return db_log

@router.get("/logs", response_model=List[schemas.ActivityLogResponse])
def get_activity_logs(brand_id: Optional[str] = None, rep_id: Optional[str] = None, date_filter: Optional[str] = None, db: Session = Depends(get_db)):
    query = db.query(models.ActivityLog)
    if brand_id:
        query = query.filter(models.ActivityLog.brand_id == brand_id)
    if rep_id:
        query = query.filter(models.ActivityLog.rep_id == rep_id)
        
    if date_filter == 'today':
        today = datetime.datetime.utcnow().date()
        query = query.filter(models.ActivityLog.logged_at >= today)
    elif date_filter == 'week':
        week_ago = datetime.datetime.utcnow() - datetime.timedelta(days=7)
        query = query.filter(models.ActivityLog.logged_at >= week_ago)
    elif date_filter == 'month':
        month_ago = datetime.datetime.utcnow() - datetime.timedelta(days=30)
        query = query.filter(models.ActivityLog.logged_at >= month_ago)
        
    return query.order_by(models.ActivityLog.logged_at.desc()).all()

'''

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(router_code)

print('tasks_router.py created')
