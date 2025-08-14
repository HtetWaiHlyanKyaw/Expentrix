part of 'dashboard_visualized_view_cubit.dart';

sealed class DashboardVisualizedViewState extends Equatable {
  const DashboardVisualizedViewState();
}

final class DashboardVisualizedViewInitial
    extends DashboardVisualizedViewState {
  @override
  List<Object> get props => [];
}

final class DashboardVisualizedViewLoading
    extends DashboardVisualizedViewState {
  @override
  List<Object?> get props => [];
}

final class DashboardVisualizedViewSuccess
    extends DashboardVisualizedViewState {
  final List<List<double>> totals;
  final List<List<double>> dailyTotals;

  const DashboardVisualizedViewSuccess(this.totals, this.dailyTotals);
  @override
  List<Object?> get props => [totals, dailyTotals];
}

final class DashboardVisualizedViewFail extends DashboardVisualizedViewState {
  final String error;
  const DashboardVisualizedViewFail(this.error);
  @override
  List<Object?> get props => [error];
}
