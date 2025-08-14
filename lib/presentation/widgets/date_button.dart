import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  final DateTime date;
  final Function() onPressed;
  const DateButton({super.key, required this.date, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(DateFormat('MMMM d, yyyy').format(date)),
    );
  }
}
