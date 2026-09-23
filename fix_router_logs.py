import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\tasks_router.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old_get_logs = '''@router.get("/logs", response_model=List[schemas.BrandActivityLogResponse])
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
        
    return query.order_by(models.BrandActivityLog.logged_at.desc()).all()'''

new_get_logs = '''@router.get("/logs", response_model=List[schemas.BrandActivityLogResponse])
def get_activity_logs(brand_id: Optional[str] = None, rep_id: Optional[str] = None, date_filter: Optional[str] = None, db: Session = Depends(get_db)):
    from sqlalchemy.orm import joinedload
    query = db.query(models.BrandActivityLog).options(
        joinedload(models.BrandActivityLog.rep),
        joinedload(models.BrandActivityLog.brand)
    )
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
        
    logs = query.order_by(models.BrandActivityLog.logged_at.desc()).all()
    result = []
    for l in logs:
        d = {c.name: getattr(l, c.name) for c in l.__table__.columns}
        d['rep_name'] = l.rep.full_name if l.rep else None
        d['brand_name'] = l.brand.name if l.brand else None
        result.append(schemas.BrandActivityLogResponse(**d))
    return result'''

content = content.replace(old_get_logs, new_get_logs)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("tasks_router.py fixed")
