import 'package:flutter/cupertino.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preferences'),
      ),
      child: Center(child: Text('Preferences Page Placeholder')),
    );
  }
}
