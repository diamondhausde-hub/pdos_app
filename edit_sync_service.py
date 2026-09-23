import re

with open('lib/core/services/sync_service.dart', 'r', encoding='utf-8') as f:
    text = f.read()

original = '''            if (r.photoPath != null && r.photoPath!.isNotEmpty) {
              final file = File(r.photoPath!);
              if (await file.exists()) {
                final form = FormData.fromMap({
                  'file': await MultipartFile.fromFile(file.path),
                });
                try {
                  final uploadRes = await _dio.post('/field-reports//photo', data: form);
                  photoUrl = uploadRes.data['photo_url'];
                } catch (e) {
                  print('Failed to upload field report photo: ');
                }
              }
            }

            final payload = {
              'id': r.id,
              'rep_id': r.repId,
              'content': r.content,
              'photo_url': photoUrl,
            };
            final response = await _dio.post('/field-reports', data: payload);'''

replacement = '''            final payload = {
              'id': r.id,
              'rep_id': r.repId,
              'content': r.content,
              'photo_url': photoUrl,
            };
            final response = await _dio.post('/field-reports', data: payload);

            if (r.photoPath != null && r.photoPath!.isNotEmpty) {
              final file = File(r.photoPath!);
              if (await file.exists()) {
                final form = FormData.fromMap({
                  'file': await MultipartFile.fromFile(file.path),
                });
                try {
                  final uploadRes = await _dio.post('/field-reports//photo', data: form);
                  photoUrl = uploadRes.data['photo_url'];
                } catch (e) {
                  print('Failed to upload field report photo: ');
                }
              }
            }'''

text = text.replace(original, replacement)

with open('lib/core/services/sync_service.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
