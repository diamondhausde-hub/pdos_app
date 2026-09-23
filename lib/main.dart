import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/biometric_lock_service.dart';
import 'core/local_db/app_database.dart';
import 'core/repositories/appointment_repository.dart';
import 'core/providers/theme_provider.dart';
import 'core/widgets/theme_transition_overlay.dart';
import 'features/shared/screens/app_lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FcmPushService.instance.initialize();
  } catch (e, stack) {
    debugPrint('Error initializing Firebase: $e\n$stack');
  }

  try {
    await notificationService.init();
  } catch (e, stack) {
    debugPrint('Error initializing notifications: $e\n$stack');
  }

  try {
    final db = AppDatabase();
    final repo = AppointmentRepository(db);
    await repo.scheduleAllPendingReminders();
    await db.close();
  } catch (e, stack) {
    debugPrint('Error scheduling reminders: $e\n$stack');
  }

  runApp(
    const ProviderScope(
      child: PdosApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background isolate: save notification to local DB so it appears
  // in the notification center when the user opens the app.
  try {
    final db = AppDatabase();
    final notif = message.notification;
    final data = message.data;
    await db.upsertNotification(LocalNotificationsCompanion(
      id: Value(message.messageId ?? const Uuid().v4()),
      userId: Value(data['user_id'] ?? ''),
      type: Value(data['type'] ?? 'push'),
      title: Value(notif?.title ?? ''),
      message: Value(notif?.body),
      relatedId: Value(data['related_id']?.isNotEmpty == true ? data['related_id'] : null),
      isRead: const Value(false),
      synced: const Value(true),
      createdAt: Value(DateTime.now()),
    ));
    await db.close();
  } catch (_) {
    // Background isolate — cannot report errors via UI; fail silently.
  }
}

class PdosApp extends ConsumerStatefulWidget {
  const PdosApp({super.key});

  @override
  ConsumerState<PdosApp> createState() => _PdosAppState();
}

class _PdosAppState extends ConsumerState<PdosApp> with WidgetsBindingObserver {
  final _lockService = BiometricLockService();
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Wire notification tap routing once — not on every build.
    NotificationService.onAppointmentTap = _openVisit;
  }

  void _openVisit(String appointmentId) {
    ref.read(routerProvider).push('/rep/active_visit/$appointmentId');
  }

  void _drainPendingNotification() {
    final pending = NotificationService.pendingAppointmentId;
    if (pending == null) return;
    // Clear synchronously so we never schedule twice, then navigate
    // AFTER the current frame (navigation during build throws).
    NotificationService.pendingAppointmentId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _openVisit(pending));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final enabled = await _lockService.isEnabled();
      if (enabled && !_isLocked) {
        setState(() => _isLocked = true);
      }
    }
  }

  void _onUnlocked() {
    setState(() => _isLocked = false);
  }

  @override
  Widget build(BuildContext context) {
    _drainPendingNotification();
    final router = ref.watch(routerProvider);

    final themeMode = ref.watch(themeModeProvider);
    final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final effectiveBrightness = themeMode == ThemeMode.dark
        ? Brightness.dark
        : (themeMode == ThemeMode.light ? Brightness.light : platformBrightness);
    
    AppColors.updateBrightness(effectiveBrightness);

    return MaterialApp.router(
      key: ValueKey(themeMode),
      title: 'PDOS',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],

      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ThemeTransitionOverlay(
          child: Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (_isLocked)
                AppLockScreen(onUnlocked: _onUnlocked),
            ],
          ),
        );
      },
    );
  }
}
