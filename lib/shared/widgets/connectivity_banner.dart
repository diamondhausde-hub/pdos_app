import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/theme/theme.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    final connectivity = Connectivity();
    connectivity.checkConnectivity().then((r) => _updateStatus(r));
    _subscription = connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _updateStatus(List<ConnectivityResult> results) async {
    bool offline = results.contains(ConnectivityResult.none);
    if (offline || results.isEmpty) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          offline = false;
        }
      } catch (_) {
        offline = true;
      }
    }
    if (!mounted) return;
    if (offline != _isOffline) {
      setState(() => _isOffline = offline);
      if (offline) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _slideAnim,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.warning.withValues(alpha: 0.9), AppColors.warning],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, color: AppColors.onPrimary, size: 16),
                const SizedBox(width: 8),
                Text('No internet connection',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onPrimary)),
              ],
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
