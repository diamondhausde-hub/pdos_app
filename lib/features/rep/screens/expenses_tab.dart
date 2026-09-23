import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/add_expense_sheet.dart';
import '../widgets/performance_layout.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(myExpensesProvider);

    return PerformanceLayout(
      currentIndex: 2,
      title: AppStrings.expenses,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myExpensesProvider);
          await ref.read(myExpensesProvider.future);
        },
        child: expensesAsync.when(
          loading: () => const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(height: 400, child: Center(child: CircularProgressIndicator())),
          ),
          error: (err, stack) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(height: 400, child: Center(child: Text('Error: $err'))),
          ),
          data: (expenses) {
            if (expenses.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.receipt_long_rounded,
                              size: 28, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        Text(AppStrings.noRecordedExpenses,
                            style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Text(AppStrings.visitExpensesWillAppear,
                            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              );
            }

            final totalAmount = expenses.fold<double>(0, (sum, e) => sum + e.amount);
            final byCategory = _groupByCategory(expenses);

            return ListView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), // Extra bottom padding for FAB
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.expenseAnalysis,
                          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 4),
                      Text(AppStrings.overviewOfYourSpending,
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: _ExpensePieChart(byCategory: byCategory),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  variant: GlassVariant.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.totalExpenses,
                              style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text('\$${totalAmount.toStringAsFixed(2)}',
                              style: AppTextStyles.priceLg),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.account_balance_wallet_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.details, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 12),
                ...byCategory.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _CategorySummaryRow(
                    category: entry.key,
                    total: entry.value.fold<double>(0, (s, e) => s + e.amount),
                    count: entry.value.length,
                    color: _categoryColor(entry.key),
                  ),
                )),
                const Divider(height: 32),
                ...expenses.map((expense) {
                  final dateStr = DateFormat('MMM dd, yyyy').format(expense.createdAt);
                  return GlassCard(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_categoryLabel(expense.category),
                                      style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                                  const SizedBox(height: 2),
                                  Text(expense.description ?? dateStr,
                                      style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Text('\$${expense.amount.toStringAsFixed(2)}',
                                style: AppTextStyles.headlineSm.copyWith(color: AppColors.error)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusBadge(expense.status),
                            if (expense.status == 'rejected' && expense.rejectionReason != null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text('Reason: ${expense.rejectionReason}', 
                                      style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AddExpenseSheet(),
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add_rounded, color: AppColors.onPrimary),
      ),
    ));
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
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
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Map<String, List<ExpenseModel>> _groupByCategory(List<ExpenseModel> expenses) {
    final map = <String, List<ExpenseModel>>{};
    for (final e in expenses) {
      map.putIfAbsent(e.category, () => []).add(e);
    }
    return map;
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

class _ExpensePieChart extends StatelessWidget {
  final Map<String, List<ExpenseModel>> byCategory;

  const _ExpensePieChart({required this.byCategory});

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.info, AppColors.warning, AppColors.secondary, AppColors.primary, AppColors.error];
    final total = byCategory.values.fold<double>(
      0, (sum, list) => sum + list.fold<double>(0, (s, e) => s + e.amount),
    );
    if (total == 0) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: byCategory.entries.toList().asMap().entries.map((entry) {
                final i = entry.key;
                final catTotal = entry.value.value.fold<double>(0, (s, e) => s + e.amount);
                final pct = (catTotal / total * 100);
                return PieChartSectionData(
                  value: catTotal,
                  color: colors[i % colors.length],
                  radius: 45,
                  title: '${pct.toStringAsFixed(0)}%',
                  titleStyle: TextStyle(
                      color: AppColors.onPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: byCategory.entries.toList().asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value.key;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_categoryLabel(cat), style: AppTextStyles.bodySm),
                ],
              ),
            );
          }).toList(),
        ),
      ],
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
}

class _CategorySummaryRow extends StatelessWidget {
  final String category;
  final double total;
  final int count;
  final Color color;

  const _CategorySummaryRow({required this.category, required this.total, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_categoryLabel(category),
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
          ),
          Text('$count expense(s)',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(width: 16),
          Text('\$${total.toStringAsFixed(2)}',
              style: AppTextStyles.headlineSm.copyWith(color: AppColors.error)),
        ],
      ),
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
}
