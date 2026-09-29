// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/product_sync_service.dart';
import 'data_providers.dart';
import 'package:app_links/app_links.dart';
import '../services/live_tracking_service.dart';
import '../services/firebase_service.dart';
import 'brand_provider.dart';

enum AuthStateStatus { initial, unauthenticated, authenticated }

class AuthState {
  final AuthStateStatus status;
  final UserModel? user;
  const AuthState({this.status = AuthStateStatus.initial, this.user});
}

class AuthNotifier extends Notifier<AuthState> {
  ApiService get _apiService => ApiService.instance;

  static const _cachedUserKey = 'cached_user_json';

  @override
  AuthState build() {
    ApiService.onUnauthenticated = () {
      logout();
    };
    _init();
    return const AuthState();
  }

  /// Cache user JSON to secure storage
  Future<void> _cacheUser(UserModel user) async {
    try {
      final json = jsonEncode(user.toJson());
      await _apiService.storage.write(key: _cachedUserKey, value: json);
    } catch (e) {
      print('AuthNotifier: Failed to cache user ($e)');
    }
  }

  /// Load cached user from secure storage
  Future<UserModel?> _loadCachedUser() async {
    try {
      final raw = await _apiService.storage.read(key: _cachedUserKey);
      if (raw == null) return null;
      return UserModel.fromJson(jsonDecode(raw));
    } catch (e) {
      print('AuthNotifier: Failed to load cached user ($e)');
      return null;
    }
  }

  /// Clear cached user from secure storage
  Future<void> _clearCachedUser() async {
    await _apiService.storage.delete(key: _cachedUserKey);
  }

  Future<void> _init() async {
    final hasToken = await _apiService.hasValidToken();
    if (!hasToken) {
      // No token at all → definitely not logged in
      state = const AuthState(status: AuthStateStatus.unauthenticated);
      return;
    }

    // We have a token — try to refresh user from server
    try {
      final response = await _apiService.dio.get('/users/me');
      final user = UserModel.fromJson(response.data);
      
      // Cache the fresh user data for offline use
      await _cacheUser(user);
      
      state = AuthState(status: AuthStateStatus.authenticated, user: user);
      
      // Fire and forget product pull
      ref.read(productSyncServiceProvider).pullProducts();
      
      // Register FCM for push notifications
    FcmPushService.instance.registerCurrentDevice();
    } catch (e) {
      print('AuthNotifier: Server unreachable ($e). Trying cached user...');
      
      // Check if it was a 401 (token actually invalid/expired)
      final is401 = e is DioException && e.response?.statusCode == 401;
      
      if (!is401) {
        // Network error / server down — try to restore from cache
        final cachedUser = await _loadCachedUser();
        if (cachedUser != null) {
          print('AuthNotifier: Restored session from cache (offline mode).');
          state = AuthState(status: AuthStateStatus.authenticated, user: cachedUser);
          
          // Fire and forget product pull (will fail silently if offline)
          ref.read(productSyncServiceProvider).pullProducts();
          return;
        }
      }
      
      // 401 or no cached user → force re-login
      print('AuthNotifier: No cached user available. Redirecting to login.');
      state = const AuthState(status: AuthStateStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    final data = await _apiService.login(email, password);
    final user = UserModel.fromJson(data['user']);
    
    // Cache user for offline persistence
    await _cacheUser(user);
    
    state = AuthState(status: AuthStateStatus.authenticated, user: user);

    // Fire and forget product pull
    ref.read(productSyncServiceProvider).pullProducts();

    // Register FCM for push notifications
    FcmPushService.instance.registerCurrentDevice();
  }

  bool _isLoggingOut = false;

  Future<void> updateProfile({String? fullName, String? phone, String? region, String? profileImageUrl}) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (region != null) body['region'] = region;
      if (profileImageUrl != null) body['profile_image_url'] = profileImageUrl;
      if (body.isEmpty) return;
      await _apiService.dio.patch('/users/me/profile', data: body);
      final updated = currentUser.copyWith(
        fullName: fullName,
        phone: phone,
        region: region,
        profileImageUrl: profileImageUrl,
      );
      await _cacheUser(updated);
      state = AuthState(status: AuthStateStatus.authenticated, user: updated);
    } catch (e) {
      print('AuthNotifier: Failed to update profile ($e)');
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    // 1. End the session locally FIRST — never depend on the network to
    //    log out (a dead token would make any server call 401 and loop).
    try {
      ref.read(liveTrackingServiceProvider).stopTracking();
    } catch (_) {}
    try {
      await ref.read(notificationServiceProvider).cancelAllReminders();
    } catch (_) {}
    await _clearCachedUser();
    await _apiService.logout();

    ref.read(selectedBrandIdProvider.notifier).state = null;

    state = const AuthState(status: AuthStateStatus.unauthenticated);

    // 2. Server-side FCM cleanup is strictly best-effort: with a stale or
    //    cleared token this call will simply fail — ignore it silently.
    try {
      await FcmPushService.instance.unregisterCurrentDevice();
    } catch (_) {}

    _isLoggingOut = false;
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

final isInviteLinkProvider = NotifierProvider<InviteLinkNotifier, bool>(InviteLinkNotifier.new);

class InviteLinkNotifier extends Notifier<bool> {
  @override
  bool build() {
    final appLinks = AppLinks();
    
    final subscription = appLinks.uriLinkStream.listen((uri) {
      if (uri.fragment.contains('type=invite')) {
        state = true;
      }
    });
    
    ref.onDispose(subscription.cancel);
    return false;
  }
}
