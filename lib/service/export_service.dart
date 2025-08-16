import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportService {
  ExportService._();
  static Future<pw.Document> exportPDF({
    required List<Expense> expenses,
    required double total,
  }) async {
    final pdf = pw.Document();
    final poppinsFont = await loadPoppinsFont();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Expense Report',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: poppinsFont, fontSize: 14),
              ),
              pw.Text(
                'EXPENTRIX',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: poppinsFont,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Htet Wai Hlyan Kyaw',
            style: pw.TextStyle(font: poppinsFont, fontSize: 12),
          ),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${DateFormat('MMMM d, yy').format(DateTime.now())}',
                style: pw.TextStyle(
                  font: poppinsFont,
                  fontSize: 12,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(
                'Total: ${total.toStringAsFixed(0)} MMK',
                style: pw.TextStyle(
                  font: poppinsFont,
                  fontSize: 12,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // Table as list
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Title', 'Category', 'Amount', 'Note'],
            data: expenses
                .map(
                  (e) => [
                    DateFormat('MMMM d, yy').format(e.date).toString(),
                    e.title.toString(),
                    e.category.toString(),
                    e.price.toStringAsFixed(0),
                    e.note == null ? '' : e.note.toString(),
                  ],
                )
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(
              font: poppinsFont,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              // color: PdfColors.orange900,
            ),
            cellStyle: pw.TextStyle(
              font: poppinsFont,
              fontSize: 12,
              // color: PdfColors.grey800,
            ),
            headerDecoration: const pw.BoxDecoration(
              // color: PdfColors.orange100,
            ),
            cellAlignment: pw.Alignment.centerLeft,
            // cellHeight: 25,
          ),
        ],
      ),
    );
    return pdf;
  }

  static Future<bool> savePdfToDownloads(pw.Document pdf) async {
    try {
      Directory? downloadsDir;

      if (Platform.isAndroid) {
        if (await Permission.storage.request().isDenied) {
          debugPrint("Storage permission denied");
          return false;
        }
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${downloadsDir!.path}/expenses_$timestamp.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      await MediaScanner.loadMedia(path: filePath);
      debugPrint('Saved to: $filePath');
      return true;
    } catch (e) {
      debugPrint('Failed at savePdfToDownload $e');
      throw Exception('Failed to export PDF. $e');
    }
  }

  static Future<pw.Font> loadPoppinsFont() async {
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    return pw.Font.ttf(fontData);
  }
}
