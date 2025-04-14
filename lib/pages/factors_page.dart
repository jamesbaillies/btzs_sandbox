import 'package:flutter/cupertino.dart';
import '../utils/session.dart';

class FactorsPage extends StatelessWidget {
  final Session session;
  const FactorsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Factors')),
      child: Center(child: Text('Factors Page')),
    );
  }
}
