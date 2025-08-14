part of 'dashboard_overview_cubit.dart';

sealed class DashboardOverviewState extends Equatable {
  const DashboardOverviewState();
}

final class DashboardOverviewInitial extends DashboardOverviewState {
  @override
  List<Object> get props => [];
}

final class DashboardOverviewLoading extends DashboardOverviewState {
  @override
  List<Object?> get props => [];
}

final class DashboardOverviewSuccess extends DashboardOverviewState {
  final double allTimeTotalExpenses;
  final double thisYearTotalExpenses;
  final double thisMonthTotalExpenses;
  final DateTime? startDate;
  // final double thisWeekTotalExpenses;
  final double todayTotalExpenses;
  const DashboardOverviewSuccess({
    required this.allTimeTotalExpenses,
    required this.thisMonthTotalExpenses,
    required this.thisYearTotalExpenses,
    // required this.thisWeekTotalExpenses,
    required this.todayTotalExpenses,
    required this.startDate,
  });
  @override
  List<Object?> get props => [
    allTimeTotalExpenses,
    thisYearTotalExpenses,
    thisMonthTotalExpenses,
    // thisWeekTotalExpenses,
    todayTotalExpenses,
  ];
}

final class DashboardOverviewFail extends DashboardOverviewState {
  final String error;
  const DashboardOverviewFail(this.error);
  @override
  List<Object?> get props => [error];
}
