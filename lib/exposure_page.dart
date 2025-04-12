import 'package:flutter/cupertino.dart';
import 'session.dart';
import 'exposure_summary_page.dart'; // ✅ Correct file name

class ExposurePage extends StatelessWidget {
  final Session session;
  const ExposurePage({super.key, required this.session});

  void _cancel(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _done(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ExposureSummaryPage(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Exposure'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _cancel(context),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _done(context),
          child: const Text('Done'),
        ),
      ),
      child: const Center(child: Text('Exposure Page')),
    );
  }
}
