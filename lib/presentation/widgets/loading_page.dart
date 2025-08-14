import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            CircularProgressIndicator(color: Colors.indigo),
            SizedBox(height: 20),
            Text('please wait for a moment.'),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
