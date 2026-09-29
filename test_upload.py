import requests
url = 'http://127.0.0.1:8000/users/38063a08-6fff-4fd0-be60-23226b663e53/upload-photo'
files = {'file': ('test.jpg', b'dummy content', 'image/jpeg')}
try:
    response = requests.post(url, files=files)
    print('POST Status:', response.status_code)
    print('POST Response:', response.text)
except Exception as e:
    print('Error:', e)
