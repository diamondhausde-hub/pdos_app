import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import 'my_day_tab.dart';
import 'products_tab.dart';
import 'appointments_tab.dart';
import 'expenses_tab.dart';
import 'targets_tab.dart';
import 'rep_performance_tab.dart';
import 'field_reports_list_screen.dart';
import 'visit_history_screen.dart';
import '../../shared/widgets/notification_panel.dart';
import '../../shared/widgets/quick_actions_sheet.dart';
import '../../shared/screens/clients_screen.dart';
import '../../../core/widgets/animated_nav_bar.dart';
import '../../../core/services/live_tracking_service.dart';
import '../../../shared/widgets/live_tracking_button.dart';

import '../../shared/screens/sync_center_screen.dart';
import '../../shared/screens/help_center_screen.dart';
import '../../shared/screens/about_screen.dart';
import '../../../core/services/sync_status_service.dart';
import '../../supervisor/screens/coverage_map_tab.dart';


class RepShell extends ConsumerStatefulWidget {
  const RepShell({super.key});

  @override
  ConsumerState<RepShell> createState() => _RepShellState();
}

class _RepShellState extends ConsumerState<RepShell>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _fabController;
  late Animation<double> _fabScale;
  late AnimationController _navSlideController;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    _tabs = [
      MyDayTab(onNavigateToTargets: () {
        final ctx = context;
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => _ScreenWrapper(title: 'Targets', child: TargetsPage())));
      }),
      AppointmentsTab(),
      ClientsScreen(),
      CoverageMapTab(),
      ExpensesPage(),
      TargetsPage(),
      ProductsTab(),
      PerformancePage(),
      FieldReportsListScreen(),
    ];

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();
    _fabScale = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );

    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _navSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final newTasksAsync = ref.watch(repTasksProvider);
    final int newTaskCount = newTasksAsync.maybeWhen(
      data: (tasks) => tasks.where((t) => t.status == 'pending').length,
      orElse: () => 0,
    );

    ref.listen(notificationsStreamProvider, (previous, next) {
      if (!context.mounted) return;
      if (previous != null && next.hasValue && next.value != null) {
        final prevList = previous.value ?? [];
        final nextList = next.value!;
        if (nextList.length > prevList.length && nextList.isNotEmpty) {
          final newNotif = nextList.first;
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: Text('${newNotif.title}: ${newNotif.message ?? ''}'),
              action: SnackBarAction(
                label: 'View',
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              ),
            ),
          );
        }
      }
    });

    ref.watch(notificationsStreamProvider);

    return Scaffold(
      key: _scaffoldKey,
      extendBody: false,
      appBar: AppBar(
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
                    (user?.fullName ?? 'U').isNotEmpty
                        ? (user?.fullName ?? 'U').substring(0, 1).toUpperCase()
                        : 'U',
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _getFirstName(user?.fullName),
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

          Consumer(
            builder: (context, ref, child) {
              final pendingCountAsync = ref.watch(pendingSyncCountProvider);
              final count = pendingCountAsync.asData?.value ?? 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncCenterScreen()));
                    },
                    tooltip: 'مركز المزامنة',
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          Consumer(
            builder: (context, ref, child) {
              final isTracking = ref.watch(isLiveTrackingProvider);
              return LiveTrackingButton(
                isTracking: isTracking,
                onToggle: (bool val) async {
                  if (val) {
                    final success = await ref
                        .read(liveTrackingServiceProvider)
                        .startTracking();
                    if (success) {
                      ref
                          .read(isLiveTrackingProvider.notifier)
                          .setTracking(true);
                      if (context.mounted) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                            content: Text('Live tracking enabled'),
                          ),
                        );
                      }
                    } else {
                      // If failed to start, toggle back to false visually by ref.invalidate or just do nothing,
                      // but LiveTrackingButton assumes optimistic update unless we force it.
                      // Actually, the button will wait and stay active if we don't revert it.
                      ref
                          .read(isLiveTrackingProvider.notifier)
                          .setTracking(false);
                      if (context.mounted) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                            content: Text('Failed to start tracking'),
                          ),
                        );
                      }
                    }
                  } else {
                    ref.read(liveTrackingServiceProvider).stopTracking();
                    ref
                        .read(isLiveTrackingProvider.notifier)
                        .setTracking(false);
                  }
                },
              );
            },
          ),
          const SizedBox(width: 4),
          Consumer(
            builder: (context, ref, child) {
              final notifAsync = ref.watch(notificationsStreamProvider);
              final count =
                  notifAsync.asData?.value.where((n) => !n.isRead).length ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.onSurface,
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.onSurface,
            onPressed: () => _showMoreSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: AppColors.onSurface,
            onPressed: () => context.push('/profile'),
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
      endDrawer: const NotificationPanel(),

      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _navSlideController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: AnimatedNavBar(
          currentIndex: _currentIndex,
          onItemSelected: (i) {
            setState(() => _currentIndex = i);
          },
          centerItem: ScaleTransition(
            scale: _fabScale,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => showQuickActionsSheet(context, ref),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          items: [
            NavBarItemData(icon: Icons.dashboard_rounded, label: 'يومي', badgeCount: newTaskCount),
            const NavBarItemData(icon: Icons.calendar_month_rounded, label: 'مواعيد'),
            const NavBarItemData(icon: Icons.people_rounded, label: 'عملاء'),
            const NavBarItemData(icon: Icons.map_outlined, label: 'الخريطة'),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _MoreSheet(),
    );
  }
}

String _getFirstName(String? fullName) {
  if (fullName == null) return 'PDOS';
  return fullName.split(' ').first;
}

class _MoreSheet extends StatelessWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final items = [
      _MoreItem(Icons.assignment_rounded, 'المهام (Tasks)', AppColors.primary, () {
        nav.pop();
        context.push('/rep/tasks');
      }),
      _MoreItem(Icons.history_rounded, 'Visit History', AppColors.primary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const _ScreenWrapper(title: 'Visit History', child: VisitHistoryScreen())));
      }),
      _MoreItem(Icons.wallet_rounded, 'Expenses', AppColors.success, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => _ScreenWrapper(title: 'Expenses', child: const ExpensesPage())));
      }),
      _MoreItem(Icons.track_changes_rounded, 'Targets', AppColors.info, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => _ScreenWrapper(title: 'Targets', child: TargetsPage())));
      }),
      _MoreItem(Icons.medication_rounded, 'Products', AppColors.secondary, () {
        nav.pop();
        context.push('/rep/products');
      }),
      _MoreItem(Icons.insights_rounded, 'Performance', AppColors.tertiary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => _ScreenWrapper(title: 'Performance', child: const PerformancePage())));
      }),
      _MoreItem(Icons.description_rounded, 'Field Reports', AppColors.warning, () {
        nav.pop();
        context.push('/rep/field-reports');
      }),
      _MoreItem(Icons.help_outline_rounded, 'Help Center', AppColors.primary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
      }),
      _MoreItem(Icons.info_outline_rounded, 'About', AppColors.tertiary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const AboutScreen()));
      }),
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
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text('More', style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: item.onTap,
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

class _ScreenWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _ScreenWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
