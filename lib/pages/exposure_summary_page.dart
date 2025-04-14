import 'package:flutter/cupertino.dart';
import '../utils/session.dart'; // <-- Make sure path is correct
import 'package:intl/intl.dart';


class ExposureSummaryPage extends StatelessWidget {
  final Session session;

  const ExposureSummaryPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Summary'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Summary',
              style: textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTile('Title', session.exposureTitle),
            _buildTile('Holder', session.filmHolder),
            _buildTile('Film Stock', session.filmStock),
            _buildTile('Focal Length', session.focalLength),

          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String? value) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(vertical: 8),
      prefix: Text(label),
      child: Text(value?.isNotEmpty == true ? value! : 'Not Set', textAlign: TextAlign.right),
    );
  }
}
