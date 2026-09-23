import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/image_url_helper.dart';

class ExpenseApprovalsScreen extends ConsumerStatefulWidget {
  const ExpenseApprovalsScreen({super.key});

  @override
  ConsumerState<ExpenseApprovalsScreen> createState() => _ExpenseApprovalsScreenState();
}

class _ExpenseApprovalsScreenState extends ConsumerState<ExpenseApprovalsScreen> {
  List<ExpenseModel>? _allExpenses;
  bool _loading = true;
  String _selectedTab = 'all';
  String? _expandedExpenseId;
  final Map<String, TextEditingController> _reasonControllers = {};

  final _tabs = ['all', 'pending', 'approved', 'rejected'];
  final _tabLabels = ['All', 'Pending', 'Approved', 'Rejected'];

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

  List<ExpenseModel> get _filteredExpenses {
    if (_allExpenses == null) return [];
    if (_selectedTab == 'all') return _allExpenses!;
    return _allExpenses!.where((e) => e.status == _selectedTab).toList();
  }

  Future<void> _loadExpenses() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.dio.get('/expenses/team');
      final expenses = (response.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
      expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (mounted) setState(() => _allExpenses = expenses);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load team expenses: $e')));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _updateStatus(String expenseId, String status) async {
    final reason = _controllerFor(expenseId).text.trim();
    if (status == 'rejected' && reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.rejectionReasonIsRequired)));
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense $status'), behavior: SnackBarBehavior.floating),
        );
        _loadExpenses();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.expenseWasAlreadyReviewed)));
        }
        _loadExpenses();
      } else if (e.response?.statusCode == 403) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.response?.data?['detail'] ?? 'Not authorized')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.errorUpdatingExpenseStatus)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.errorUpdatingExpenseStatus)));
      }
    }
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

  Color _statusColor(String status) {
    switch (status) {
      case 'approved': return AppColors.success;
      case 'rejected': return AppColors.error;
      case 'escalated': return AppColors.warning;
      default: return AppColors.onSurfaceVariant;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      case 'escalated': return 'Escalated';
      default: return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(usersListProvider);
    final currentUser = ref.watch(currentUserProvider);
    final team = teamAsync.asData?.value ?? [];

    final filtered = _filteredExpenses;

    return Column(
      children: [
        // Filter tabs
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == _tabs[i];
                final count = _tabs[i] == 'all'
                    ? (_allExpenses?.length ?? 0)
                    : (_allExpenses?.where((e) => e.status == _tabs[i]).length ?? 0);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('${_tabLabels[i]} ($count)'),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedTab = _tabs[i]),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // Expense list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text('No ${_selectedTab == 'all' ? '' : '$_selectedTab '}expenses',
                              style: AppTextStyles.bodyMd),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadExpenses,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final expense = filtered[index];
                          final rep = team.where((u) => u.id == expense.repId).firstOrNull;
                          final isExpanded = _expandedExpenseId == expense.id;
                          final isOwn = currentUser?.id == expense.repId;
                          final isActionable = expense.status == 'pending' || expense.status == 'escalated';

                          return GlassCard(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
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
                                            Text(rep?.fullName ?? 'Unknown Rep',
                                                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('\$${expense.amount.toStringAsFixed(2)}',
                                              style: AppTextStyles.headlineSm.copyWith(color: AppColors.error)),
                                          const SizedBox(height: 2),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: _statusColor(expense.status).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(_statusLabel(expense.status),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: _statusColor(expense.status),
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Description
                                  if (expense.description != null && expense.description!.isNotEmpty) ...[
                                    Text(expense.description!, style: AppTextStyles.bodyMd),
                                    const SizedBox(height: 8),
                                  ],

                                  // Time
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: AppColors.onSurfaceVariant),
                                      const SizedBox(width: 4),
                                      Text(timeago.format(expense.createdAt),
                                          style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Receipt Image
                                  if (fullImageUrl(expense.receiptImageUrl).isNotEmpty) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(fullImageUrl(expense.receiptImageUrl), height: 100,
                                          width: double.infinity, fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 100,
                                            color: AppColors.outlineVariant.withValues(alpha: 0.3),
                                            child: Center(child: Icon(Icons.broken_image)),
                                          )),
                                    ),
                                    const SizedBox(height: 12),
                                  ],

                                  // GM-required badge
                                  if (expense.requiresGmApproval && expense.repId != currentUser?.id)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Icon(Icons.shield, size: 14, color: AppColors.warning),
                                          const SizedBox(width: 4),
                                          Text(AppStrings.requiresGmApproval,
                                              style: TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),

                                  // Action buttons (only for actionable, non-own expenses)
                                  if (isActionable && !isOwn) ...[
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
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.success, foregroundColor: Colors.white),
                                              child: Text(AppStrings.approve),
                                            ),
                                          ),
                                        ],
                                      ),

                                    // Rejection form
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
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.error,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],

                                  // Read-only indicator for own expenses
                                  if (isOwn)
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 14, color: AppColors.onSurfaceVariant),
                                        const SizedBox(width: 4),
                                        Text(AppStrings.yourExpenseReadOnly,
                                            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
