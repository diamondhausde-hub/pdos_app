import sys

router_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\misc_router.py'
with open(router_path, 'r', encoding='utf-8') as f:
    content = f.read()

import re

# Update get_clients
old_get_clients = '''@router.get("/clients", response_model=List[schemas.ClientResponse])
def get_clients(
    rep_id: Optional[str] = None,
    limit: int = 50,
    offset: int = 0,
    current_user: models.User = Depends(auth.require_password_set),
    db: Session = Depends(get_db),
):
    rep_ids = get_role_scoped_rep_ids(current_user, db)
    query = db.query(models.Client)
    if rep_ids is not None:
        query = query.filter(models.Client.rep_id.in_(rep_ids))
    if rep_id:
        query = query.filter(models.Client.rep_id == rep_id)
    return query.offset(offset).limit(limit).all()'''

new_get_clients = '''@router.get("/clients", response_model=List[schemas.ClientResponse])
def get_clients(
    rep_id: Optional[str] = None,
    brand_id: Optional[str] = None,
    limit: int = 100,
    offset: int = 0,
    current_user: models.User = Depends(auth.require_password_set),
    db: Session = Depends(get_db),
):
    query = db.query(models.Client)
    
    if current_user.role not in ("admin", "general_manager"):
        user_brand_ids = [b.id for b in current_user.brands]
        if current_user.brand_id and current_user.brand_id not in user_brand_ids:
            user_brand_ids.append(current_user.brand_id)
        query = query.filter(models.Client.brand_id.in_(user_brand_ids))
        
    if brand_id:
        query = query.filter(models.Client.brand_id == brand_id)
    if rep_id:
        query = query.filter(models.Client.rep_id == rep_id)
        
    return query.offset(offset).limit(limit).all()'''

content = content.replace(old_get_clients, new_get_clients)

with open(router_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("misc_router.py updated.")
