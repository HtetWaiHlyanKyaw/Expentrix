import 'package:expentro_expense_tracker/domain/entity/category.dart';
import 'package:expentro_expense_tracker/presentation/cubits/home/home_cubit.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_drawer.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_menu_button.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_table.dart';
import 'package:expentro_expense_tracker/presentation/widgets/app_title.dart';
import 'package:expentro_expense_tracker/presentation/widgets/date_button.dart';
import 'package:expentro_expense_tracker/presentation/widgets/fail_page.dart';
import 'package:expentro_expense_tracker/presentation/widgets/loading_page.dart';
import 'package:expentro_expense_tracker/presentation/widgets/total_spending_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expentro_expense_tracker/core/constants/sizes.dart';

import '../core/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  String? selectedCategory;

  @override
  void initState() {
    context.read<HomeCubit>().loadExpenseByDate(selectedDate);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: AppTitle(),
          ),

          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(color: context.colors.onSurface),
          // centerTitle: true,
          actions: [AppMenuButton()],
        ),
        endDrawer: AppDrawer(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return LoadingPage();
            } else if (state is HomeFail) {
              return FailPage(error: state.error);
            }
            if (state is HomeSuccess) {
              final expenses = state.expenses;
              final prices = state.prices;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DateButton(
                                date: selectedDate,
                                onPressed: updateExpenseWithDate,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  selectedDate ==
                                      DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                      )
                                  ? Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      'Past Date',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepOrangeAccent,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Sizes.smallSpacing),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Select a date to manage your expenses.',
                          style: TextStyle(
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: context.colors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: Sizes.mediumSpacing),

                      ///TOTAL SPENDING
                      TotalSpendingCard(prices: prices),
                      // const SizedBox(height: Sizes.smallSpacing),

                      ///ADD FORM
                      buildAddExpenseForm(context),
                      // const SizedBox(height: Sizes.smallSpacing),

                      ///TABLE
                      AppTable(expenses: expenses),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Card buildAddExpenseForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              'Enter the details of your expense below.',
              style: TextStyle(color: context.colors.secondary),
            ),
            const SizedBox(height: Sizes.mediumSpacing),

            buildTextField(controller: titleController, hint: 'Title'),
            const SizedBox(height: Sizes.smallSpacing),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Category',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              value: selectedCategory,
              items: categories.map((item) {
                return DropdownMenuItem<String>(
                  value: item.name,
                  child: Row(
                    children: [
                      Icon(item.icon),
                      SizedBox(width: 8),
                      Text(item.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedCategory = value;
                  }
                });
              },
            ),
            const SizedBox(height: Sizes.smallSpacing),
            buildTextField(
              controller: priceController,
              hint: 'Price',
              keyboardType: TextInputType.numberWithOptions(),
            ),
            const SizedBox(height: Sizes.smallSpacing),
            buildNoteField(),
            const SizedBox(height: Sizes.smallSpacing),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: addExpense,
                style: FilledButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        counterText: '',
        border: InputBorder.none,
      ),
      keyboardType: keyboardType,
      maxLength: 30,
    );
  }

  Widget buildNoteField() {
    return TextField(
      maxLength: 50,
      controller: noteController,
      decoration: InputDecoration(
        hintText: 'Note (optional)',
        filled: true,
        border: InputBorder.none,
        counterText: '',
      ),
      maxLines: 3,
    );
  }

  Future<void> updateExpenseWithDate() async {
    final picked = await chooseDate(context);
    if (picked != null) {
      selectedDate = DateTime(picked.year, picked.month, picked.day);
      context.read<HomeCubit>().loadExpenseByDate(selectedDate);
    }
  }

  List<DropdownMenuItem> buildCategoryButtons() {
    return List.generate(
      categories.length,
      (index) => DropdownMenuItem(
        value: categories[index].name,
        child: Text(categories[index].name),
      ),
    );
  }

  void addExpense() {
    FocusScope.of(context).unfocus();
    if (validate()) {
      context.read<HomeCubit>().addExpense(
        titleController.text.trim(),
        selectedCategory!,
        selectedDate,
        double.parse(priceController.text.trim()),
        noteController.text.isEmpty ? null : noteController.text,
      );
      clearControllers();
    }
  }

  bool validate() {
    return titleController.text.isNotEmpty &&
        selectedCategory != null &&
        priceController.text.isNotEmpty &&
        !priceController.text.contains('-') &&
        !priceController.text.contains(' ') &&
        !priceController.text.contains('.') &&
        !priceController.text.contains(',');
  }

  void clearControllers() {
    titleController.clear();
    priceController.clear();
    noteController.clear();
    setState(() {
      selectedCategory = null;
    });
  }
}
