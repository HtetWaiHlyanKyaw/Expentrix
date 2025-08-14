import 'package:expentro_expense_tracker/core/constants/sizes.dart';
import 'package:expentro_expense_tracker/presentation/dashboard_page.dart';
import 'package:expentro_expense_tracker/presentation/home_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.smallSpacing,
                  ),
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: Sizes.largeSpacing),
              Divider(),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Dashboard'),
                      leading: Icon(Icons.folder_copy_outlined),
                      onTap: () {
                        navigate(context, DashboardPage());
                      },
                    ),
                  ],
                ),
              ),

              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: Sizes.smallSpacing),
              Text(
                'All rights preserved.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                '© 2025 Htet Wai Hlyan Kyaw.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: () {}, child: Text('Privacy Policy')),
                  TextButton(onPressed: () {}, child: Text('Terms of Service')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
