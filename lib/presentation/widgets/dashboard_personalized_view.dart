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
                                      // showPdfPreview(pdf);
                                    }
                                  : null,
                              child: Text(
                                'Download as PDF',
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

  Widget buildGraphView(BuildContext context) {
    final List<FlSpot> yearlySpots = [
      FlSpot(1, 39000000),
      FlSpot(2, 12000000),
      FlSpot(3, 45000000),
      FlSpot(4, 15000000),
      FlSpot(5, 38000000),
      FlSpot(6, 25000000),
      FlSpot(7, 23000000),
      FlSpot(8, 32000000),
      FlSpot(9, 30000000),
      FlSpot(10, 18000000),
      FlSpot(11, 27000000),
      FlSpot(12, 28000000),
    ];
    final List<BarChartGroupData> yearlyBarGroups = yearlySpots.map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y,
            color: Colors.indigoAccent,
            width: 8,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Graph View',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'January 1, 2025 - Today (August 8, 2025)',
              style: TextStyle(color: context.colors.secondary),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (groupData) {
                        return context.colors.inverseSurface;
                      },
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 16,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} MMK',
                          TextStyle(
                            color: context.colors.onInverseSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),

                  maxY: 50000000,
                  minY: 0,
                  barGroups: yearlyBarGroups,
                  gridData: FlGridData(
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 10000000,
                        getTitlesWidget: (value, meta) {
                          return Text('${value ~/ 100000}k');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPdfPreview(pw.Document pdf) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PDF Preview'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: PdfPreview(
            build: (format) => pdf.save(),
            allowPrinting: false,
            allowSharing: true,

            // Enable sharing
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
