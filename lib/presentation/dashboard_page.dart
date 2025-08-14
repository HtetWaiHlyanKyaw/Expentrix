import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/domain/entity/category.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:expentro_expense_tracker/presentation/cubits/dashboard/dashboard_overview/dashboard_overview_cubit.dart';
import 'package:expentro_expense_tracker/presentation/cubits/dashboard/dashboard_personalized_view/dashboard_personalized_view_cubit.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_menu_button.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_title.dart';
import 'package:expentro_expense_tracker/presentation/widgets/dashboard_overview.dart';
import 'package:expentro_expense_tracker/presentation/widgets/dashboard_personalized_view.dart';
import 'package:expentro_expense_tracker/presentation/widgets/dashboard_visualized_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubits/dashboard/dashboard_visualized_view/dashboard_visualized_view_cubit.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppTitle(title: 'Dashboard'),
          titleTextStyle: TextStyle(color: context.colors.onSurface),
          centerTitle: true,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Visualize'),
              Tab(text: 'Personalize'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            buildCardView(context),
            buildGraphView(context),
            buildPersonalizedView(context),
          ],
        ),
      ),
    );
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
    return BlocProvider(
      create: (context) => DashboardVisualizedViewCubit(),
      child: DashboardVisualizedView(),
    );
  }

  // Widget buildExpenseTable() {
  //   int count = 0;
  //
  //   final expenses = [
  //     Expense(
  //       title: 'breakfast',
  //       category: categories[0].name,
  //       date: DateTime.now(),
  //       price: 2000,
  //     ),
  //     Expense(
  //       title: 'bus',
  //       category: categories[3].name,
  //       date: DateTime.now(),
  //       price: 400,
  //     ),
  //     Expense(
  //       title: 'shirt',
  //       category: categories[1].name,
  //       date: DateTime.now(),
  //       price: 12000,
  //     ),
  //     Expense(
  //       title: 'donation',
  //       category: categories[7].name,
  //       date: DateTime.now(),
  //       price: 5000,
  //     ),
  //     Expense(
  //       title: 'medicine',
  //       category: categories[5].name,
  //       date: DateTime.now(),
  //       price: 800,
  //     ),
  //   ];
  //
  //   return Scrollbar(
  //     thickness: 3,
  //     radius: Radius.circular(5),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Padding(
  //         padding: const EdgeInsets.only(bottom: 8.0),
  //         child: DataTable(
  //           headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
  //           columns: const [
  //             DataColumn(label: Text('No.')),
  //             DataColumn(label: Text('Title')),
  //             DataColumn(label: Text('Category')),
  //             DataColumn(label: Text('Date')),
  //             DataColumn(label: Text('Price')),
  //             DataColumn(label: Text('Note')),
  //             DataColumn(label: Text('')),
  //           ],
  //           rows: expenses
  //               .map(
  //                 (expense) => DataRow(
  //                   cells: [
  //                     DataCell(Text((++count).toString())),
  //                     DataCell(Text(expense.title)),
  //                     DataCell(Text(expense.category)),
  //                     DataCell(
  //                       Text(DateFormat('MMMM d, yyyy').format(expense.date)),
  //                     ),
  //                     DataCell(Text('${expense.price.toStringAsFixed(0)} MMK')),
  //                     DataCell(Text(expense.note ?? '   -')),
  //                     DataCell(
  //                       IconButton(
  //                         icon: Icon(
  //                           Icons.delete_outline,
  //                           color: Colors.red[400],
  //                         ),
  //                         onPressed: () {},
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildPersonalizedView(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardPersonalizedViewCubit(),
      child: DashboardPersonalizedView(),
    );
  }

  Widget buildOverviewCard(String title, String subTitle, String total) {
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
              '$total MMK',
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

  Widget buildCardView(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardOverviewCubit(),
      child: DashboardOverview(),
    );
  }
}
