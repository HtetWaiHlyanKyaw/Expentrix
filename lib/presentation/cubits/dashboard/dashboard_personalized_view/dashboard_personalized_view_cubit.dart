import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/expense_repo_impl.dart';
import '../../../../domain/entity/expense.dart';
import '../../../../service_locator.dart';

part 'dashboard_personalized_view_state.dart';

class DashboardPersonalizedViewCubit
    extends Cubit<DashboardPersonalizedViewState> {
  final ExpenseRepoImpl _repo = getIt<ExpenseRepoImpl>();
  DashboardPersonalizedViewCubit() : super(DashboardPersonalizedViewInitial());

  Future<void> loadExpenseByDate(DateTime date) async {
    try {
      emit(DashboardPersonalizedViewLoading());
      final results = await Future.wait([
        _repo.getExpenseByDate(date),
        _repo.getTotalExpenseByDate(date),
      ]);
      emit(
        DashboardPersonalizedViewSuccess(
          results[0] as List<Expense>,
          results[1] as double,
        ),
      );
    } catch (e) {
      emit(DashboardPersonalizedViewFail(e.toString()));
    }
  }

  Future<void> loadExpenseByPeriod(DateTime start, DateTime end) async {
    try {
      emit(DashboardPersonalizedViewLoading());
      final results = await Future.wait([
        _repo.getExpenseByPeriod(start, end),
        _repo.getTotalExpenseByPeriod(start, end),
      ]);
      emit(
        DashboardPersonalizedViewSuccess(
          results[0] as List<Expense>,
          results[1] as double,
        ),
      );
    } catch (e) {
      emit(DashboardPersonalizedViewFail(e.toString()));
    }
  }
}
