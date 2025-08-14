import 'package:flutter/material.dart';

class FailPage extends StatelessWidget {
  final String error;
  const FailPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(error)));
  }
}
