import 'package:expentro_expense_tracker/domain/entity/category.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';

abstract class ExpenseRepo {
  //GET
  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getExpenseToday();
  Future<List<Expense>> getExpenseByDate(DateTime date);
  Future<List<Expense>> getExpenseByPeriod(DateTime start, DateTime end);
  Future<List<Expense>> getExpenseByCategory(Category category);
  Future<double> getTotalExpense();
  Future<double> getTotalExpenseToday();
  Future<double> getTotalExpenseByDate(DateTime date);
  Future<double> getTotalExpenseByPeriod(DateTime start, DateTime date);
  Future<List<Expense>> filterExpenses({
    Category? category,
    DateTime? start,
    DateTime? end,
    double? minAmount,
    double? maxAmount,
  });
  Future<DateTime?> getStartDate();
  Future<List<List<double>>> getMonthlyTotalExpense();

  //POST
  Future<void> addExpense(Expense expense);

  //DELETE
  Future<void> deleteExpense(Expense expense);
  Future<void> deleteExpenseById(int id);
  Future<void> deleteAllExpenses();
  Future<void> deleteExpensesByCategory(Category category);

  //PUT
  Future<void> updateExpenseByDate(Expense expense);
}
