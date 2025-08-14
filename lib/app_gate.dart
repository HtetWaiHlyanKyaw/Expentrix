import 'package:expentro_expense_tracker/presentation/cubits/home/home_cubit.dart';
import 'package:expentro_expense_tracker/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => HomeCubit(), child: HomePage());
  }
}
