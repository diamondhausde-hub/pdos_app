import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<Map<String, dynamic>> updateOwnProfile({
    String? fullName,
    String? phone,
    String? region,
    String? photoUrl,
    String? currentPassword,
    String? newPassword,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (region != null) body['region'] = region;
    if (photoUrl != null) body['profile_image_url'] = photoUrl;
    if (newPassword != null) {
      body['current_password'] = currentPassword;
      body['new_password'] = newPassword;
    }
    final response = await _apiService.dio.patch('/users/me/profile', data: body);
    return response.data as Map<String, dynamic>;
  }
}
