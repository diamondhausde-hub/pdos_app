import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/utils/image_url_helper.dart';

final allExpensesProvider =
    FutureProvider.autoDispose.family<List<ExpenseModel>, String?>((ref, brandId) async {
  final api = ApiService.instance;
  final params = <String, dynamic>{};
  if (brandId != null) params['brand_id'] = brandId;
  final response = await api.dio.get('/expenses/all', queryParameters: params);
  return (response.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
});

class AllExpensesTab extends ConsumerStatefulWidget {
  const AllExpensesTab({super.key});

  @override
  ConsumerState<AllExpensesTab> createState() => _AllExpensesTabState();
}

class _AllExpensesTabState extends ConsumerState<AllExpensesTab> {
  String _selectedFilter = 'All';
  bool _isExporting = false;

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  final Set<String> _processingExpenseIds = {};

  bool _canReview(ExpenseModel expense) {
    if (expense.status == 'approved' || expense.status == 'rejected') {
      return false;
    }
    return expense.status == 'pending' ||
        expense.status == 'escalated' ||
        expense.requiresGmApproval;
  }

  Future<void> _updateExpenseStatus(String expenseId, String status,
      {String? reason}) async {
    if (_processingExpenseIds.contains(expenseId)) return;
    setState(() => _processingExpenseIds.add(expenseId));
    try {
      final api = ApiService.instance;
      await api.dio.patch('/expenses/$expenseId/status', data: {
        'status': status,
        if (reason != null && reason.isNotEmpty) 'rejection_reason': reason,
      });
      if (mounted) {
        final selectedBrandId = ref.read(selectedBrandIdProvider);
        ref.invalidate(allExpensesProvider(selectedBrandId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                status == 'approved' ? 'تم قبول المصروف بنجاح' : 'تم رفض المصروف'),
            backgroundColor:
                status == 'approved' ? AppColors.success : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث حالة المصروف: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processingExpenseIds.remove(expenseId));
      }
    }
  }

  void _showRejectDialog(ExpenseModel expense) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('رفض المصروف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'هل أنت متأكد من رفض مصروف ${expense.repName ?? 'المندوب'} بقيمة \$${expense.amount.toStringAsFixed(2)}؟'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'سبب الرفض (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateExpenseStatus(expense.id, 'rejected',
                  reason: controller.text.trim());
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تأكيد الرفض'),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, ExpenseModel expense) {
    final statusColor = _statusColor(expense.status);
    final statusIcon = _statusIcon(expense.status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCard
                    : AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.category.toUpperCase(),
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.textSecondaryLight,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          expense.status.toUpperCase(),
                          style: AppTextStyles.labelSm.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Details grid
                  _DetailRow(
                    icon: Icons.person_rounded,
                    label: 'Representative',
                    value: expense.repName ?? 'Unknown Rep',
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Submitted',
                    value: DateFormat('dd MMM yyyy, HH:mm').format(expense.createdAt),
                  ),
                  if (expense.description != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Description',
                      value: expense.description!,
                    ),
                  ],
                  if (expense.visitId != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.place_rounded,
                      label: 'Visit ID',
                      value: expense.visitId!,
                    ),
                  ],
                  if (expense.approvedBy != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.verified_user_rounded,
                      label: 'Approved By',
                      value: expense.approvedBy!,
                    ),
                  ],
                  if (expense.approvedAt != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Approved At',
                      value: DateFormat('dd MMM yyyy, HH:mm').format(expense.approvedAt!),
                    ),
                  ],
                  if (expense.rejectionReason != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.info_outline_rounded,
                      label: 'Rejection Reason',
                      value: expense.rejectionReason!,
                      valueColor: AppColors.error,
                    ),
                  ],

                  if (expense.requiresAdminApproval || expense.requiresGmApproval) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (expense.requiresAdminApproval)
                          _Badge(label: 'Requires Admin Approval', color: AppColors.warning),
                        if (expense.requiresGmApproval)
                          _Badge(label: 'Requires GM Approval', color: AppColors.info),
                      ],
                    ),
                  ],

                  // Receipt image
                  if (fullImageUrl(expense.receiptImageUrl).isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Receipt', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        fullImageUrl(expense.receiptImageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(Icons.broken_image_rounded,
                                color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_canReview(expense)) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _processingExpenseIds.contains(expense.id)
                                ? null
                                : () {
                                    Navigator.pop(ctx);
                                    _showRejectDialog(expense);
                                  },
                            icon: const Icon(Icons.close_rounded, color: AppColors.error),
                            label: const Text(
                              'رفض',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.error),
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _processingExpenseIds.contains(expense.id)
                                ? null
                                : () {
                                    Navigator.pop(ctx);
                                    _updateExpenseStatus(expense.id, 'approved');
                                  },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text(
                              'قبول',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close_rounded),
                          label: Text('Close'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _exportSingleToPdf(expense);
                          },
                          icon: Icon(Icons.picture_as_pdf_rounded),
                          label: Text('Export'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _exportSingleToPdf(ExpenseModel expense) async {
    setState(() => _isExporting = true);
    try {
      final pdf = pw.Document();
      final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(expense.createdAt);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Expense Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                  pw.Text(expense.status.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: expense.status == 'approved' ? PdfColors.green700 : expense.status == 'rejected' ? PdfColors.red700 : PdfColors.orange700)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text('Generated on ${DateFormat('dd MMM yyyy').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              pw.SizedBox(height: 24),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 24),
              
              _pdfDetailRow('Representative', expense.repName ?? 'Unknown'),
              pw.SizedBox(height: 12),
              _pdfDetailRow('Amount', '\$${expense.amount.toStringAsFixed(2)}'),
              pw.SizedBox(height: 12),
              _pdfDetailRow('Category', expense.category.toUpperCase()),
              pw.SizedBox(height: 12),
              _pdfDetailRow('Submitted', dateStr),
              if (expense.description != null && expense.description!.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _pdfDetailRow('Description', expense.description!),
              ],
              if (expense.visitId != null) ...[
                pw.SizedBox(height: 12),
                _pdfDetailRow('Visit ID', expense.visitId!),
              ],
              if (expense.approvedBy != null) ...[
                pw.SizedBox(height: 12),
                _pdfDetailRow('Approved By', expense.approvedBy!),
              ],
              if (expense.approvedAt != null) ...[
                pw.SizedBox(height: 12),
                _pdfDetailRow('Approved At', DateFormat('dd MMM yyyy, HH:mm').format(expense.approvedAt!)),
              ],
              if (expense.rejectionReason != null) ...[
                pw.SizedBox(height: 12),
                _pdfDetailRow('Rejection Reason', expense.rejectionReason!),
              ],
            ],
          ),
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'expense_${expense.id}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  pw.Widget _pdfDetailRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(label, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 12, color: PdfColors.black)),
        ),
      ],
    );
  }

  Future<void> _exportToPdf(List<ExpenseModel> expenses) async {
    setState(() => _isExporting = true);
    try {
      final pdf = pw.Document();
      final dateStr = DateFormat('dd MMM yyyy').format(DateTime.now());

      // Summary stats
      final total = expenses.fold<double>(0, (s, e) => s + e.amount);
      final approved = expenses.where((e) => e.status == 'approved').length;
      final pending = expenses.where((e) => e.status == 'pending' || e.status == 'escalated').length;
      final rejected = expenses.where((e) => e.status == 'rejected').length;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Company Expenses Report',
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('Generated on $dateStr',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                    ],
                  ),
                  pw.Text('${expenses.length} Expenses',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 12),
              // Summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfStat('Total Amount', '\$${total.toStringAsFixed(2)}', PdfColors.indigo700),
                  _pdfStat('Approved', '$approved', PdfColors.green700),
                  _pdfStat('Pending', '$pending', PdfColors.orange700),
                  _pdfStat('Rejected', '$rejected', PdfColors.red700),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey300),
            ],
          ),
          build: (ctx) => [
            pw.SizedBox(height: 8),
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2.5),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.2),
                3: const pw.FlexColumnWidth(1.2),
                4: const pw.FlexColumnWidth(1.2),
              },
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
                  children: [
                    _pdfCell('Representative', isHeader: true),
                    _pdfCell('Description', isHeader: true),
                    _pdfCell('Category', isHeader: true),
                    _pdfCell('Amount', isHeader: true),
                    _pdfCell('Status', isHeader: true),
                  ],
                ),
                // Rows
                ...expenses.map((e) => pw.TableRow(
                  children: [
                    _pdfCell(e.repName ?? 'Unknown'),
                    _pdfCell(e.description ?? '-'),
                    _pdfCell(e.category),
                    _pdfCell('\$${e.amount.toStringAsFixed(2)}'),
                    _pdfCell(e.status.toUpperCase(),
                        color: e.status == 'approved'
                            ? PdfColors.green700
                            : e.status == 'rejected'
                                ? PdfColors.red700
                                : PdfColors.orange700),
                  ],
                )),
              ],
            ),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'expenses_$dateStr.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  pw.Widget _pdfStat(String label, String value, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 13, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  pw.Widget _pdfCell(String text,
      {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? (isHeader ? PdfColors.indigo900 : PdfColors.grey800),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBrandId = ref.watch(selectedBrandIdProvider);
    final expensesAsync = ref.watch(allExpensesProvider(selectedBrandId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company Expenses', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      'Tap any expense to view details',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
              // Export button
              expensesAsync.when(
                data: (expenses) {
                  final filtered = _selectedFilter == 'All'
                      ? expenses
                      : _selectedFilter == 'Pending'
                          ? expenses
                              .where((e) =>
                                  e.status.toLowerCase() == 'pending' ||
                                  e.status.toLowerCase() == 'escalated')
                              .toList()
                          : expenses
                              .where((e) =>
                                  e.status.toLowerCase() ==
                                  _selectedFilter.toLowerCase())
                              .toList();
                  return _isExporting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton.filledTonal(
                          onPressed: filtered.isEmpty
                              ? null
                              : () => _exportToPdf(filtered),
                          icon: Icon(Icons.ios_share_rounded),
                          tooltip: 'Export to PDF',
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            foregroundColor: AppColors.primary,
                          ),
                        );
                },
                loading: () => const SizedBox(width: 24, height: 24),
                error: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ),

        // Filter chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == 'All',
                    onTap: () => setState(() => _selectedFilter = 'All')),
                const SizedBox(width: 8),
                _FilterChip(
                    label: 'Pending',
                    isSelected: _selectedFilter == 'Pending',
                    onTap: () => setState(() => _selectedFilter = 'Pending')),
                const SizedBox(width: 8),
                _FilterChip(
                    label: 'Approved',
                    isSelected: _selectedFilter == 'Approved',
                    onTap: () => setState(() => _selectedFilter = 'Approved')),
                const SizedBox(width: 8),
                _FilterChip(
                    label: 'Rejected',
                    isSelected: _selectedFilter == 'Rejected',
                    onTap: () => setState(() => _selectedFilter = 'Rejected')),
              ],
            ),
          ),
        ),

        Expanded(
          child: expensesAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text('Failed to load expenses',
                        style: AppTextStyles.bodyLg),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(allExpensesProvider(selectedBrandId)),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (expenses) {
              final filtered = _selectedFilter == 'All'
                  ? expenses
                  : _selectedFilter == 'Pending'
                      ? expenses
                          .where((e) =>
                              e.status.toLowerCase() == 'pending' ||
                              e.status.toLowerCase() == 'escalated')
                          .toList()
                      : expenses
                          .where((e) =>
                              e.status.toLowerCase() ==
                              _selectedFilter.toLowerCase())
                          .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.receipt_long_rounded,
                            size: 32, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ${_selectedFilter == 'All' ? '' : '${_selectedFilter.toLowerCase()} '}expenses',
                        style: AppTextStyles.bodyLg
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              // Summary banner
              final totalAmount =
                  filtered.fold<double>(0, (s, e) => s + e.amount);

              return Column(
                children: [
                  // Summary bar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_long_rounded,
                                  size: 16,
                                  color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 6),
                              Text('${filtered.length} expenses',
                                  style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                          Text(
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final brandId = ref.read(selectedBrandIdProvider);
                        ref.invalidate(allExpensesProvider(brandId));
                      },
                      child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final expense = filtered[index];
                        final statusColor = _statusColor(expense.status);
                        final statusIcon = _statusIcon(expense.status);

                        return GestureDetector(
                          onTap: () => _showDetail(context, expense),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            margin: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Status badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(statusIcon,
                                              size: 13, color: statusColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            expense.status.toUpperCase(),
                                            style:
                                                AppTextStyles.labelSm.copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Amount + chevron
                                    Row(
                                      children: [
                                        Text(
                                          '\$${expense.amount.toStringAsFixed(2)}',
                                          style: AppTextStyles.h3
                                              .copyWith(color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 18,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  expense.category.toUpperCase(),
                                  style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      letterSpacing: 1.0),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  expense.description ??
                                      'No description provided',
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                    height: 1,
                                    color: AppColors.surfaceContainerHigh),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person_rounded,
                                            size: 13,
                                            color: AppColors.textSecondaryLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          expense.repName ?? 'Unknown Rep',
                                          style: AppTextStyles.labelSm.copyWith(
                                              color:
                                                  AppColors.textSecondaryLight),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded,
                                            size: 13,
                                            color: AppColors.textSecondaryLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          timeago.format(expense.createdAt),
                                          style: AppTextStyles.labelSm.copyWith(
                                              color:
                                                  AppColors.textSecondaryLight),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (_canReview(expense)) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: _processingExpenseIds.contains(expense.id)
                                            ? null
                                            : () => _showRejectDialog(expense),
                                        icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error),
                                        label: const Text(
                                          'رفض',
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: AppColors.error),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          minimumSize: const Size(0, 36),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      FilledButton.icon(
                                        onPressed: _processingExpenseIds.contains(expense.id)
                                            ? null
                                            : () => _updateExpenseStatus(expense.id, 'approved'),
                                        icon: _processingExpenseIds.contains(expense.id)
                                            ? const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(Icons.check_rounded, size: 16),
                                        label: const Text(
                                          'قبول',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                        ),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.success,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                          minimumSize: const Size(0, 36),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────── Helper Widgets ──────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.labelSm
                      .copyWith(color: AppColors.textSecondaryLight)),
              const SizedBox(height: 2),
              Text(value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.labelSm.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
