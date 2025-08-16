import 'package:expentro_expense_tracker/data/database_helper.dart';
import 'package:expentro_expense_tracker/data/expense_repo_impl.dart';
import 'package:expentro_expense_tracker/domain/expense_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerLazySingleton<ExpenseRepo>(() => ExpenseRepoImpl());
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
