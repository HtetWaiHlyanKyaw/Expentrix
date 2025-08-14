import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/sizes.dart';
import '../../domain/entity/expense.dart';

class DashboardPersonalizedViewTable extends StatefulWidget {
  final List<Expense> expenses;
  const DashboardPersonalizedViewTable({super.key, required this.expenses});

  @override
  State<DashboardPersonalizedViewTable> createState() =>
      _DashboardPersonalizedViewTableState();
}

class _DashboardPersonalizedViewTableState
    extends State<DashboardPersonalizedViewTable> {
  double? tableHeight;

  @override
  Widget build(BuildContext context) {
    int count = 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Expense Records',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: Sizes.smallSpacing),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      tableHeight = (tableHeight == null) ? 0 : null;
                    });
                  },
                  child: Icon(
                    tableHeight == null
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),

            widget.expenses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: Sizes.smallSpacing),
                      child: Text(
                        'No expenses added yet.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: tableHeight,
                    child: Scrollbar(
                      thickness: 3,
                      radius: Radius.circular(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: DataTable(
                            headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            columns: const [
                              DataColumn(label: Text('No.')),
                              DataColumn(label: Text('Title')),
                              DataColumn(label: Text('Category')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Note')),
                            ],
                            rows: widget.expenses
                                .map(
                                  (expense) => DataRow(
                                    cells: [
                                      DataCell(Text((++count).toString())),
                                      DataCell(Text(expense.title)),

                                      DataCell(Text(expense.category)),
                                      DataCell(
                                        Text(
                                          DateFormat(
                                            'MMMM d, yyyy',
                                          ).format(expense.date),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${expense.price.toStringAsFixed(0)} MMK',
                                        ),
                                      ),
                                      DataCell(Text(expense.note ?? '   -')),
                                    ],
                                  ),
                                )
                                .toList(),
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
}
