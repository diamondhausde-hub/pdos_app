with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write('''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/animated_nav_bar.dart';
import '../../../core/localization/app_strings.dart';

import 'supervisor_home_tab.dart';
import 'team_tab.dart';
import 'review_tab.dart';
import 'performance_tab.dart';
import 'inventory_tab.dart';
import '../../shared/widgets/notification_panel.dart';
import '../../shared/widgets/notification_action_icon.dart';
import '../../admin/screens/centers_tab.dart';
import '../../rep/screens/appointments_tab.dart';

class SupervisorShell extends ConsumerStatefulWidget {
  final Widget child;
  const SupervisorShell({super.key, required this.child});

  @override
  ConsumerState<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends ConsumerState<SupervisorShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  late AnimationController _navSlideController;
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  List<Widget> get _tabs => [
    const SupervisorHomeTab(),
    const TeamTab(),
    const ReviewTab(),
    const PerformanceTab(),
    const InventoryTab(),
    const AdminCentersTab(),
    const AppointmentsTab(),
  ];

  @override
  void initState() {
    super.initState();
    
    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _navSlideController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _openMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text('المزيد', style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _MoreMenuItem(
                      icon: Icons.inventory_2_rounded,
                      title: 'المخزون',
                      onTap: () {
                        context.pop();
                        setState(() => _currentIndex = 4);
                      },
                    ),
                    _MoreMenuItem(
                      icon: Icons.store_rounded,
                      title: 'المراكز والصيدليات',
                      onTap: () {
                        context.pop();
                        setState(() => _currentIndex = 5);
                      },
                    ),
                    _MoreMenuItem(
                      icon: Icons.calendar_today_rounded,
                      title: 'المواعيد',
                      onTap: () {
                        context.pop();
                        setState(() => _currentIndex = 6);
                      },
                    ),
                    const Divider(height: 32),
                    _MoreMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () {
                        context.pop();
                        context.push('/shared/settings');
                      },
                    ),
                    _MoreMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'مركز المساعدة',
                      onTap: () {
                        context.pop();
                        context.push('/shared/help');
                      },
                    ),
                    _MoreMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'عن التطبيق',
                      onTap: () {
                        context.pop();
                        context.push('/shared/about');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: const Drawer(
        child: NotificationPanel(),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'لوحة تحكم المشرف',
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          const NotificationActionIcon(),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: _navSlideController, curve: Curves.easeOutCubic)),
        child: AnimatedNavBar(
          currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
          onItemSelected: (index) {
            if (index == 4) {
              _openMoreSheet();
            } else {
              _onTabSelected(index);
            }
          },
          items: const [
            NavBarItemData(icon: Icons.dashboard_rounded, label: 'الرئيسية'),
            NavBarItemData(icon: Icons.groups_rounded, label: AppStrings.lbl_26),
            NavBarItemData(icon: Icons.fact_check_rounded, label: AppStrings.lbl_27),
            NavBarItemData(icon: Icons.bar_chart_rounded, label: AppStrings.lbl_28),
          ],
          centerItem: ScaleTransition(
            scale: _fabScale,
            child: FloatingActionButton(
              onPressed: () {
                context.push('/shared/add-client');
              },
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MoreMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
      onTap: onTap,
    );
  }
}''')
