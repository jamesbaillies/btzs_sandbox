import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/session.dart';
import '../../utils/styles.dart';


class FactorsPage extends StatefulWidget {
  final Session session;

  const FactorsPage({super.key, required this.session});

  @override
  State<FactorsPage> createState() => FactorsPageState();
}

class FactorsPageState extends State<FactorsPage> {
  late String selectedFilter;
  late double filterFactor;
  late String bellowsMode;
  late double bellowsFactor;
  late double extensionMm;
  late double magnification;
  late String exposureAdjustment;

  final List<Map<String, dynamic>> filters = [
    {'name': 'None', 'factor': 1.0},
    {'name': 'Light Yellow 3', 'factor': 1.25},
    {'name': 'Yellow 8', 'factor': 2.0},
    {'name': 'Orange 21', 'factor': 2.5},
    {'name': 'Red 25', 'factor': 3.0},
    {'name': 'Green 58', 'factor': 2.5},
    {'name': 'Blue 47', 'factor': 3.0},
  ];

  final List<String> bellowsModes = ['None', 'Distance', 'Extension', 'Magnification'];
  final List<String> exposureAdjustments = ['None', '+0.5 stop', '+1 stop', '+1.5 stop', '+2 stops'];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.session.selectedFilter ?? 'None';
    filterFactor = filters.firstWhere((f) => f['name'] == selectedFilter, orElse: () => {'factor': 1.0})['factor'];
    bellowsMode = widget.session.bellowsFactorMode ?? 'None';
    bellowsFactor = widget.session.bellowsValue ?? 1.0;
    exposureAdjustment = widget.session.exposureAdjustment ?? 'None';
    extensionMm = 0.0;
    magnification = 0.0;
    _calculateBellowsFactor();
  }

  void _calculateBellowsFactor() {
    final f = widget.session.focalLength;
    if (f == null || f <= 0) return;

    switch (bellowsMode) {
      case 'Distance':
        double distanceM = widget.session.distance ?? 1.0;
        double ext = (f * distanceM) / (distanceM - f / 1000);
        extensionMm = ext;
        magnification = ext / f - 1;
        bellowsFactor = (ext / f) * (ext / f);
        break;
      case 'Extension':
        double ext = widget.session.railTravel ?? 0.0;
        extensionMm = ext;
        magnification = ext / f - 1;
        bellowsFactor = (ext / f) * (ext / f);
        break;
      case 'Magnification':
        double mag = (widget.session.railTravel ?? 0.0) / f - 1;
        magnification = mag;
        bellowsFactor = (1 + mag) * (1 + mag);
        break;
      case 'None':
      default:
        extensionMm = 0;
        magnification = 0;
        bellowsFactor = 1.0;
    }
  }

  void _showFilterPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
              initialItem: filters.indexWhere((f) => f['name'] == selectedFilter)),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedFilter = filters[index]['name'];
              filterFactor = filters[index]['factor'];
            });
          },
          children: filters.map((f) => Text(f['name'])).toList(),
        ),
      ),
    );
  }

  void _showBellowsModePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController:
          FixedExtentScrollController(initialItem: bellowsModes.indexOf(bellowsMode)),
          onSelectedItemChanged: (index) {
            setState(() {
              bellowsMode = bellowsModes[index];
              _calculateBellowsFactor();
            });
          },
          children: bellowsModes.map((m) => Text(m)).toList(),
        ),
      ),
    );
  }

  void _showExposureAdjustmentPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
              initialItem: exposureAdjustments.indexOf(exposureAdjustment)),
          onSelectedItemChanged: (index) {
            setState(() {
              exposureAdjustment = exposureAdjustments[index];
            });
          },
          children: exposureAdjustments.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }

  String _getBellowsSummary() {
    if (bellowsMode == 'None') return 'No bellows factor needed';
    return 'Extension: ${extensionMm.toStringAsFixed(1)} mm\n'
        'Magnification: ${magnification.toStringAsFixed(2)}\n'
        'Bellows Factor: ${bellowsFactor.toStringAsFixed(2)}x';
  }

  void saveToSession() {
    widget.session.selectedFilter = selectedFilter;
    widget.session.bellowsFactorMode = bellowsMode;
    widget.session.bellowsValue = bellowsFactor;
    widget.session.exposureAdjustment = exposureAdjustment;
  }

  @override
  Widget build(BuildContext context) {
    final focalLength = widget.session.focalLength;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Factors"),
      ),

      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListTile(
              title: const Text('Filter'),
              trailing: Text(selectedFilter),
              onTap: _showFilterPicker,
            ),
            CupertinoListTile(
              title: const Text('Filter Factor'),
              trailing: Text('${filterFactor.toStringAsFixed(2)}x'),
            ),
            const Divider(),
            CupertinoListTile(
              title: const Text('Bellows Mode'),
              trailing: Text(bellowsMode),
              onTap: _showBellowsModePicker,
            ),
            if (focalLength == null || focalLength <= 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Focal length not set on Camera Page',
                  style: kFeedbackStyle,


                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  _getBellowsSummary(),
                  style: kFeedbackStyle,

                ),
              ),
            const Divider(),
            CupertinoListTile(
              title: const Text('Exposure Adjustment'),
              trailing: Text(exposureAdjustment),
              onTap: _showExposureAdjustmentPicker,
            ),
          ],
        ),
      ),
    );
  }
}
