with open('lib/core/repositories/user_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''      final payload = {
        'email': email,
        'full_name': fullName,
        'role': role.name,
        'temporary_password': temporaryPassword,
      };''', '''      final payload = {
        'email': email,
        'full_name': fullName,
        'role': role.apiValue,
        'temporary_password': temporaryPassword,
      };''')

with open('lib/core/repositories/user_repository.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
