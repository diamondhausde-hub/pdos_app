import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/theme.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late AnimationController _floatController;
  late Animation<double> _floatAnim;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _floatController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .login(
            _emailController.text.trim().toLowerCase(),
            _passwordController.text,
          );
    } catch (error) {
      setState(() => _errorMessage = 'Incorrect email or password.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authNotifierProvider).status;
    
    // Show a clean loading splash while checking cached session
    if (authStatus == AuthStateStatus.initial) {
      return Scaffold(
        body: Container(
          color: AppColors.surfaceContainerLowest,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    return Scaffold(
      body: Container(
        color: AppColors.surfaceContainerLowest,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: SlideTransition(
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
                      curve: const Interval(0.2, 1, curve: Curves.easeOut),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _floatAnim,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnim.value),
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: AppColors.glowShadow,
                                  image: const DecorationImage(
                                    image: AssetImage('assets/icons/app_icon.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome Back',
                              style: AppTextStyles.headlineLg.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sign in to manage your daily operations',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),

                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTextStyles.bodyMd.copyWith(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: AppStrings.email,
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                hintText: AppStrings.enterYourEmailAddress,
                                isDense: true,
                              ),
                              style: AppTextStyles.bodyMd,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AppTextStyles.bodyMd,
                              decoration: InputDecoration(
                                labelText: AppStrings.password,
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.lock_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                hintText: AppStrings.enterYourPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(AppStrings.signIn),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 20,
                                            color: AppColors.onPrimary,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
