import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../utils/session.dart';
import '../utils/prefs_service.dart';

class FactorsPage extends StatefulWidget {
  final Session session;

  const FactorsPage({super.key, required this.session});

  @override
  State<FactorsPage> createState() => FactorsPageState();
}

class FactorsPageState extends State<FactorsPage> {
  final List<String> exposureAdjustments = [
    'none', '+0.5', '+1', '+1.5', '+2', '-0.5', '-1',
  ];

  final List<String> bellowsModes = ['None', 'Distance', 'Ext', 'Mag'];
  final List<double> valueRange = List.generate(201, (i) => i * 0.1); // up to 20
  late FixedExtentScrollController _valueCtrl;
  late FixedExtentScrollController _adjustCtrl;

  List<String> _filters = ['None'];
  bool _loadingFilters = true;

  @override
  void initState() {
    super.initState();
    widget.session.bellowsFactorMode ??= 'None';
    widget.session.bellowsValue ??= 0.0;
    widget.session.selectedFilter ??= 'None';
    widget.session.exposureAdjustment ??= 'none';

    _valueCtrl = FixedExtentScrollController(
      initialItem: valueRange.indexOf(widget.session.bellowsValue ?? 0.0),
    );
    _adjustCtrl = FixedExtentScrollController(
      initialItem: exposureAdjustments.indexOf(widget.session.exposureAdjustment ?? 'none'),
    );

    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final filters = await PrefsService.instance.getFilterList();
    setState(() {
      _filters = filters;
      _loadingFilters = false;
    });
  }

  void saveToSession() {
    widget.session.timestamp = DateTime.now();
  }

  double get focalLengthMm {
    return widget.session.focalLength ?? 210.0;

  }

  Widget _buildCalculationBlock() {
    final mode = widget.session.bellowsFactorMode!;
    final value = widget.session.bellowsValue ?? 0.0;
    final f = focalLengthMm;

    double extension = 0.0;
    double magnification = 0.0;
    double bf = 1.0;

    switch (mode) {
      case 'Distance':
        final subjectDistanceM = value;
        final subjectDistanceMm = subjectDistanceM * 1000.0;
        extension = (f * subjectDistanceMm) / (subjectDistanceMm - f);
        magnification = extension / f;
        bf = pow(magnification + 1, 2).toDouble();
        break;
      case 'Ext':
        extension = value;
        magnification = extension / f;
        bf = pow(magnification + 1, 2).toDouble();
        break;
      case 'Mag':
        magnification = value;
        extension = f * magnification;
        bf = pow(magnification + 1, 2).toDouble();
        break;
      case 'None':
      default:
        return const Text("Bellows factor will not be applied.");
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Focal Length: ${f.toStringAsFixed(0)} mm\n'
            'Extension: ${extension.toStringAsFixed(1)} mm\n'
            'Magnification: ${magnification.toStringAsFixed(3)}\n'
            'Bellows Factor: ${bf.toStringAsFixed(2)}',
        style: const TextStyle(color: CupertinoColors.white),
      ),
    );
  }

  Widget _buildValuePicker() {
    final mode = widget.session.bellowsFactorMode!;
    String unit = '';
    String label = '';

    switch (mode) {
      case 'Distance':
        unit = 'm';
        label = "Focus Distance";
        break;
      case 'Ext':
        unit = 'mm';
        label = "Extension";
        break;
      case 'Mag':
        unit = '';
        label = "Magnification";
        break;
      default:
        return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: CupertinoColors.white)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: _valueCtrl,
            itemExtent: 32,
            onSelectedItemChanged: (i) =>
                setState(() => widget.session.bellowsValue = valueRange[i]),
            children: valueRange.map((v) => Center(child: Text('${v.toStringAsFixed(1)} $unit'))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdjustmentPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Exposure Adjustment", style: TextStyle(color: CupertinoColors.white)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: _adjustCtrl,
            itemExtent: 32,
            onSelectedItemChanged: (i) =>
                setState(() => widget.session.exposureAdjustment = exposureAdjustments[i]),
            children: exposureAdjustments.map((v) => Center(child: Text(v))).toList(),
          ),
        ),
      ],
    );
  }

  void _selectFilter() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Select Filter"),
        actions: _filters.map((filter) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() => widget.session.selectedFilter = filter);
            },
            child: Text(filter),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.session.bellowsFactorMode ?? 'None';

    if (_loadingFilters) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Factors"),
        ),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Factors"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListTile(
              title: const Text("Filter"),
              trailing: Text(widget.session.selectedFilter ?? 'None'),
              onTap: _selectFilter,
            ),
            const SizedBox(height: 16),
            CupertinoSegmentedControl<String>(
              groupValue: mode,
              onValueChanged: (val) =>
                  setState(() => widget.session.bellowsFactorMode = val),
              children: {
                for (var val in bellowsModes) val: Text(val),
              },
            ),
            const SizedBox(height: 16),
            if (mode != 'None') _buildValuePicker(),
            _buildCalculationBlock(),
            const SizedBox(height: 16),
            _buildAdjustmentPicker(),
          ],
        ),
      ),
    );
  }
}
