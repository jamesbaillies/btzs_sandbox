import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/session.dart';


class MeteringPage extends StatelessWidget {
  final Session session;
  const MeteringPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Metering')),
      child: Center(child: Text('Metering Page')),
    );
  }
}
