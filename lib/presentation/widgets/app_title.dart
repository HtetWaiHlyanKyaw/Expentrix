import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const AppTitle({super.key, this.title = 'EXPENTRIX', this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return
    //   Text(
    //   title,
    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    // );
    Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'EXPEN',
            style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          TextSpan(
            text: 'TRIX',
            style: TextStyle(
              color: Colors.indigoAccent,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
