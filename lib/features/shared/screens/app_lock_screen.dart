import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/biometric_lock_service.dart';

class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const AppLockScreen({super.key, required this.onUnlocked});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _service = BiometricLockService();
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() => _authenticating = true);
    final ok = await _service.authenticate();
    if (ok && mounted) widget.onUnlocked();
    if (mounted) setState(() => _authenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.fingerprint, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'App Locked',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Authenticate to access the app',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: FilledButton.icon(
                onPressed: _authenticating ? null : _authenticate,
                icon: _authenticating
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                    : Icon(Icons.fingerprint),
                label: Text(_authenticating ? 'Authenticating...' : 'Unlock'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
