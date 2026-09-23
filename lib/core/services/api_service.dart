// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static ApiService get instance => _instance;
  
  static void Function()? onUnauthenticated;

  /// Latch: once a 401 has triggered session teardown, ignore further 401s
  /// (polling retries, the FCM-unregister during logout, etc.) until the
  /// next successful login resets it. Prevents the 401 → logout → 401 loop.
  bool _sessionTeardownDone = false;
  
  late final Dio dio;
  final storage = const FlutterSecureStorage();

  ApiService._internal() {
    final envUrl = dotenv.env['API_BASE_URL'];
    const dartDefineUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    final baseUrl = dartDefineUrl.isNotEmpty 
        ? dartDefineUrl 
        : (envUrl ?? 'http://127.0.0.1:8000');
    
    print('ApiService: Initializing with Base URL: $baseUrl');
    
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Interceptor to inject JWT token and handle errors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && !_sessionTeardownDone) {
          _sessionTeardownDone = true;
          // Token expired or invalid - Clear token and cached user!
          print('ApiService: 401 Detected. Clearing token and cached user.');
          try {
            await storage.delete(key: 'jwt_token');
            await storage.delete(key: 'cached_user_json');
          } catch (_) {}
          onUnauthenticated?.call();
        }
        return handler.next(e);
      },
    ));
  }

  // --- Auth Methods ---
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: FormData.fromMap({
        'username': email,
        'password': password,
      }),
    );
    final data = response.data;
    await storage.write(key: 'jwt_token', value: data['access_token']);
    _sessionTeardownDone = false; // fresh session — re-arm the 401 latch
    return data;
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  Future<bool> hasValidToken() async {
    return await storage.read(key: 'jwt_token') != null;
  }
}
