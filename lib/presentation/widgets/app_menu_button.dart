import 'package:flutter/material.dart';

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ),
    );
  }
}
