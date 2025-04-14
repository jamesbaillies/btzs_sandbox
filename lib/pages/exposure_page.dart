import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/session.dart';
import 'exposure_summary_page.dart'; // ✅ Correct if in the same folder



class ExposurePage extends StatelessWidget {
  final Session session;

  const ExposurePage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exposure'),
      ),
      child: Center(
        child: Text('Exposure Settings Coming Soon'),
      ),
    );
  }
}
