import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../utils/session.dart';

class ExposureSummaryPage extends StatelessWidget {
  final Session session;

  const ExposureSummaryPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Exposure Summary"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTile("Exposure Title", session.exposureTitle),
            _buildTile("Film Holder", session.filmHolder),
            _buildTile("Film Stock", session.filmStock),
            _buildTile("Focal Length", session.focalLength?.toString()),
            _buildTile("Aperture", session.aperture?.toStringAsFixed(1)),
            _buildTile("Distance", session.distance?.toStringAsFixed(1)),
            _buildTile("Near Distance", session.nearDistance?.toStringAsFixed(1)),
            _buildTile("Far Distance", session.farDistance?.toStringAsFixed(1)),
            _buildTile("Circle of Confusion", session.circleOfConfusion?.toStringAsFixed(3)),
            _buildTile("Favor DOF", session.favorDOF == true ? "Yes" : "No"),
            _buildTile("Timestamp", DateFormat.yMMMd().add_jm().format(session.timestamp)),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value ?? '')),
        ],
      ),
    );
  }
}
