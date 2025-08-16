import 'package:expentro_expense_tracker/core/utils/utils.dart';
import 'package:expentro_expense_tracker/data/database_helper.dart';
import 'package:expentro_expense_tracker/domain/entity/category.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:expentro_expense_tracker/domain/expense_repo.dart';
import 'package:expentro_expense_tracker/service_locator.dart';
import 'package:flutter/cupertino.dart';

class ExpenseRepoImpl extends ExpenseRepo {
  // List<Expense> expenses = [];
  final DatabaseHelper _dbHelper = getIt<DatabaseHelper>();

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('expenses', expense.toJson());
    } catch (e) {
      debugPrint('Failed to add expense: ${e.toString}');
      throw Exception(e);
    }
  }

  //SLOW
  // @override
  // Future<List<List<double>>> getMonthlyTotalExpense() async {
  //   final now = DateTime.now();
  //   final year = now.year;
  //
  //   List<double> totals = [];
  //
  //   try {
  //     for (var month = 1; month <= 12; month++) {
  //       final totalDays = daysInMonth(year, month);
  //
  //       double monthlyTotal = 0.0;
  //
  //       for (var day = 1; day <= totalDays; day++) {
  //         monthlyTotal += await getTotalExpenseByDate(
  //           DateTime(year, month, day),
  //         );
  //       }
  //
  //       totals.add(monthlyTotal);
  //     }
  //
  //     final max = totals.reduce((a, b) => a > b ? a : b);
  //     return [
  //       totals,
  //       [max],
  //     ];
  //   } catch (e) {
  //     debugPrint('Failed to get monthly totals: ${e.toString()}');
  //     throw Exception(e);
  //   }
  // }

  @override
  Future<List<List<double>>> getMonthlyTotalExpense() async {
    try {
      final db = await _dbHelper.database;

      final now = DateTime.now();
      final startDate = DateTime(now.year, 1, 1);
      final endDate = DateTime(now.year + 1, 1, 1);

      final result = await db.rawQuery(
        '''
      SELECT strftime('%m', date) as month,
             SUM(price) as total
      FROM expenses
      WHERE date >= ? AND date < ?
      GROUP BY month
      ORDER BY month
      ''',
        [startDate.toIso8601String(), endDate.toIso8601String()],
      );

      List<double> totals = List.filled(12, 0.0);

      for (var row in result) {
        int month = int.parse(row['month'] as String);
        double total = (row['total'] as num).toDouble();
        totals[month - 1] = total;
      }

      final max = totals.reduce((a, b) => a > b ? a : b);

      return [
        totals,
        [max],
      ];
    } catch (e) {
      debugPrint('Failed to fetch monthly total expenses $e');
      throw Exception(e);
    }
  }

  //SLOW
  // @override
  // Future<List<List<double>>> getDailyTotalExpense() async {
  //   final now = DateTime.now();
  //   final year = now.year;
  //   final month = now.month;
  //   final totalDays = daysInMonth(year, month);
  //   List<double> totals = [];
  //   try {
  //     for (var day = 1; day <= totalDays; day++) {
  //       totals.add(await getTotalExpenseByDate(DateTime(year, month, day)));
  //     }
  //     final max = totals.reduce((a, b) => a > b ? a : b);
  //     return [
  //       totals,
  //       [max],
  //     ];
  //   } catch (e) {
  //     debugPrint('Failed to get daily totals: ${e.toString}');
  //     throw Exception(e);
  //   }
  // }

  @override
  Future<List<List<double>>> getDailyTotalExpense() async {
    try {
      final db = await _dbHelper.database;

      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 1);

      final totalDays = daysInMonth(now.year, now.month);

      final result = await db.rawQuery(
        '''
      SELECT strftime('%d', date) as day,
             SUM(price) as total
      FROM expenses
      WHERE date >= ? AND date < ?
      GROUP BY day
      ORDER BY day
      ''',
        [startDate.toIso8601String(), endDate.toIso8601String()],
      );

      List<double> totals = List.filled(totalDays, 0.0);

      for (var row in result) {
        int day = int.parse(row['day'] as String);
        double total = (row['total'] as num).toDouble();
        totals[day - 1] = total;
      }

      final max = totals.reduce((a, b) => a > b ? a : b);

      return [
        totals,
        [max],
      ];
    } catch (e) {
      debugPrint('Failed to fetch daily total expenses $e');
      throw Exception(e);
    }
  }

  @override
  Future<DateTime?> getStartDate() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'expenses',
        columns: ['date'],
        orderBy: 'date ASC',
        limit: 1,
      );
      if (result.isEmpty) {
        return null;
      }
      return DateTime.parse(result.first['date'] as String);
    } catch (e) {
      debugPrint('Failed to get start date: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteAllExpenses() {
    // TODO: implement deleteAllExpenses
    throw UnimplementedError();
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('expenses', where: 'id = ?', whereArgs: [expense.id]);
    } catch (e) {
      debugPrint('Failed to get all expenses: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteExpenseById(int id) {
    // TODO: implement deleteExpenseById
    throw UnimplementedError();
  }

  @override
  Future<void> deleteExpensesByCategory(Category category) {
    // TODO: implement deleteExpensesByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> filterExpenses({
    Category? category,
    DateTime? start,
    DateTime? end,
    double? minAmount,
    double? maxAmount,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query('expenses');
      return results.map(Expense.fromJson).toList();
    } catch (e) {
      debugPrint('Failed to get all expenses: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<List<Expense>> getExpenseByCategory(Category category) {
    // TODO: implement getExpenseByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getExpenseByDate(DateTime date) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        'expenses',
        where: 'date == ?',
        whereArgs: [date.toIso8601String()],
      );
      return results.map(Expense.fromJson).toList();
    } catch (e) {
      debugPrint('Failed to get expenses by date: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<List<Expense>> getExpenseByPeriod(DateTime start, DateTime end) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        'expenses',
        where: 'date >= ? AND date <= ?',
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
      );
      return results.map(Expense.fromJson).toList();
    } catch (e) {
      debugPrint('Failed to get expenses by date: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<List<Expense>> getExpenseToday() {
    // TODO: implement getExpenseToday
    throw UnimplementedError();
  }

  @override
  Future<double> getTotalExpenseByDate(DateTime date) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT SUM(price) as total FROM expenses WHERE date = ?',
        [date.toIso8601String()],
      );
      double total = result.first['total'] as double? ?? 0.0;
      return total;
    } catch (e) {
      debugPrint('Failed to get total expenses: ${e.toString}');
      throw Exception(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<double> getTotalExpense() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT SUM(price) as total FROM expenses',
      );
      double total = result.first['total'] as double? ?? 0.0;
      return total;
    } catch (e) {
      debugPrint('Failed to get total expenses: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<double> getTotalExpenseByPeriod(DateTime start, DateTime end) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT SUM(price) as total FROM expenses WHERE date >= ? AND date <= ?',
        [start.toIso8601String(), end.toIso8601String()],
      );
      double total = result.first['total'] as double? ?? 0.0;
      return total;
    } catch (e) {
      debugPrint('Failed to get total expenses: ${e.toString}');
      throw Exception(e);
    }
  }

  @override
  Future<double> getTotalExpenseToday() {
    // TODO: implement getTotalExpenseToday
    throw UnimplementedError();
  }

  @override
  Future<void> updateExpenseByDate(Expense expense) {
    // TODO: implement updateExpenseByDate
    throw UnimplementedError();
  }
}
