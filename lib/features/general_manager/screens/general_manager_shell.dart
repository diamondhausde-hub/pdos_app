import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animated_nav_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

import '../../shared/screens/help_center_screen.dart';
import '../../shared/screens/about_screen.dart';
import '../../overseer/screens/analytics_tab.dart';
import '../../supervisor/screens/coverage_map_tab.dart';
import '../../general_manager/screens/team_directory_tab.dart';
import '../../rep/screens/appointments_tab.dart';
import '../widgets/brand_switcher_widget.dart';
import 'all_expenses_tab.dart';
import 'general_manager_logs_tab.dart';
import 'gm_dashboard_tab.dart';
import '../../shared/widgets/quick_actions_sheet.dart';

class GeneralManagerShell extends ConsumerStatefulWidget {
  const GeneralManagerShell({super.key});

  @override
  ConsumerState<GeneralManagerShell> createState() => _GeneralManagerShellState();
}

class _GeneralManagerShellState extends ConsumerState<GeneralManagerShell>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _navSlideController;
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = const [
      GmDashboardTab(),
      CoverageMapTab(isEmbedded: true),
      GeneralManagerAnalyticsTab(),
      TeamDirectoryTab(),
      AppointmentsTab(),
      AllExpensesTab(),
      GeneralManagerLogsTab(),
    ];
    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();

    _fabScale = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );
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
                label: AppStrings.view,
                onPressed: () => GoRouter.of(context).push('/notifications'),
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
                    (user?.fullName ?? 'G').isNotEmpty
                        ? (user?.fullName ?? 'G').substring(0, 1).toUpperCase()
                        : 'G',
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
          // Brand switcher — GM only
          const BrandSwitcherWidget(),
          const SizedBox(width: 4),
          // GM Read-Only badge
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Read Only',
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          // Notifications
          Consumer(
            builder: (context, ref, _) {
              final notifAsync = ref.watch(notificationsStreamProvider);
              final count =
                  notifAsync.asData?.value.where((n) => !n.isRead).length ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.onSurface,
                    onPressed: () => GoRouter.of(context).push('/notifications'),
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
          // Profile
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
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
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
          currentIndex: _currentIndex > 2 ? 3 : _currentIndex,
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
                  onTap: () => showQuickActionsSheet(context, ref, isGm: true),
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
          items: const [
            NavBarItemData(icon: Icons.dashboard_rounded, label: 'Overview'),
            NavBarItemData(icon: Icons.map_rounded, label: 'Map'),
            NavBarItemData(icon: Icons.insights_rounded, label: 'Analytics'),
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
      builder: (ctx) => _MoreSheet(onSelect: (i) {
        setState(() => _currentIndex = i);
      }),
    );
  }
}

String _getFirstName(String? fullName) {
  if (fullName == null) return 'PDOS';
  return fullName.split(' ').first;
}

// ── More bottom sheet ────────────────────────────────────────────────────────

class _MoreSheet extends StatelessWidget {
  final Function(int) onSelect;
  const _MoreSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    final items = [
      _MoreItem(Icons.people_rounded, 'Team Directory', AppColors.primary, () {
        nav.pop();
        onSelect(3);
      }),
      _MoreItem(Icons.calendar_month_rounded, AppStrings.appointments, AppColors.secondary, () {
        nav.pop();
        onSelect(4);
      }),
      _MoreItem(Icons.receipt_long_rounded, 'Expenses', AppColors.warning, () {
        nav.pop();
        onSelect(5);
      }),
      _MoreItem(Icons.history_rounded, 'Activity Logs', AppColors.tertiary, () {
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
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(AppStrings.lbl_24,
                      style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
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
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(item.icon, color: item.color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Text(item.label,
                              style: AppTextStyles.bodyLg.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface)),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.onSurfaceVariant, size: 20),
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
