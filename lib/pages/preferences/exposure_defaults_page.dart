import 'package:flutter/cupertino.dart';

class ExposureDefaultsPage extends StatelessWidget {
  const ExposureDefaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Exposure Defaults'),
      ),
      child: Center(
        child: Text('Exposure default settings go here.'),
      ),
    );
  }
}
