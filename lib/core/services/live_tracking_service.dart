import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';
import '../providers/data_providers.dart';

final liveTrackingServiceProvider = Provider<LiveTrackingService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LiveTrackingService(apiService);
});

class LiveTrackingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setTracking(bool val) => state = val;
}

final isLiveTrackingProvider = NotifierProvider<LiveTrackingNotifier, bool>(LiveTrackingNotifier.new);

class LiveTrackingService {
  final ApiService _apiService;
  StreamSubscription<Position>? _positionStream;
  Timer? _heartbeatTimer;
  DateTime? _lastUpdate;

  LiveTrackingService(this._apiService);

  Future<bool> startTracking() async {
    if (_positionStream != null) return true;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    try {
      final currentPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _sendLocationToServer(currentPos);
    } catch (_) {}

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(_sendLocationToServer);

    _heartbeatTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        _sendLocationToServer(pos);
      } catch (_) {}
    });

    return true;
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _sendLocationToServer(Position position) async {
    if (_lastUpdate != null && DateTime.now().difference(_lastUpdate!).inSeconds < 60) {
      return;
    }

    try {
      await _apiService.dio.put('/users/me/location', data: {
        'lat': position.latitude,
        'lng': position.longitude,
      });
      _lastUpdate = DateTime.now();
    } catch (e) {
      debugPrint('Failed to sync live location: $e');
    }
  }
}
