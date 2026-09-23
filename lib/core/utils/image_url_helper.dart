import '../services/api_service.dart';

String fullImageUrl(String? relativePath) {
  if (relativePath == null || relativePath.isEmpty || relativePath == 'default') return '';
  if (relativePath.startsWith('http')) return relativePath;
  final prefix = relativePath.startsWith('/') ? '' : '/';
  return '${ApiService.instance.dio.options.baseUrl}$prefix$relativePath';
}
