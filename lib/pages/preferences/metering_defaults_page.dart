import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class MeteringDefaultsPage extends StatefulWidget {
  const MeteringDefaultsPage({super.key});

  @override
  State<MeteringDefaultsPage> createState() => _MeteringDefaultsPageState();
}

class _MeteringDefaultsPageState extends State<MeteringDefaultsPage> {
  String _meteringMethod = 'Incident';
  double _loZone = 3.0;
  double _hiZone = 7.0;

  final List<String> meteringOptions = ['Incident', 'Zone'];
  final List<double> zoneValues = List.generate(81, (i) => i / 10 + 1.0); // Zones 1.0 to 9.0

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _meteringMethod = prefs['meteringMethod'] ?? 'Incident';
      _loZone = double.tryParse(prefs['loZone'] ?? '3.0') ?? 3.0;
      _hiZone = double.tryParse(prefs['hiZone'] ?? '7.0') ?? 7.0;
    });
  }

  Future<void> _savePref(String key, String value) async {
    await PrefsService.saveSetting(key, value);
  }

  void _showMeteringMethodPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Select Metering Method"),
        actions: meteringOptions.map((method) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _meteringMethod = method;
              });
              _savePref('meteringMethod', method);
            },
            child: Text(method),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Widget _buildZonePicker(String label, double zoneValue, ValueChanged<double> onChanged) {
    final initialIndex = zoneValues.indexOf(zoneValue);

    return Row(
      children: [
        Expanded(child: Text(label, style: CupertinoTheme.of(context).textTheme.textStyle)),
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: initialIndex),
            itemExtent: 32.0,
            onSelectedItemChanged: (index) {
              double newZone = zoneValues[index];
              onChanged(newZone);
            },
            children: zoneValues.map((z) => Center(child: Text(z.toStringAsFixed(1)))).toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Metering Defaults"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListTile(
              title: Text("Metering Method", style: textStyle),
              trailing: Text(_meteringMethod),
              onTap: _showMeteringMethodPicker,
            ),
            const SizedBox(height: 24),
            Text("Zone Metering", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildZonePicker("Lo Zone", _loZone, (val) {
              setState(() => _loZone = val);
              _savePref('loZone', val.toString());
            }),
            const SizedBox(height: 8),
            _buildZonePicker("Hi Zone", _hiZone, (val) {
              setState(() => _hiZone = val);
              _savePref('hiZone', val.toString());
            }),
          ],
        ),
      ),
    );
  }
}
