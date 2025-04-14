import 'package:flutter/cupertino.dart';

class DOFDefaultsPage extends StatelessWidget {
  const DOFDefaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('DOF Defaults'),
      ),
      child: Center(
        child: Text('DOF default settings go here.'),
      ),
    );
  }
}
