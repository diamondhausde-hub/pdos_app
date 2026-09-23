from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import sys
sys.path.append(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend')
import models, schemas

engine = create_engine('sqlite:///C:/Users/prot/Documents/PDOS/PDOS-Python-Backend/pdos.db')
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

clients = db.query(models.Client).all()
for c in clients:
    try:
        resp = schemas.ClientResponse.from_orm(c)
        print(resp.json())
    except Exception as e:
        print(f'Error on {c.id}: {e}')
