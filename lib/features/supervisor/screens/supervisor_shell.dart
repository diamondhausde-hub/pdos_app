import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../../core/theme/theme.dart';
import '../../../core/providers/brand_provider.dart';

import '../../../core/widgets/animated_nav_bar.dart';
import '../../../core/localization/app_strings.dart';
import '../../shared/widgets/quick_actions_sheet.dart';

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
  
  const SupervisorShell({super.key});

  @override
  ConsumerState<SupervisorShell> createState() => SupervisorShellState();
}

class SupervisorShellState extends ConsumerState<SupervisorShell> with TickerProviderStateMixin {
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

  /// Public method for child widgets to switch tabs programmatically
  void switchToTab(int index) {
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
      
      endDrawer: const Drawer(
        child: NotificationPanel(),
      ),
      appBar: AppBar(
        title: Consumer(
        builder: (context, ref, child) {
          final selectedBrandId = ref.watch(selectedBrandIdProvider);
          final brandsAsync = ref.watch(brandsProvider);

          return brandsAsync.when(
            loading: () => const SizedBox(
              width: 100,
              height: 20,
              child: LinearProgressIndicator(),
            ),
            error: (e, s) => const Text('Error'),
            data: (brands) {
              final selectedBrand = brands.firstWhere(
                (b) => b.id == selectedBrandId, 
                orElse: () => brands.isNotEmpty ? brands.first : throw Exception()
              );
              final isAll = selectedBrandId == null;
              final displayName = isAll ? 'جميع البراندات' : selectedBrand.name;

              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.outline.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Text(
                              'اختر البراند',
                              style: AppTextStyles.headlineSm.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isAll ? AppColors.primary : AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isAll ? AppColors.primary : AppColors.outline.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.business_rounded,
                                  color: isAll ? Colors.white : AppColors.onSurfaceVariant,
                                ),
                              ),
                              title: Text(
                                'جميع البراندات',
                                style: AppTextStyles.labelLg.copyWith(
                                  fontWeight: isAll ? FontWeight.bold : FontWeight.normal,
                                  color: isAll ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                              trailing: isAll
                                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                                  : null,
                              onTap: () {
                                ref.read(selectedBrandIdProvider.notifier).state = null;
                                Navigator.pop(context);
                              },
                            ),
                            ...brands.map((b) {
                              final isSelected = b.id == selectedBrandId;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.branding_watermark_rounded,
                                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                  ),
                                ),
                                title: Text(
                                  b.name,
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                                    : null,
                                onTap: () {
                                  ref.read(selectedBrandIdProvider.notifier).state = b.id;
                                  Navigator.pop(context);
                                },
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAll ? Icons.business_rounded : Icons.branding_watermark_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayName,
                        style: AppTextStyles.labelLg.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
        actions: [
          const NotificationActionIcon(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: AppColors.onSurface,
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
                  onTap: () => showQuickActionsSheet(context, ref),
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
}