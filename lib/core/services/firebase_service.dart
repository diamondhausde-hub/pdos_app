import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_service.dart';

class FcmPushService {
  FcmPushService._();
  static final instance = FcmPushService._();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await Firebase.initializeApp();
      
      final messaging = FirebaseMessaging.instance;
      
      // Request permissions
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Listen to token refreshes to keep backend updated
        messaging.onTokenRefresh.listen((newToken) {
          _registerTokenOnBackend(newToken);
        });
      }

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization failed (missing config?): $e');
      }
    }
  }

  /// Called after login
  Future<void> registerCurrentDevice() async {
    if (!_isInitialized) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _registerTokenOnBackend(token);
      }
    } catch (e) {
      if (kDebugMode) print('Failed to get FCM token: $e');
    }
  }

  /// Called before logout
  Future<void> unregisterCurrentDevice() async {
    if (!_isInitialized) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await ApiService.instance.dio.delete(
          '/users/me/fcm-tokens',
          queryParameters: {'token': token},
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) {
        debugPrint('Error unregistering device: $e');
      }
    } catch (e) {
      debugPrint('Error unregistering device: $e');
    }
  }

  Future<void> _registerTokenOnBackend(String token) async {
    try {
      await ApiService.instance.dio.post(
        '/users/me/fcm-tokens',
        data: {'token': token},
      );
    } catch (e) {
      if (kDebugMode) print('Failed to post FCM token to backend: $e');
    }
  }
}
