import '../models/note_model.dart';
import '../services/api_service.dart';

class RepNoteRepository {
  final ApiService _apiService;

  RepNoteRepository(this._apiService);

  Future<void> sendNote(String userId, String content) async {
    await _apiService.dio.post(
      '/users/$userId/notes',
      data: {'content': content},
    );
  }

  Future<void> sendVisitNote(String userId, String content, String visitId) async {
    await _apiService.dio.post(
      '/users/$userId/notes',
      data: {'content': content, 'visit_id': visitId},
    );
  }

  Future<List<NoteModel>> getNotes({
    String? userId,
    String? visitId,
    String? visitCenterId,
    int limit = 50,
  }) async {
    try {
      final response = await _apiService.dio.get('/notes', queryParameters: {
        'user_id': ?userId,
        'visit_id': ?visitId,
        'visit_center_id': ?visitCenterId,
        'limit': limit,
      });
      return (response.data as List)
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
