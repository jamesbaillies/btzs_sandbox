import 'package:flutter/cupertino.dart';
import '../utils/session.dart';
import '../utils/prefs_service.dart';

class FactorsPage extends StatefulWidget {
  final Session session;

  const FactorsPage({super.key, required this.session});

  @override
  State<FactorsPage> createState() => _FactorsPageState();
}

class _FactorsPageState extends State<FactorsPage> {
  final List<String> exposureAdjustments = [
    'none',
    '+0.5',
    '+1',
    '+1.5',
    '+2',
    '-0.5',
    '-1',
  ];

  final List<String> bellowsModes = ['None', 'Distance', 'Ext', 'Mag'];
  final List<double> valueRange = List.generate(101, (i) => i * 0.1);

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
        initialItem: valueRange.indexOf(widget.session.bellowsValue ?? 0.0));
    _adjustCtrl = FixedExtentScrollController(
        initialItem:
        exposureAdjustments.indexOf(widget.session.exposureAdjustment ?? 'none'));

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

  String get feedback {
    switch (widget.session.bellowsFactorMode) {
      case 'None':
        return "A bellows factor will not be applied.\nChoose a method to calculate a bellows factor.";
      case 'Distance':
      case 'Ext':
      case 'Mag':
        return "No bellows factor is needed"; // Placeholder for future logic
      default:
        return "";
    }
  }

  void _selectFilter() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Filter"),
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

  Widget _buildBellowsPicker() {
    return SizedBox(
      height: 100,
      child: CupertinoPicker(
        scrollController: _valueCtrl,
        itemExtent: 32,
        onSelectedItemChanged: (i) =>
            setState(() => widget.session.bellowsValue = valueRange[i]),
        children: valueRange.map((v) {
          final label = v.toStringAsFixed(1);
          final unit = widget.session.bellowsFactorMode == 'Ext'
              ? 'mm'
              : widget.session.bellowsFactorMode == 'Distance'
              ? 'm'
              : '';
          return Center(child: Text("$label$unit"));
        }).toList(),
      ),
    );
  }

  Widget _buildAdjustmentPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Exposure Adjustment",
            style: TextStyle(color: CupertinoColors.white)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: _adjustCtrl,
            itemExtent: 32,
            onSelectedItemChanged: (i) => setState(
                    () => widget.session.exposureAdjustment = exposureAdjustments[i]),
            children:
            exposureAdjustments.map((v) => Center(child: Text(v))).toList(),
          ),
        ),
      ],
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
            if (mode != 'None') _buildBellowsPicker(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                feedback,
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdjustmentPicker(),
          ],
        ),
      ),
    );
  }
}

// Add this at the very bottom of the file 👇
typedef FactorsPageState = _FactorsPageState;
