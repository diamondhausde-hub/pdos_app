import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/animated_nav_bar.dart';
import '../../shared/widgets/notification_action_icon.dart';
import 'dashboard_tab.dart';
import 'user_management_tab.dart';
import 'centers_tab.dart';
import 'products_tab.dart';
import 'expenses_tab.dart';
import 'brand_management_tab.dart';
import 'reports_tab.dart';
import 'settings_tab.dart';
import 'admin_audit_logs_tab.dart';
import '../../shared/screens/help_center_screen.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _navSlideController;

  final List<Widget> _tabs = [
    AdminDashboardTab(),
    UserManagementTab(),
    AdminCentersTab(),
    AdminProductsTab(),
    AdminExpensesTab(),
    BrandManagementTab(),
    AdminReportsTab(),
    AdminSettingsTab(),
    AdminAuditLogsTab(),
  ];

  @override
  void initState() {
    super.initState();
    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _navSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBg(isDark),
      extendBody: false,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(isDark),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user?.fullProfileImageUrl != null)
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(user!.fullProfileImageUrl!),
              )
            else
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user?.fullName ?? 'A').isNotEmpty
                        ? (user?.fullName ?? 'A').substring(0, 1).toUpperCase()
                        : 'A',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                user?.fullName ?? 'Admin Console',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.adminColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 14,
                  color: AppColors.adminColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Admin',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.adminColor,
                  ),
                ),
              ],
            ),
          ),
          const NotificationActionIcon(),
          IconButton(
            icon: Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen())),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _navSlideController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: AnimatedNavBar(
          currentIndex: _currentIndex > 3 ? 4 : _currentIndex,
          onItemSelected: (i) {
            if (i == 4) {
              _showMoreSheet(context);
            } else {
              setState(() => _currentIndex = i);
            }
          },
          items: const [
            NavBarItemData(icon: Icons.dashboard_rounded, label: AppStrings.lbl_1),
            NavBarItemData(icon: Icons.people_rounded, label: AppStrings.lbl_2),
            NavBarItemData(icon: Icons.store_rounded, label: AppStrings.lbl_3),
            NavBarItemData(icon: Icons.inventory_2_rounded, label: AppStrings.lbl_4),
            NavBarItemData(icon: Icons.more_horiz_rounded, label: 'More'),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdminMoreSheet(onSelect: (i) {
        setState(() => _currentIndex = i);
        Navigator.pop(ctx);
      }),
    );
  }
}

class _AdminMoreSheet extends StatelessWidget {
  final Function(int) onSelect;
  const _AdminMoreSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem(Icons.receipt_long_rounded, AppStrings.lbl_5, AppColors.tertiary, () => onSelect(4)),
      _MoreItem(Icons.storefront_rounded, AppStrings.lbl_6, AppColors.secondary, () => onSelect(5)),
      _MoreItem(Icons.assessment_rounded, AppStrings.lbl_7, AppColors.info, () => onSelect(6)),
      _MoreItem(Icons.settings_rounded, AppStrings.lbl_8, AppColors.onSurfaceVariant, () => onSelect(7)),
      _MoreItem(Icons.security_rounded, 'Audit Logs', AppColors.primary, () => onSelect(8)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text('More', style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: item.onTap,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                            child: Icon(item.icon, color: item.color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Text(item.label, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MoreItem(this.icon, this.label, this.color, this.onTap);
}
