import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';
import '../../utils/prefs_service.dart';

class ExposureSummaryPage extends StatelessWidget {
  final Session session;

  const ExposureSummaryPage({super.key, required this.session});

  void _handleCancel(BuildContext context) {
    Navigator.of(context).pop(); // Just go back — discard session
  }

  void _handleDone(BuildContext context) async {
    await PrefsService.saveSession(session);
    Navigator.of(context).pop(); // Return to Exposure List Page
  }

  Widget _buildSummaryRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value ?? '—')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Summary'),
        leading: GestureDetector(
          onTap: () => _handleCancel(context),
          child: const Text('Cancel'),
        ),
        trailing: GestureDetector(
          onTap: () => _handleDone(context),
          child: const Text('Done'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow('Title', session.title),
              _buildSummaryRow('Holder', session.holder),
              _buildSummaryRow('Film', session.film),
              _buildSummaryRow('Focal Length', session.focalLength?.toString()),
              _buildSummaryRow('Flare Factor', session.flareFactor?.toString()),
              _buildSummaryRow('Paper ES', session.paperES?.toString()),
              _buildSummaryRow('Lo EV', session.loEv?.toString()),
              _buildSummaryRow('Hi EV', session.hiEv?.toString()),
              _buildSummaryRow('Lo Zone', session.loZone?.toString()),
              _buildSummaryRow('Hi Zone', session.hiZone?.toString()),
              _buildSummaryRow('Bellows Factor', session.bellowsValue?.toString()),
              _buildSummaryRow('Total Exp. Factor', session.totalExposureFactor?.toString()),
              _buildSummaryRow('Hyperfocal', session.hyperfocalDistance?.toStringAsFixed(1)),
              _buildSummaryRow('Metering Notes', session.meteringNotes),
            ],
          ),
        ),
      ),
    );
  }
}
