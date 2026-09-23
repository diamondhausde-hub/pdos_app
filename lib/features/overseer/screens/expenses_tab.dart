import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';

class OverseerExpensesTab extends ConsumerStatefulWidget {
  const OverseerExpensesTab({super.key});

  @override
  ConsumerState<OverseerExpensesTab> createState() =>
      _OverseerExpensesTabState();
}

class _OverseerExpensesTabState extends ConsumerState<OverseerExpensesTab> {
  List<ExpenseModel>? _expenses;
  bool _loading = true;
  bool _isExporting = false;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadExpenses();
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

  void _showDetail(BuildContext context, ExpenseModel expense) {
    Color statusColor;
    IconData statusIcon;
    switch (expense.status) {
      case 'approved':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending_rounded;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, controller) => Container(
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _categoryColor(expense.category).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(expense.categoryIcon,
                        color: _categoryColor(expense.category), size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_categoryLabel(expense.category).toUpperCase(),
                            style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.textSecondaryLight,
                                letterSpacing: 1.2)),
                        const SizedBox(height: 2),
                        Text('\$${expense.amount.toStringAsFixed(2)}',
                            style: AppTextStyles.h2.copyWith(
                                color: AppColors.overseerColor)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 13, color: statusColor),
                        const SizedBox(width: 4),
                        Text(expense.status.toUpperCase(),
                            style: AppTextStyles.labelSm.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.person_rounded,
                label: 'Representative',
                value: expense.repName ?? expense.repId,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.calendar_today_rounded,
                label: 'Submitted',
                value: DateFormat('dd MMM yyyy, HH:mm').format(expense.createdAt),
              ),
              if (expense.description != null &&
                  expense.description!.isNotEmpty) ...[
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
                  value: DateFormat('dd MMM yyyy, HH:mm')
                      .format(expense.approvedAt!),
                ),
              ],
              if (expense.status == 'rejected' &&
                  expense.rejectionReason != null) ...[
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Rejection Reason',
                  value: expense.rejectionReason!,
                  valueColor: AppColors.error,
                ),
              ],
              if (expense.requiresAdminApproval ||
                  expense.requiresGmApproval) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    if (expense.requiresAdminApproval)
                      _Badge(
                          label: 'Requires Admin Approval',
                          color: AppColors.warning),
                    if (expense.requiresGmApproval)
                      _Badge(
                          label: 'Requires GM Approval',
                          color: AppColors.info),
                  ],
                ),
              ],
              if (expense.receiptImageUrl != null &&
                  expense.receiptImageUrl!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Receipt', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    expense.receiptImageUrl!,
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
              const SizedBox(height: 24),
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
                        backgroundColor: AppColors.overseerColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _exportToPdf() async {
    final expenses = _expenses;
    if (expenses == null || expenses.isEmpty) return;
    setState(() => _isExporting = true);
    try {
      final pdf = pw.Document();
      final dateStr = DateFormat('dd MMM yyyy').format(DateTime.now());
      final total = expenses.fold<double>(0, (s, e) => s + e.amount);
      final approved = expenses.where((e) => e.status == 'approved').length;
      final pending = expenses.where((e) => e.status == 'pending').length;
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
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('Generated on $dateStr',
                          style: const pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey600)),
                    ],
                  ),
                  pw.Text('${expenses.length} Expenses',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.purple700)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfStat('Total Amount',
                      '\$${total.toStringAsFixed(2)}', PdfColors.purple700),
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
              border: pw.TableBorder.all(
                  color: PdfColors.grey300, width: 0.5),
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.purple50),
                  children: [
                    _pdfCell('Representative', isHeader: true),
                    _pdfCell('Description', isHeader: true),
                    _pdfCell('Category', isHeader: true),
                    _pdfCell('Amount', isHeader: true),
                    _pdfCell('Status', isHeader: true),
                  ],
                ),
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
          SnackBar(
              content: Text('Export failed: $e'),
              backgroundColor: AppColors.error),
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
            style: const pw.TextStyle(
                fontSize: 9, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: color)),
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
          fontWeight: isHeader
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
          color: color ??
              (isHeader ? PdfColors.purple900 : PdfColors.grey800),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Expenses', style: AppTextStyles.headlineMd),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isExporting)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            IconButton(
              icon: Icon(Icons.ios_share_rounded),
              tooltip: 'Export to PDF',
              onPressed: (_expenses == null || _expenses!.isEmpty)
                  ? null
                  : _exportToPdf,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          if (_expenses != null && _expenses!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_expenses!.length} expenses',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant)),
                    Text(
                      'Total: \$${_expenses!.fold<double>(0, (s, e) => s + e.amount).toStringAsFixed(2)}',
                      style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.overseerColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = ['all', 'pending', 'approved', 'rejected'];
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
              label: Text(f == 'all'
                  ? 'All'
                  : f[0].toUpperCase() + f.substring(1)),
              selected: selected,
              onSelected: (_) {
                setState(() => _statusFilter = f);
                _loadExpenses();
              },
              selectedColor:
                  AppColors.overseerColor.withValues(alpha: 0.15),
              checkmarkColor: AppColors.overseerColor,
              labelStyle: TextStyle(
                color: selected
                    ? AppColors.overseerColor
                    : AppColors.onSurfaceVariant,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
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
            Icon(Icons.receipt_long_rounded,
                size: 64, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No expenses found', style: AppTextStyles.bodyMd),
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
          return GestureDetector(
            onTap: () => _showDetail(context, expense),
            child: GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _categoryColor(expense.category)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(expense.categoryIcon,
                              color: _categoryColor(expense.category),
                              size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_categoryLabel(expense.category),
                                  style: AppTextStyles.bodyLg.copyWith(
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  expense.repName ?? expense.repId,
                                  style: AppTextStyles.bodySm.copyWith(
                                      color:
                                          AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: AppTextStyles.headlineSm
                                  .copyWith(color: AppColors.error),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded,
                                size: 16,
                                color: AppColors.onSurfaceVariant),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (expense.description != null &&
                        expense.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          expense.description!,
                          style: AppTextStyles.bodyMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14,
                            color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          timeago.format(expense.createdAt),
                          style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant),
                        ),
                        const Spacer(),
                        _buildStatusBadge(expense.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
          color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'transport':
        return 'Transport';
      case 'meals':
        return 'Meals';
      case 'supplies':
        return 'Supplies';
      case 'other':
        return 'Other';
      default:
        return category;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'transport':
        return AppColors.info;
      case 'meals':
        return AppColors.warning;
      case 'supplies':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}

// ─────────────────────────────── Shared Widgets ──────────────────────────────

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
