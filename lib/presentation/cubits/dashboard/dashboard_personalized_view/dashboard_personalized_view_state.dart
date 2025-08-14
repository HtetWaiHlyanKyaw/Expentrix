part of 'dashboard_personalized_view_cubit.dart';

sealed class DashboardPersonalizedViewState extends Equatable {
  const DashboardPersonalizedViewState();
}

final class DashboardPersonalizedViewInitial
    extends DashboardPersonalizedViewState {
  @override
  List<Object> get props => [];
}

final class DashboardPersonalizedViewLoading
    extends DashboardPersonalizedViewState {
  @override
  List<Object?> get props => [];
}

final class DashboardPersonalizedViewSuccess
    extends DashboardPersonalizedViewState {
  final List<Expense> expenses;
  final double prices;
  const DashboardPersonalizedViewSuccess(this.expenses, this.prices);
  @override
  List<Object?> get props => [expenses, prices];
}

final class DashboardPersonalizedViewFail
    extends DashboardPersonalizedViewState {
  final String error;
  const DashboardPersonalizedViewFail(this.error);
  @override
  List<Object?> get props => [error];
}
