import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class VisitPdfService {
  static Future<String?> generateAndShareVisitPdf({
    required String repName,
    required String targetName,
    required DateTime visitDate,
    required List<Map<String, dynamic>> salesItems,
    required List<Map<String, dynamic>> stockChecks,
    required List<dynamic> expenses,
    required List<dynamic> specialRequests,
    List<String> photos = const [],
    required String? notes,
    required String? signaturePath,
  }) async {
    try {
      final pdf = pw.Document();

      pw.ImageProvider? imageLogo;
      try {
        final logoBytes = await rootBundle.load('assets/images/logo.png');
        imageLogo = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppStrings.visitReport, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                      pw.SizedBox(height: 4),
                      pw.Text('Rep: $repName', style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Target: $targetName', style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(visitDate)}', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    ],
                  ),
                  if (imageLogo != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      child: pw.Image(imageLogo),
                    ),
                ],
              ),
              pw.Divider(height: 32, thickness: 1, color: PdfColors.grey300),

              if (salesItems.isNotEmpty) ...[
                pw.Text(AppStrings.salesOrders, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.TableHelper.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue600),
                  cellAlignment: pw.Alignment.centerLeft,
                  headers: ['Product', 'Qty Sold', 'Free', 'Price'],
                  data: salesItems.map((e) => [
                    e['productName'] ?? 'Unknown',
                    e['qtySold'].toString(),
                    e['qtyFree'].toString(),
                    '\$${e['priceAtSale']}',
                  ]).toList(),
                ),
                pw.SizedBox(height: 24),
              ],

              if (stockChecks.isNotEmpty) ...[
                pw.Text(AppStrings.stockChecks, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.TableHelper.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue600),
                  cellAlignment: pw.Alignment.centerLeft,
                  headers: ['Product', 'Observed Qty'],
                  data: stockChecks.map((e) => [
                    e['productName'] ?? 'Unknown',
                    e['observedQty'].toString(),
                  ]).toList(),
                ),
                pw.SizedBox(height: 24),
              ],

              if (expenses.isNotEmpty) ...[
                pw.Text(AppStrings.expenses, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.TableHelper.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue600),
                  cellAlignment: pw.Alignment.centerLeft,
                  headers: ['Category', 'Amount', 'Description'],
                  data: expenses.map((e) => [
                    e.category.toString().toUpperCase(),
                    '\$${e.amount}',
                    e.description ?? '',
                  ]).toList(),
                ),
                pw.SizedBox(height: 24),
              ],

              if (photos.isNotEmpty) ...[
                pw.Text(AppStrings.shelfPhotos, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.Text('${photos.length} photo${photos.length == 1 ? '' : 's'} captured'),
                pw.SizedBox(height: 24),
              ],

              if (notes != null && notes.isNotEmpty) ...[
                pw.Text(AppStrings.notes, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Text(notes),
                ),
                pw.SizedBox(height: 24),
              ],

              if (signaturePath != null) ...[
                pw.Text(AppStrings.signature, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                pw.SizedBox(height: 8),
                pw.Container(
                  height: 100,
                  child: _safeSignatureImage(signaturePath),
                ),
              ],
            ];
          },
        ),
      );

      final bytes = await pdf.save();

      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/visit_report_${DateFormat('yyyyMMdd_HHmm').format(visitDate)}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (!await file.exists() || await file.length() == 0) {
        throw Exception('PDF file was not saved properly');
      }

      try {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'visit_report_${DateFormat('yyyyMMdd_HHmm').format(visitDate)}.pdf',
        );
      } catch (_) {
        debugPrint('Share sheet failed, PDF saved locally at: $filePath');
      }

      return filePath;
    } catch (e) {
      debugPrint('Error generating/sharing PDF: $e');
      rethrow;
    }
  }

  static pw.Widget _safeSignatureImage(String signaturePath) {
    try {
      final file = File(signaturePath);
      if (!file.existsSync()) return pw.Text(AppStrings.signatureFileNotFound);
      final bytes = file.readAsBytesSync();
      if (bytes.isEmpty) return pw.Text(AppStrings.signatureFileIsEmpty);
      return pw.Image(pw.MemoryImage(bytes));
    } catch (e) {
      return pw.Text(AppStrings.signatureError);
    }
  }
}
