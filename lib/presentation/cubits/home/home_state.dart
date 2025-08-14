part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeSuccess extends HomeState {
  final List<Expense> expenses;
  final double prices;
  const HomeSuccess(this.expenses, this.prices);
  @override
  List<Object?> get props => [expenses, prices];
}

final class HomeFail extends HomeState {
  final String error;
  const HomeFail(this.error);
  @override
  List<Object?> get props => [error];
}

//
// final class HomeTotalSuccess extends HomeState {
//   final double prices;
//   const HomeTotalSuccess(this.prices);
//   @override
//   List<Object?> get props => [prices];
// }
