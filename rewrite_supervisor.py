import os

content = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animated_nav_bar.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/widgets/glass_card.dart';

import 'coverage_map_tab.dart';
import 'team_tab.dart';
import 'review_tab.dart';
import 'performance_tab.dart';
import 'inventory_tab.dart';
import '../../shared/widgets/notification_panel.dart';
import '../../shared/widgets/notification_action_icon.dart';
import '../../admin/screens/centers_tab.dart';
import '../../rep/screens/appointments_tab.dart';
import '../../shared/screens/help_center_screen.dart';
import '../../shared/screens/about_screen.dart';

class SupervisorShell extends ConsumerStatefulWidget {
  const SupervisorShell({super.key});

  @override
  ConsumerState<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends ConsumerState<SupervisorShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  late AnimationController _navSlideController;
  late Animation<double> _fabScale;

  final List<Widget> _tabs = [
    CoverageMapTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];

  @override
  void initState() {
    super.initState();
    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    
    _fabScale = CurvedAnimation(
      parent: _navSlideController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _navSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final flaggedAsync = ref.watch(flaggedVisitsProvider);
    final flaggedCount = flaggedAsync.value?.length ?? 0;

    ref.listen(notificationsStreamProvider, (previous, next) {
      if (previous != null && next.hasValue && next.value != null) {
        final prevList = previous.value ?? [];
        final nextList = next.value!;
        if (nextList.length > prevList.length && nextList.isNotEmpty) {
          final newNotif = nextList.first;
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: Text('${newNotif.title}: ${newNotif.message ?? ""}'),
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
      extendBody: true,
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
                    (user?.fullName ?? 'S').isNotEmpty
                        ? (user?.fullName ?? 'S').substring(0, 1).toUpperCase()
                        : 'S',
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
                user?.fullName ?? 'Supervisor Panel',
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
          const NotificationActionIcon(),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Icon(Icons.person_outline_rounded, color: AppColors.onSurface, size: 20),
            ),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: const NotificationPanel(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
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
          currentIndex: _currentIndex > 2 ? 3 : _currentIndex, // If selected tab > 2, highlight 'More'
          onItemSelected: (i) {
            if (i == 3) {
              _showMoreSheet(context);
            } else {
              setState(() => _currentIndex = i);
            }
          },
          centerItem: ScaleTransition(
            scale: _fabScale,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
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
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => context.push('/rep/visit/new'),
                  child: Center(
                    child: Icon(
                      Icons.add_rounded,
                      size: 28,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          items: [
            NavBarItemData(icon: Icons.map_rounded, label: AppStrings.lbl_41),
            NavBarItemData(icon: Icons.groups_rounded, label: AppStrings.reps),
            NavBarItemData(icon: Icons.rate_review_rounded, badgeCount: flaggedCount, label: AppStrings.review),
            const NavBarItemData(icon: Icons.more_horiz_rounded, label: AppStrings.lbl_24),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MoreSheet(onSelect: (i) {
        setState(() => _currentIndex = i);
      }),
    );
  }
}

class _MoreSheet extends StatelessWidget {
  final Function(int) onSelect;
  const _MoreSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final items = [
      _MoreItem(Icons.insights_rounded, AppStrings.performance, AppColors.warning, () {
        nav.pop();
        onSelect(3);
      }),
      _MoreItem(Icons.inventory_2_rounded, AppStrings.inventory, AppColors.secondary, () {
        nav.pop();
        onSelect(4);
      }),
      _MoreItem(Icons.store_rounded, AppStrings.centers, AppColors.tertiary, () {
        nav.pop();
        onSelect(5);
      }),
      _MoreItem(Icons.calendar_month_rounded, AppStrings.appointments, AppColors.primary, () {
        nav.pop();
        onSelect(6);
      }),
      _MoreItem(Icons.help_outline_rounded, AppStrings.helpCenter, AppColors.primary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
      }),
      _MoreItem(Icons.info_outline_rounded, AppStrings.about, AppColors.tertiary, () {
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
                  Text(AppStrings.lbl_24, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
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
                          const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
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
"""

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Rewrote supervisor_shell.dart to perfectly match the Rep AnimatedNavBar UI")
