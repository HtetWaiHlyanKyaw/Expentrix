import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/presentation/cubits/dashboard/dashboard_overview/dashboard_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubits/dashboard/dashboard_personalized_view/dashboard_personalized_view_cubit.dart';
import 'fail_page.dart';
import 'loading_page.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  @override
  void initState() {
    context.read<DashboardOverviewCubit>().loadTotalExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisYearStartDate = DateTime(now.year, DateTime.january, 1);
    final thisYearEndDate = today;

    final thisMonthStartDate = DateTime(now.year, now.month, 1);
    final thisMonthEndDate = today;

    final thisWeekEndDate = today;
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      builder: (context, state) {
        if (state is DashboardOverviewLoading) {
          return LoadingPage();
        }
        if (state is DashboardOverviewFail) {
          return FailPage(error: state.error);
        }

        if (state is DashboardOverviewSuccess) {
          final double allTimeTotalExpenses = state.allTimeTotalExpenses;
          final double thisYearTotalExpenses = state.thisYearTotalExpenses;
          final double thisMonthTotalExpenses = state.thisMonthTotalExpenses;
          // final double thisWeekTotalExpenses = state.thisWeekTotalExpenses;
          final double todayTotalExpenses = state.todayTotalExpenses;
          final DateTime? startDate = state.startDate;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Expenses by Periods',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  buildOverviewCard(
                    'All Time',
                    startDate == null
                        ? 'Start - ${DateFormat('MMMM d, yy').format(today)} (Today)'
                        : '${DateFormat('MMMM d, yy').format(startDate)} - ${DateFormat('MMMM d, yy').format(today)} (Today)',
                    allTimeTotalExpenses,
                  ),
                  SizedBox(height: 10),
                  buildOverviewCard(
                    'This Year',
                    '${DateFormat('MMMM d, yy').format(thisYearStartDate)} - ${DateFormat('MMMM d, yy').format(thisYearEndDate)} (Today)',
                    thisYearTotalExpenses,
                  ),
                  SizedBox(height: 10),
                  buildOverviewCard(
                    'This Month',
                    '${DateFormat('MMMM d, yy').format(thisMonthStartDate)} - ${DateFormat('MMMM d, yy').format(thisMonthEndDate)} (Today)',
                    thisMonthTotalExpenses,
                  ),
                  SizedBox(height: 10),
                  buildOverviewCard(
                    'Today',
                    DateFormat('MMMM d, yy').format(today),
                    todayTotalExpenses,
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: Text('Unknown State'));
      },
    );
  }

  Widget buildOverviewCard(String title, String subTitle, double total) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.orange)),
            SizedBox(height: 10),
            Text(subTitle, style: TextStyle(color: context.colors.secondary)),
            SizedBox(height: 20),
            Text(
              '${total.toStringAsFixed(0)} MMK',
              style: TextStyle(
                fontSize: 24,
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
