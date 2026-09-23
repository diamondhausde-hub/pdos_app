// ignore_for_file: avoid_print
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../models/appointment_model.dart';

typedef NotificationTapCallback = void Function(String appointmentId);

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static NotificationTapCallback? onAppointmentTap;

  // Stores pending appointment ID tapped while app wasn't ready
  static String? pendingAppointmentId;

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo));
    } catch (e) {
      print('NotificationService: Could not set local location: $e. Falling back to UTC.');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          if (onAppointmentTap != null) {
            onAppointmentTap!(payload);
          } else {
            pendingAppointmentId = payload;
          }
        }
      },
    );

    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
  }

  int _deterministicId(String appointmentId) => appointmentId.hashCode & 0x7FFFFFFF;

  Future<void> scheduleAppointmentReminder(AppointmentModel appt) async {
    if (appt.reminderMinutesBefore <= 0) return;

    final apptDateTime = _parseAppointmentDateTime(appt.apptDate, appt.apptTime);
    final triggerTime = apptDateTime.subtract(Duration(minutes: appt.reminderMinutesBefore));

    if (triggerTime.isBefore(DateTime.now())) return;

    final clientName = appt.centerName ?? 'your appointment';

    final androidDetails = const AndroidNotificationDetails(
      'appointment_reminders_channel',
      'Appointment Reminders',
      channelDescription: 'Reminders for your scheduled pharmacy visits',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id: _deterministicId(appt.id),
      title: 'Visit Appointment',
      body: '$clientName - ${appt.apptTime}',
      scheduledDate: tz.TZDateTime.from(triggerTime, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: appt.id,
    );
  }

  Future<void> cancelAppointmentReminder(String appointmentId) async {
    await _plugin.cancel(id: _deterministicId(appointmentId));
  }

  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  DateTime _parseAppointmentDateTime(DateTime date, String timeString) {
    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

final notificationService = NotificationService();
