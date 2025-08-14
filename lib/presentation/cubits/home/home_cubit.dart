import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expentro_expense_tracker/data/expense_repo_impl.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import '../../../service_locator.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ExpenseRepoImpl _repo = getIt<ExpenseRepoImpl>();
  HomeCubit() : super(HomeInitial());

  Future<void> loadExpenses() async {
    try {
      emit(HomeLoading());
      final results = await Future.wait([
        _repo.getAllExpenses(),
        _repo.getTotalExpense(),
      ]);
      emit(HomeSuccess(results[0] as List<Expense>, results[1] as double));
    } catch (e) {
      emit(HomeFail(e.toString()));
    }
  }

  Future<void> loadExpenseByDate(DateTime date) async {
    try {
      emit(HomeLoading());
      final results = await Future.wait([
        _repo.getExpenseByDate(date),
        _repo.getTotalExpenseByDate(date),
      ]);
      emit(HomeSuccess(results[0] as List<Expense>, results[1] as double));
    } catch (e) {
      emit(HomeFail(e.toString()));
    }
  }

  Future<void> addExpense(
    String title,
    String category,
    DateTime date,
    double price,
    String? note,
  ) async {
    try {
      print('here');
      emit(HomeLoading());
      final expense = Expense(
        title: title,
        category: category,
        date: date,
        price: price,
        note: note,
      );
      await _repo.addExpense(expense);
      final results = await Future.wait([
        _repo.getExpenseByDate(date),
        _repo.getTotalExpenseByDate(date),
      ]);
      emit(HomeSuccess(results[0] as List<Expense>, results[1] as double));
    } catch (e) {
      emit(HomeFail(e.toString()));
    }
  }

  Future<void> deleteExpense(Expense expense, DateTime date) async {
    try {
      emit(HomeLoading());
      await _repo.deleteExpense(expense);
      final results = await Future.wait([
        _repo.getExpenseByDate(date),
        _repo.getTotalExpenseByDate(date),
      ]);
      emit(HomeSuccess(results[0] as List<Expense>, results[1] as double));
    } catch (e) {
      emit(HomeFail(e.toString()));
    }
  }
}
