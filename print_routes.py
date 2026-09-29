import sys
sys.path.append(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend')
from main import app
for route in app.routes:
    print(getattr(route, 'methods', None), getattr(route, 'path', route.name))
