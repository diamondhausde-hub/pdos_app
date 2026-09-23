import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _appointmentReminders = true;
  bool _lowStockAlerts = true;
  bool _visitUpdates = true;
  bool _expiryAlerts = true;
  bool _targetUpdates = true;
  bool _productUpdates = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointmentReminders = prefs.getBool('notify_appointment') ?? true;
      _lowStockAlerts = prefs.getBool('notify_low_stock') ?? true;
      _visitUpdates = prefs.getBool('notify_visit') ?? true;
      _expiryAlerts = prefs.getBool('notify_expiry') ?? true;
      _targetUpdates = prefs.getBool('notify_target') ?? true;
      _productUpdates = prefs.getBool('notify_product') ?? true;
    });
  }

  Future<void> _toggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.notificationSettings),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingTile(
            icon: Icons.event_rounded,
            title: AppStrings.appointmentReminders,
            subtitle: AppStrings.getNotifiedAboutUpcoming,
            color: AppColors.primary,
            value: _appointmentReminders,
            onChanged: (v) { _appointmentReminders = v; _toggle('notify_appointment', v); },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.inventory_2_rounded,
            title: AppStrings.lowStockAlerts,
            subtitle: AppStrings.alertsWhenProductsRun,
            color: AppColors.warning,
            value: _lowStockAlerts,
            onChanged: (v) { _lowStockAlerts = v; _toggle('notify_low_stock', v); },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.flag_rounded,
            title: AppStrings.visitUpdates,
            subtitle: AppStrings.notificationsAboutFlaggedOr,
            color: AppColors.error,
            value: _visitUpdates,
            onChanged: (v) { _visitUpdates = v; _toggle('notify_visit', v); },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.access_time_filled_rounded,
            title: AppStrings.expiryAlerts,
            subtitle: AppStrings.getNotifiedAboutExpiring,
            color: AppColors.tertiary,
            value: _expiryAlerts,
            onChanged: (v) { _expiryAlerts = v; _toggle('notify_expiry', v); },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.assignment_turned_in_rounded,
            title: AppStrings.targetUpdates,
            subtitle: AppStrings.updatesOnYourSales,
            color: AppColors.success,
            value: _targetUpdates,
            onChanged: (v) { _targetUpdates = v; _toggle('notify_target', v); },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.inventory_rounded,
            title: AppStrings.productUpdates,
            subtitle: AppStrings.newProductsAddedOr,
            color: AppColors.secondary,
            value: _productUpdates,
            onChanged: (v) { _productUpdates = v; _toggle('notify_product', v); },
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: color,
          ),
        ],
      ),
    );
  }
}
