import 'package:expentro_expense_tracker/app_gate.dart';
import 'package:expentro_expense_tracker/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.orange,
        fontFamily: 'Poppins',
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),

      home: const AppGate(),
    );
  }
}
