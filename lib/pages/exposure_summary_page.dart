import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../utils/session.dart';
import '../../utils/styles.dart';

class ExposureSummaryPage extends StatelessWidget {
  final Session session;
  final VoidCallback onDone;

  const ExposureSummaryPage({
    super.key,
    required this.session,
    required this.onDone,
  });

  String formatDouble(double? value, {int fractionDigits = 1, String suffix = ''}) {
    if (value == null) return '—';
    return '${value.toStringAsFixed(fractionDigits)}$suffix';
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '—';
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onDone,
          child: const Text('Back'),
        ),
        middle: const Text('Exposure Summary'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('📸 Camera Info', style: kFeedbackStyle),
            const SizedBox(height: 4),
            Text('Title: ${session.exposureTitle}', style: kFeedbackStyle),
            Text('Holder: ${session.filmHolder}', style: kFeedbackStyle),
            Text('Timestamp: ${formatTimestamp(session.timestamp)}', style: kFeedbackStyle),
            Text('Focal Length: ${formatDouble(session.focalLength, suffix: ' mm')}', style: kFeedbackStyle),
            const SizedBox(height: 16),

            Text('🎞️ Film', style: kFeedbackStyle),
            const SizedBox(height: 4),
            Text('Film Stock: ${session.filmStock}', style: kFeedbackStyle),
            const SizedBox(height: 16),

            Text('☀️ Metering', style: kFeedbackStyle),
            const SizedBox(height: 4),
            Text('Method: ${session.meteringMethod}', style: kFeedbackStyle),
            Text('Lo EV: ${formatDouble(session.loEv)}', style: kFeedbackStyle),
            Text('Hi EV: ${formatDouble(session.hiEv)}', style: kFeedbackStyle),
            if (session.meteringMethod == 'Zone') ...[
              Text('Lo Zone: ${formatDouble(session.loZone)}', style: kFeedbackStyle),
              Text('Hi Zone: ${formatDouble(session.hiZone)}', style: kFeedbackStyle),
            ],
            const SizedBox(height: 16),

            Text('📐 Depth of Field', style: kFeedbackStyle),
            const SizedBox(height: 4),
            Text('Mode: ${session.dofMode}', style: kFeedbackStyle),
            Text('Aperture: ${formatDouble(session.aperture)}', style: kFeedbackStyle),
            Text('Distance: ${formatDouble(session.distance, suffix: ' m')}', style: kFeedbackStyle),
            Text('Near: ${formatDouble(session.nearDistance, suffix: ' m')}', style: kFeedbackStyle),
            Text('Far: ${formatDouble(session.farDistance, suffix: ' m')}', style: kFeedbackStyle),
            Text('Rail Travel: ${formatDouble(session.railTravel, suffix: ' mm')}', style: kFeedbackStyle),
            Text('Favor DOF: ${session.favorDOF == true ? "Yes" : "No"}', style: kFeedbackStyle),
            const SizedBox(height: 16),

            Text('📊 Factors', style: kFeedbackStyle),
            const SizedBox(height: 4),
            Text('Filter: ${session.selectedFilter ?? 'None'}', style: kFeedbackStyle),
            Text('Bellows Mode: ${session.bellowsFactorMode ?? 'None'}', style: kFeedbackStyle),
            Text('Bellows Factor: ${formatDouble(session.bellowsValue)}x', style: kFeedbackStyle),
            Text('Exposure Adj: ${session.exposureAdjustment ?? 'None'}', style: kFeedbackStyle),
            const SizedBox(height: 24),

            CupertinoButton.filled(
              onPressed: onDone,
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
