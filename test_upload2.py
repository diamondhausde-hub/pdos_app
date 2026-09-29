import requests
url = 'http://127.0.0.1:8000/users/38063a08-6fff-4fd0-be60-23226b663e53/upload-photo'
print(requests.post(url).text)
