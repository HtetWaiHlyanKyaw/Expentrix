import 'package:flutter/material.dart';

class TotalSpendingCard extends StatelessWidget {
  final double prices;
  const TotalSpendingCard({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total spending', style: TextStyle(color: Colors.white)),
            SizedBox(height: 20),
            Text(
              '${prices.toStringAsFixed(0)} MMK',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
