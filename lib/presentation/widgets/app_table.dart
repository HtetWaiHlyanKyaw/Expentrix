import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/presentation/cubits/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/constants/sizes.dart';
import '../../domain/entity/expense.dart';

class AppTable extends StatefulWidget {
  final List<Expense> expenses;
  final Function()? delete;
  const AppTable({super.key, required this.expenses, this.delete = null});

  @override
  State<AppTable> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable> {
  double? tableHeight;

  @override
  Widget build(BuildContext context) {
    int count = 0;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                          padding: const EdgeInsets.only(
                            top: Sizes.smallSpacing,
                          ),
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
                                  DataColumn(label: Text('')),
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
                                          DataCell(
                                            Text(expense.note ?? '   -'),
                                          ),
                                          DataCell(
                                            IconButton(
                                              onPressed: () {
                                                onPressed(
                                                  expense,
                                                  expense.date,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: context.colors.error,
                                              ),
                                            ),
                                          ),
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
      },
    );
  }

  Future<void> onPressed(Expense expense, DateTime date) async {
    await context.read<HomeCubit>().deleteExpense(expense, date);
  }
}
