import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expentro_expense_tracker/data/expense_repo_impl.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:expentro_expense_tracker/domain/expense_repo.dart';

import '../../../../service_locator.dart';
part 'dashboard_overview_state.dart';

class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  final ExpenseRepo _repo = getIt<ExpenseRepo>();
  DashboardOverviewCubit() : super(DashboardOverviewInitial());

  Future<void> loadTotalExpenses() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisYearStartDate = DateTime(now.year, DateTime.january, 1);
    final thisYearEndDate = today;

    final thisMonthStartDate = DateTime(now.year, now.month, 1);
    final thisMonthEndDate = today;
    //
    // final thisWeekStartDate = now.subtract(Duration(days: now.weekday - 1));
    // final thisWeekEndDate = today;

    try {
      emit(DashboardOverviewLoading());
      final results = await Future.wait([
        ///ALLTIME
        _repo.getTotalExpense(),

        ///THIS YEAR
        _repo.getTotalExpenseByPeriod(thisYearStartDate, thisYearEndDate),

        ///THIS MONTH
        _repo.getTotalExpenseByPeriod(thisMonthStartDate, thisMonthEndDate),

        ///THIS WEEK
        // _repo.getTotalExpenseByPeriod(thisWeekStartDate, thisWeekEndDate),

        ///TODAY
        _repo.getTotalExpenseByDate(today),

        ///START DATE
        _repo.getStartDate(),
      ]);
      emit(
        DashboardOverviewSuccess(
          allTimeTotalExpenses: results[0] as double,
          thisYearTotalExpenses: results[1] as double,
          thisMonthTotalExpenses: results[2] as double,
          // thisWeekTotalExpenses: results[3],
          todayTotalExpenses: results[3] as double,
          startDate: results[4] as DateTime?,
        ),
      );
    } catch (e) {
      emit(DashboardOverviewFail(e.toString()));
    }
  }
}
