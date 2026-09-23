import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/glass_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  late AnimationController _slideController;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.local_pharmacy_rounded,
      title: AppStrings.welcomeToPdos,
      body: 'Your all-in-one pharmacy distribution operations system.',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.map_rounded,
      title: AppStrings.manageTerritories,
      body: 'Track visits, inventory, and targets seamlessly in real-time.',
      color: AppColors.secondary,
    ),
    _OnboardingPage(
      icon: Icons.celebration_rounded,
      title: AppStrings.youReAllSet,
      body: "Your account is configured. Let's get started!",
      color: AppColors.tertiary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ApiService.instance.dio.put(
          '/users/${user.id}',
          data: {'has_completed_onboarding': true},
        );
        ref.invalidate(authNotifierProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.secondary.withValues(alpha: 0.05),
              AppColors.surface.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return AnimatedBuilder(
                      animation: _slideController,
                      builder: (context, child) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _slideController,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _slideController,
                                curve: const Interval(
                                  0.2,
                                  1,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            vertical: 48,
                            horizontal: 32,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: page.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                child: Icon(
                                  page.icon,
                                  size: 72,
                                  color: page.color,
                                ),
                              ),
                              const SizedBox(height: 48),
                              Text(
                                page.title,
                                style: AppTextStyles.displayMd.copyWith(
                                  color: AppColors.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.body,
                                style: AppTextStyles.bodyLg.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 10,
                    width: _currentPage == index ? 28 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _currentPage == _pages.length - 1
                      ? ElevatedButton(
                          onPressed: _isLoading ? null : _completeOnboarding,
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.onPrimary,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppStrings.getStarted),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        )
                      : Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  _pages.length - 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                              child: Text(AppStrings.skip),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                              child: Row(
                                children: [
                                  Text(AppStrings.next),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
}
