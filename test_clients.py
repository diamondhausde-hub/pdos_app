import requests

try:
    # First we need a token. We can generate one using the backend auth endpoint if we can, 
    # but we don't have the password. Let's just create a token using jose.
    from jose import jwt
    from datetime import datetime, timedelta
    
    SECRET_KEY = "PDOS_SUPER_SECRET_KEY_NEEDS_TO_BE_LONG_ENOUGH" # Check auth.py for real key
    
    with open(r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\auth.py', 'r') as f:
        auth_code = f.read()
    
    import re
    match = re.search(r'SECRET_KEY = "([^"]+)"', auth_code)
    if match:
        SECRET_KEY = match.group(1)
        
    ALGORITHM = "HS256"
    to_encode = {"sub": "38063a08-6fff-4fd0-be60-23226b663e53"}
    expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    
    headers = {"Authorization": f"Bearer {encoded_jwt}"}
    r = requests.get("http://127.0.0.1:8000/clients", headers=headers)
    print("Status:", r.status_code)
    print("Response:", r.json())
except Exception as e:
    print(e)
