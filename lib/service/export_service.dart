import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

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
    await _savePdfToDownloads(pdf);
    return pdf;
  }

  static Future<void> _savePdfToDownloads(pw.Document pdf) async {
    Directory? downloadsDir;
    // final fileName = DateTime.now().toString();
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // iOS does not have a traditional "Downloads" folder — you'll usually need to share it instead
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${downloadsDir!.path}/expenses.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    print('Saved to: $filePath');
  }

  static Future<pw.Font> loadPoppinsFont() async {
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    return pw.Font.ttf(fontData);
  }
}
