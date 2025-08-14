import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/presentation/cubits/dashboard/dashboard_visualized_view/dashboard_visualized_view_cubit.dart';
import 'package:expentro_expense_tracker/presentation/widgets/fail_page.dart';
import 'package:expentro_expense_tracker/presentation/widgets/loading_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/expense.dart';

class DashboardVisualizedView extends StatefulWidget {
  const DashboardVisualizedView({super.key});

  @override
  State<DashboardVisualizedView> createState() =>
      _DashboardVisualizedViewState();
}

class _DashboardVisualizedViewState extends State<DashboardVisualizedView> {
  @override
  void initState() {
    // context.read<DashboardVisualizedViewCubit>().loadThisYearExpense();
    context.read<DashboardVisualizedViewCubit>().loadThisMonthExpense();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      DashboardVisualizedViewCubit,
      DashboardVisualizedViewState
    >(
      builder: (context, state) {
        if (state is DashboardVisualizedViewLoading) {
          return LoadingPage();
        } else if (state is DashboardVisualizedViewFail) {
          return FailPage(error: state.error);
        } else if (state is DashboardVisualizedViewSuccess) {
          // final expenses = state.expenses;
          // final prices = state.total;
          final prices = state.totals.first;
          final max = state.totals.last;

          final dailyPrices = state.dailyTotals.first;
          final dailyMax = state.dailyTotals.last;
          if (max.first == 0 || dailyMax.first == 0) {
            return Center(child: Text('No expenses available'));
          } else {
            return buildGraphView(
              context,
              prices,
              max.first,
              dailyPrices,
              dailyMax.first,
            );
          }
        }
        return Center(child: Text('Unknown state'));
      },
    );
  }
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

Widget buildGraphView(
  BuildContext context,
  List<double> prices,
  double max,
  List<double> dailyPrices,
  double dailyMax,
) {
  final List<FlSpot> yearlySpots = List.generate(
    prices.length,
    (index) => FlSpot(index + 1, prices[index]),
  );

  final List<FlSpot> monthlySpots = List.generate(
    dailyPrices.length,
    (index) => FlSpot(index + 1, dailyPrices[index]),
  );
  final List<BarChartGroupData> yearlyBarGroups = yearlySpots.map((spot) {
    return BarChartGroupData(
      x: spot.x.toInt(),
      barRods: [
        BarChartRodData(
          toY: spot.y,
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }).toList();
  final List<BarChartGroupData> monthlyBarGroups = monthlySpots.map((spot) {
    return BarChartGroupData(
      x: spot.x.toInt(),
      barRods: [
        BarChartRodData(
          toY: spot.y,
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }).toList();
  final now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime thisMonthStartDate = DateTime(now.year, now.month, 1);
  final DateTime thisYearStartDate = DateTime(now.year, DateTime.january, 1);
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Expenses by Periods',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('This year', style: TextStyle(color: Colors.orange)),
          SizedBox(height: 10),
          Text(
            '${DateFormat('MMMM d, yy').format(thisYearStartDate)} - ${DateFormat('MMMM d, yy').format(today)} (Today)',
            style: TextStyle(color: context.colors.secondary),
          ),
          SizedBox(height: 20),
          buildBarChart(
            context,
            max,
            yearlyBarGroups,
            'Months of a Year',
            false,
          ),
          SizedBox(height: 20),

          Text('This Month', style: TextStyle(color: Colors.orange)),
          SizedBox(height: 10),
          Text(
            '${DateFormat('MMMM d, yy').format(thisMonthStartDate)} - ${DateFormat('MMMM d, yy').format(today)} (Today)',
            style: TextStyle(color: context.colors.secondary),
          ),
          SizedBox(height: 20),
          // SizedBox(
          //   height: 200,
          //   child: BarChart(
          //     BarChartData(
          //       barTouchData: BarTouchData(
          //         enabled: true,
          //         touchTooltipData: BarTouchTooltipData(
          //           getTooltipColor: (_) {
          //             return context.colors.inverseSurface;
          //           },
          //           tooltipPadding: const EdgeInsets.all(8),
          //           tooltipMargin: 16,
          //           getTooltipItem: (group, groupIndex, rod, rodIndex) {
          //             return BarTooltipItem(
          //               '${rod.toY.toInt()} MMK',
          //               TextStyle(
          //                 color: context.colors.onInverseSurface,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //
          //       maxY: dailyMax,
          //       minY: 0,
          //       barGroups: monthlyBarGroups,
          //       gridData: FlGridData(
          //         drawHorizontalLine: true,
          //         drawVerticalLine: false,
          //       ),
          //       borderData: FlBorderData(show: false),
          //       titlesData: FlTitlesData(
          //         bottomTitles: AxisTitles(
          //           sideTitles: SideTitles(
          //             showTitles: true,
          //             interval: 1,
          //             getTitlesWidget: (value, meta) {
          //               if (value % 2 == 0) {
          //                 return Text(
          //                   '${value.toInt()}',
          //                   style: TextStyle(fontSize: 12),
          //                 );
          //               }
          //               return SizedBox();
          //             },
          //           ),
          //           axisNameWidget: Text(
          //             'Days of a Month',
          //             style: TextStyle(color: context.colors.secondary),
          //           ),
          //         ),
          //
          //         leftTitles: AxisTitles(
          //           sideTitles: SideTitles(
          //             showTitles: true,
          //             reservedSize: 40,
          //             interval: max / 5,
          //             getTitlesWidget: (value, meta) {
          //               return Text(formatAmount(value));
          //             },
          //           ),
          //         ),
          //         topTitles: AxisTitles(
          //           sideTitles: SideTitles(showTitles: false),
          //         ),
          //         rightTitles: AxisTitles(
          //           sideTitles: SideTitles(showTitles: false),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          buildBarChart(
            context,
            dailyMax,
            monthlyBarGroups,
            'Days of a Month',
            true,
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}

SizedBox buildBarChart(
  BuildContext context,
  double max,
  List<BarChartGroupData> barGroups,
  String xLabel,
  bool isMonthly,
) {
  return SizedBox(
    height: 200,
    child: BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) {
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

        maxY: max,
        minY: 0,
        barGroups: barGroups,
        gridData: FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return isMonthly
                    ? value % 2 == 0
                          ? Text(
                              '${value.toInt()}',
                              style: TextStyle(fontSize: 12),
                            )
                          : SizedBox()
                    : Text('${value.toInt()}', style: TextStyle(fontSize: 12));
              },
            ),
            axisNameWidget: Text(
              xLabel,
              style: TextStyle(color: context.colors.secondary),
            ),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: max / 5,
              getTitlesWidget: (value, meta) {
                return Text(formatAmount(value));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    ),
  );
}
