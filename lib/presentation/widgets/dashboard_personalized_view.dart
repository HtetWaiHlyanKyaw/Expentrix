import 'package:expentro_expense_tracker/core/constants/sizes.dart';
import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/presentation/cubits/dashboard/dashboard_personalized_view/dashboard_personalized_view_cubit.dart';
import 'package:expentro_expense_tracker/presentation/widgets/dashboard_personalized_view_table.dart';
import 'package:expentro_expense_tracker/presentation/widgets/fail_page.dart';
import 'package:expentro_expense_tracker/presentation/widgets/loading_page.dart';
import 'package:expentro_expense_tracker/service/export_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/entity/expense.dart';

class DashboardPersonalizedView extends StatefulWidget {
  const DashboardPersonalizedView({super.key});

  @override
  State<DashboardPersonalizedView> createState() =>
      _DashboardPersonalizedViewState();
}

class _DashboardPersonalizedViewState extends State<DashboardPersonalizedView> {
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ),
  );

  @override
  void initState() {
    context.read<DashboardPersonalizedViewCubit>().loadExpenseByPeriod(
      selectedDateRange.start,
      selectedDateRange.end,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child:
          BlocBuilder<
            DashboardPersonalizedViewCubit,
            DashboardPersonalizedViewState
          >(
            builder: (context, state) {
              if (state is DashboardPersonalizedViewLoading) {
                return LoadingPage();
              }
              if (state is DashboardPersonalizedViewFail) {
                return FailPage(error: state.error);
              }
              if (state is DashboardPersonalizedViewSuccess) {
                final expenses = state.expenses;
                final prices = state.prices;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Expenses by Selected Period',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          onPressed: () => updateExpenseWithPeriod(context),
                          child: Text(
                            selectedDateRange.start == selectedDateRange.end
                                ? DateFormat(
                                    'MMMM d, yyyy',
                                  ).format(selectedDateRange.start)
                                : '${DateFormat('MMMM d, yyyy').format(selectedDateRange.start)} - ${DateFormat('MMMM d, yyyy').format(selectedDateRange.end)}',
                          ),
                        ),
                      ),

                      SizedBox(height: Sizes.smallSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              'Select a date range.',
                              style: TextStyle(
                                // fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                color: context.colors.secondary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: TextButton(
                              onPressed: expenses.isNotEmpty
                                  ? () async {
                                      final pdf = await ExportService.exportPDF(
                                        expenses: expenses,
                                        total: prices,
                                      );
                                      showPdfPreview(pdf);
                                    }
                                  : null,
                              child: Text(
                                'Export',
                                style: TextStyle(
                                  color: expenses.isNotEmpty
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Sizes.smallSpacing),

                      Card(
                        color: Colors.indigo,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Spending',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),

                              Text(
                                '${prices.toStringAsFixed(0)} MMK',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildExpenseTable(expenses),
                      SizedBox(height: Sizes.mediumSpacing),
                      // buildGraphView(context),
                      Center(
                        child: Text('Go to home page to manage expenses.'),
                      ),
                    ],
                    // ),
                  ),
                );
              }
              return Center(child: Text('Unknown State'));
            },
          ),
    );
  }

  Future<void> updateExpenseWithPeriod(BuildContext context) async {
    final DateTimeRange? result = await chooseDateRange(
      context,
      selectedDateRange,
    );
    if (result != null) {
      setState(() {
        selectedDateRange = result;
      });
      context.read<DashboardPersonalizedViewCubit>().loadExpenseByPeriod(
        selectedDateRange.start,
        selectedDateRange.end,
      );
    }
  }

  Widget buildExpenseTable(List<Expense> expenses) {
    return DashboardPersonalizedViewTable(expenses: expenses);
  }

  List<BarChartGroupData> barGroups(List<FlSpot> spots) {
    return spots.map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y,
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    }).toList();
  }

  void showPdfPreview(pw.Document pdf) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PDF Preview'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: PdfPreview(
            build: (format) => pdf.save(),
            canDebug: false,
            allowPrinting: false,
            allowSharing: true,
            canChangeOrientation: false,
            canChangePageFormat: false,

            // Enable sharing
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          FilledButton(
            onPressed: () async {
              final success = await ExportService.savePdfToDownloads(pdf);
              _onDownloadPressed(pdf, success);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Save PDF', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onDownloadPressed(pw.Document pdf, bool success) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'PDF saved successfully!' : 'Failed to save PDF',
        ),
      ),
    );
  }
}
