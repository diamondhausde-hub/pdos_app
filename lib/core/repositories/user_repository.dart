import '../models/user_model.dart';
import '../models/team_directory_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _api = ApiService.instance;

  Future<List<TeamDirectoryNode>> getTeamDirectory({String? brandId}) async {
    try {
      final response = await _api.dio.get('/users/team-directory', queryParameters: {
        if (brandId != null && brandId.isNotEmpty) 'brand_id': brandId,
      });
      final data = response.data as List;
      return data.map((e) => TeamDirectoryNode.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _api.dio.get('/users');
      final data = response.data as List;
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser({
    required String email,
    required String fullName,
    required UserRole role,
    required String temporaryPassword,
    String? phone,
    String? region,
    String? supervisorId,
    String? brandId,
  }) async {
    try {
      await _api.dio.post('/users', data: {
        'email': email,
        'full_name': fullName,
        'role': role.name,
        'temporary_password': temporaryPassword,
        'phone': phone,
        'region': region,
        'supervisor_id': supervisorId,
        'brand_id': brandId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _api.dio.put('/users/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _api.dio.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
