import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/auth_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _hasMinLength(String pwd) => pwd.length >= 8;
  bool _hasUppercase(String pwd) => pwd.contains(RegExp(r'[A-Z]'));
  bool _hasNumber(String pwd) => pwd.contains(RegExp(r'[0-9]'));

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await ApiService.instance.dio.put(
        '/users/me/password',
        data: {'password': _passwordController.text},
      );
      ref.invalidate(currentUserProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.passwordUpdated), backgroundColor: AppColors.success),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to update password: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.changePassword),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: AppColors.glowShadow,
              ),
              child: Icon(Icons.lock_reset_rounded, size: 40, color: AppColors.onPrimary),
            ),
            const SizedBox(height: 20),
            Text(AppStrings.setNewPassword, style: AppTextStyles.headlineLg.copyWith(
              color: AppColors.onSurface, fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 8),
            Text(AppStrings.createASecurePassword,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage!, style: AppTextStyles.bodySm.copyWith(color: AppColors.error))),
                ]),
              ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyles.bodyMd,
                    decoration: InputDecoration(
                      labelText: AppStrings.newPassword,
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: AppColors.onSurfaceVariant),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true, fillColor: AppColors.inputFill(isDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter a password';
                      if (!_hasMinLength(value)) return 'Too short';
                      if (!_hasUppercase(value)) return 'Needs uppercase letter';
                      if (!_hasNumber(value)) return 'Needs a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    style: AppTextStyles.bodyMd,
                    decoration: InputDecoration(
                      labelText: AppStrings.confirmPassword,
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: AppColors.onSurfaceVariant),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      filled: true, fillColor: AppColors.inputFill(isDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.requirements, style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurface)),
                        const SizedBox(height: 8),
                        _RequirementRow(text: AppStrings.atLeast8Characters, isMet: _hasMinLength(_passwordController.text)),
                        const SizedBox(height: 4),
                        _RequirementRow(text: AppStrings.oneUppercaseLetter, isMet: _hasUppercase(_passwordController.text)),
                        const SizedBox(height: 4),
                        _RequirementRow(text: AppStrings.oneNumber, isMet: _hasNumber(_passwordController.text)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.onPrimary))
                          : Text(AppStrings.updatePassword, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;
  const _RequirementRow({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: isMet ? AppColors.success : AppColors.outlineVariant,
          ),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.bodySm.copyWith(
            color: isMet ? AppColors.success : AppColors.onSurfaceVariant,
          )),
        ],
      ),
    );
  }
}
