import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expentro_expense_tracker/domain/entity/expense.dart';
import 'package:expentro_expense_tracker/domain/expense_repo.dart';
import 'package:expentro_expense_tracker/presentation/widgets/dashboard_visualized_view.dart';

import '../../../../data/expense_repo_impl.dart';
import '../../../../service_locator.dart';

part 'dashboard_visualized_view_state.dart';

class DashboardVisualizedViewCubit extends Cubit<DashboardVisualizedViewState> {
  final ExpenseRepo _repo = getIt<ExpenseRepo>();
  DashboardVisualizedViewCubit() : super(DashboardVisualizedViewInitial());

  // Future<void> loadThisYearExpense() async {
  //   try {
  //     emit(DashboardVisualizedViewLoading());
  //     final results = await Future.wait([_repo.getMonthlyTotalExpense()]);
  //     emit(DashboardVisualizedViewSuccess(results[0]));
  //   } catch (e) {
  //     emit(DashboardVisualizedViewFail(e.toString()));
  //   }
  // }

  Future<void> loadThisMonthExpense() async {
    try {
      emit(DashboardVisualizedViewLoading());
      final results = await Future.wait([
        _repo.getMonthlyTotalExpense(),
        _repo.getDailyTotalExpense(),
      ]);
      emit(DashboardVisualizedViewSuccess(results[0], results[1]));
    } catch (e) {
      emit(DashboardVisualizedViewFail(e.toString()));
    }
  }
}
