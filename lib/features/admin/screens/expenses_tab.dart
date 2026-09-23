import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';

class AdminExpensesTab extends ConsumerStatefulWidget {
  const AdminExpensesTab({super.key});

  @override
  ConsumerState<AdminExpensesTab> createState() => _AdminExpensesTabState();
}

class _AdminExpensesTabState extends ConsumerState<AdminExpensesTab> {
  List<ExpenseModel>? _expenses;
  bool _loading = true;
  String _statusFilter = 'pending';
  String? _expandedExpenseId;
  final Map<String, TextEditingController> _reasonControllers = {};

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  @override
  void dispose() {
    for (final c in _reasonControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String id) {
    return _reasonControllers.putIfAbsent(id, () => TextEditingController());
  }

  Future<void> _loadExpenses() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final uri = _statusFilter == 'all'
          ? '/expenses/all'
          : '/expenses/all?status=$_statusFilter';
      final response = await api.dio.get(uri);
      final expenses = (response.data as List)
          .map((e) => ExpenseModel.fromJson(e))
          .toList();
      expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (mounted) setState(() => _expenses = expenses);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load expenses: $e')),
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _updateStatus(String expenseId, String status) async {
    final reason = _controllerFor(expenseId).text.trim();
    if (status == 'rejected' && reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.rejectionReasonIsRequired)),
      );
      return;
    }

    try {
      final api = ref.read(apiServiceProvider);
      await api.dio.patch('/expenses/$expenseId/status', data: {
        'status': status,
        'rejection_reason': status == 'rejected' ? reason : null,
      });
      _controllerFor(expenseId).clear();
      if (mounted) {
        setState(() {
          _expenses?.removeWhere((e) => e.id == expenseId);
          _expandedExpenseId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense $status'), behavior: SnackBarBehavior.floating),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.expenseWasAlreadyReviewed)),
          );
        }
        _loadExpenses();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.errorUpdatingExpenseStatus)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorUpdatingExpenseStatus)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(AppStrings.allExpenses, style: AppTextStyles.headlineMd),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = ['pending', 'approved', 'rejected', 'all'];
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters.map((f) {
          final selected = _statusFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f == 'all' ? 'All' : f[0].toUpperCase() + f.substring(1)),
              selected: selected,
              onSelected: (_) {
                setState(() => _statusFilter = f);
                _loadExpenses();
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_expenses == null || _expenses!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green.shade300),
            const SizedBox(height: 16),
            Text(AppStrings.noExpensesFound, style: AppTextStyles.bodyMd),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadExpenses,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: _expenses!.length,
        itemBuilder: (context, index) {
          final expense = _expenses![index];
          final isExpanded = _expandedExpenseId == expense.id;
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: _categoryColor(expense.category).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(expense.categoryIcon, color: _categoryColor(expense.category), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_categoryLabel(expense.category),
                                style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                            Text(expense.repName ?? expense.repId,
                                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Text('\$${expense.amount.toStringAsFixed(2)}',
                          style: AppTextStyles.headlineSm.copyWith(color: AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (expense.description != null && expense.description!.isNotEmpty) ...[
                    Text(expense.description!, style: AppTextStyles.bodyMd),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(timeago.format(expense.createdAt),
                          style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      const Spacer(),
                      _buildStatusBadge(expense.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (fullImageUrl(expense.receiptImageUrl).isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(fullImageUrl(expense.receiptImageUrl), height: 100, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100, color: AppColors.outlineVariant.withValues(alpha: 0.3),
                          child: Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (expense.status == 'pending') ...[
                    if (!isExpanded)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _expandedExpenseId = expense.id),
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                              child: Text(AppStrings.reject),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _updateStatus(expense.id, 'approved'),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                              child: Text(AppStrings.approve),
                            ),
                          ),
                        ],
                      ),
                    if (isExpanded) ...[
                      TextField(
                        controller: _controllerFor(expense.id),
                        decoration: InputDecoration(
                          hintText: AppStrings.reasonForRejection,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: AppColors.surfaceContainerLow,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _expandedExpenseId = null),
                            child: Text(AppStrings.cancel),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () => _updateStatus(expense.id, 'rejected'),
                            icon: Icon(Icons.close, size: 16),
                            label: Text(AppStrings.confirmReject),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ],
                  if (expense.status == 'rejected' && expense.rejectionReason != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppColors.error),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(expense.rejectionReason!,
                                style: AppTextStyles.bodySm.copyWith(color: AppColors.error)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor; Color textColor;
    switch (status) {
      case 'approved':
        bgColor = AppColors.success.withValues(alpha: 0.15);
        textColor = AppColors.success;
        break;
      case 'rejected':
        bgColor = AppColors.error.withValues(alpha: 0.15);
        textColor = AppColors.error;
        break;
      default:
        bgColor = AppColors.warning.withValues(alpha: 0.15);
        textColor = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(),
          style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'transport': return 'Transport';
      case 'meals': return 'Meals';
      case 'supplies': return 'Supplies';
      case 'other': return 'Other';
      default: return category;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'transport': return AppColors.info;
      case 'meals': return AppColors.warning;
      case 'supplies': return AppColors.secondary;
      default: return AppColors.primary;
    }
  }
}
