import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/session.dart';


class DOFPage extends StatelessWidget {
  final Session session;
  const DOFPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Depth of Field')),
      child: Center(child: Text('DOF Page')),
    );
  }
}
