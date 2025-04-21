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
  final List<double> zoneValues = List.generate(81, (i) => i / 10 + 1.0); // 1.0 to 9.0

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  Future<void> _loadDefaults() async {
    final prefs = await PrefsService.loadMeteringDefaults();
    if (!mounted) return;
    setState(() {
      _meteringMethod = prefs['meteringMethod'] ?? 'Incident';
      _loZone = prefs['loZone'] ?? 3.0;
      _hiZone = prefs['hiZone'] ?? 7.0;
    });
  }

  Future<void> _saveDefaults() async {
    await PrefsService.saveMeteringDefaults({
      'meteringMethod': _meteringMethod,
      'loZone': _loZone,
      'hiZone': _hiZone,
    });
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
              _saveDefaults();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 150,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: initialIndex),
            itemExtent: 32.0,
            onSelectedItemChanged: (index) {
              final newZone = zoneValues[index];
              onChanged(newZone);
              _saveDefaults();
            },
            children: zoneValues.map((z) => Center(child: Text(z.toStringAsFixed(1)))).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Metering Defaults"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListTile(
              title: const Text("Metering Method"),
              trailing: Text(_meteringMethod),
              onTap: _showMeteringMethodPicker,
            ),
            const SizedBox(height: 24),
            const Text("Zone Metering", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildZonePicker("Lo Zone", _loZone, (val) => setState(() => _loZone = val)),
            _buildZonePicker("Hi Zone", _hiZone, (val) => setState(() => _hiZone = val)),
          ],
        ),
      ),
    );
  }
}
