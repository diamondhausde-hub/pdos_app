import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\tasks_router.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

delete_endpoint = '''
@router.delete("/{task_id}")
def delete_task(task_id: str, db: Session = Depends(get_db), current_user: models.User = Depends(auth.require_password_set)):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    # optionally check permissions here...
    db.delete(task)
    db.commit()
    return {"ok": True}
'''
content += delete_endpoint

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added DELETE /tasks/{task_id}")
