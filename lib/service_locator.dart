import 'package:expentro_expense_tracker/data/database_helper.dart';
import 'package:expentro_expense_tracker/data/expense_repo_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerLazySingleton<ExpenseRepoImpl>(() => ExpenseRepoImpl());
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
