import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/analytics_models.dart';
import '../models/overview_model.dart';
import 'package:intl/intl.dart';

class PdfReportService {
  /// Generates and shares a full analytics report as PDF
  static Future<void> generateAndShareAnalyticsReport({
    required AnalyticsModel analytics,
    required SystemOverviewModel overview,
    required DateTime startDate,
    required DateTime endDate,
    String? brandName,
  }) async {
    final pdf = pw.Document();

    final dateRangeStr =
        '${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(endDate)}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => _buildHeader(brandName, dateRangeStr, ctx),
        footer: (ctx) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Generated automatically by PDOS  |  Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: const pw.TextStyle(color: PdfColors.grey500, fontSize: 9),
          ),
        ),
        build: (ctx) => [
          pw.SizedBox(height: 8),
          // ── Overview summary ──────────────────────────────────────────
          _sectionTitle('System Overview'),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _kpiBox('Total Users', '${overview.totalUsers}', PdfColors.indigo900),
              _kpiBox('Centers', '${overview.totalCenters}', PdfColors.teal700),
              _kpiBox('Products', '${overview.totalProducts}', PdfColors.blueGrey700),
              _kpiBox('Pending', '${overview.pendingAppointments}', PdfColors.orange700),
            ],
          ),
          pw.SizedBox(height: 28),

          // ── KPIs ──────────────────────────────────────────────────────
          _sectionTitle('Key Performance Indicators'),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _kpiBox(
                'Total Revenue',
                '\$${analytics.totalRevenue.toStringAsFixed(2)}',
                PdfColors.green800,
              ),
              _kpiBox(
                'Completed Visits',
                '${analytics.visitsCompleted} / ${analytics.totalVisits}',
                PdfColors.blue800,
              ),
              _kpiBox(
                'Target Completion',
                '${analytics.targetCompletionPercent.toStringAsFixed(1)}%',
                PdfColors.purple800,
              ),
              _kpiBox(
                'Avg Visits / Rep',
                analytics.avgVisitsPerRep.toStringAsFixed(1),
                PdfColors.red800,
              ),
            ],
          ),
          pw.SizedBox(height: 28),

          // ── Top Reps ──────────────────────────────────────────────────
          if (analytics.topReps.isNotEmpty) ...[
            _sectionTitle('Top Performing Representatives'),
            pw.SizedBox(height: 12),
            _buildTopRepsTable(analytics.topReps),
            pw.SizedBox(height: 28),
          ],

          // ── Top Products ──────────────────────────────────────────────
          if (analytics.topProducts.isNotEmpty) ...[
            _sectionTitle('Top Selling Products'),
            pw.SizedBox(height: 12),
            _buildTopProductsTable(analytics.topProducts),
          ],
        ],
      ),
    );

    final bytes = await pdf.save();
    final fileName =
        'Analytics_${brandName?.replaceAll(' ', '_') ?? 'All'}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
      String? brandName, String dateRange, pw.Context ctx) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Analytics Report — ${brandName ?? 'All Brands'}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo900,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Period: $dateRange',
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const pw.BoxDecoration(
                color: PdfColors.indigo50,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                'PDOS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo700,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.indigo200, thickness: 1.5),
        pw.SizedBox(height: 4),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const pw.BoxDecoration(
        color: PdfColors.indigo50,
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.indigo600, width: 4),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.indigo900,
        ),
      ),
    );
  }

  static pw.Widget _kpiBox(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: PdfColors.grey200),
          boxShadow: [
            const pw.BoxShadow(
              color: PdfColors.grey200,
              blurRadius: 4,
              offset: PdfPoint(0, 2),
            ),
          ],
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTopRepsTable(List<RepPerformanceModel> reps) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo600),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
      },
      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.indigo50),
      headers: ['#', 'Representative', 'Revenue', 'Visits'],
      data: reps.map((rep) {
        return [
          '${rep.rank}',
          rep.repName,
          '\$${rep.totalRevenue.toStringAsFixed(2)}',
          '${rep.totalVisits}',
        ];
      }).toList(),
    );
  }

  static pw.Widget _buildTopProductsTable(
      List<ProductPerformanceModel> products) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal600),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
      },
      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.teal50),
      headers: ['#', 'Product', 'Revenue', 'Units Sold'],
      data: products.map((prod) {
        return [
          '${prod.rank}',
          prod.productName,
          '\$${prod.totalRevenue.toStringAsFixed(2)}',
          '${prod.unitsSold}',
        ];
      }).toList(),
    );
  }
}
