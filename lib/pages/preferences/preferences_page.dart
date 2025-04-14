// lib/pages/preferences/preferences_page.dart

import 'package:flutter/cupertino.dart';
import 'defaults_page.dart';
import 'sub_preferences_page.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildTitle('Units'),
            _buildNavTile(context, 'Measurement Units', 'Metric'),
            _buildNavTile(context, 'EV Metering Steps', '1/10 EV'),

            const SizedBox(height: 16),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const SubPreferencesPage(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('More Preferences'),
                  Icon(CupertinoIcons.right_chevron),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildTitle('Defaults'),
            _buildNavTile(context, 'Camera', '', onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const DefaultsPage(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(title,
          style: const TextStyle(fontSize: 13, color: CupertinoColors.inactiveGray)),
    );
  }

  Widget _buildNavTile(BuildContext context, String label, String value,
      {VoidCallback? onTap}) {
    return CupertinoListTile(
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(color: CupertinoColors.systemGrey)),
      onTap: onTap,
    );
  }
}
