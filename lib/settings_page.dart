import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/pages/preferences/camera_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/metering_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/factors_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/dof_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/exposure_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/sub_preferences_page.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _units = 'Metric';
  String _evSteps = '1/10 EV';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _units = prefs['units'] ?? 'Metric';
      _evSteps = prefs['evSteps'] ?? '1/10 EV';
    });
  }

  Future<void> _updatePref(String key, String value) async {
    await PrefsService.saveSetting(key, value);
    setState(() {
      if (key == 'units') _units = value;
      if (key == 'evSteps') _evSteps = value;
    });
  }

  void _openSubPrefs() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const SubPreferencesPage()),
    );
  }

  void _openDefaultsPage(Widget page) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => page),
    );
  }

  Widget _buildSegmentedControl({
    required String title,
    required String groupValue,
    required List<String> options,
    required ValueChanged<String> onValueChanged,
  }) {
    final Map<String, Widget> children = {
      for (var option in options)
        option: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(option),
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        CupertinoSegmentedControl<String>(
          groupValue: groupValue,
          children: children,
          onValueChanged: onValueChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDefaultsTile(String label, Widget page) {
    return CupertinoListTile(
      title: Text(label),
      trailing: const Icon(CupertinoIcons.forward),
      onTap: () => _openDefaultsPage(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSegmentedControl(
              title: 'Measurement Units',
              groupValue: _units,
              options: const ['Metric', 'Imperial'],
              onValueChanged: (val) => _updatePref('units', val),
            ),
            _buildSegmentedControl(
              title: 'EV Metering Steps',
              groupValue: _evSteps,
              options: const ['1/10 EV', '1/3 EV'],
              onValueChanged: (val) => _updatePref('evSteps', val),
            ),
            CupertinoButton.filled(
              child: const Text('More Preferences'),
              onPressed: _openSubPrefs,
            ),
            const SizedBox(height: 32),
            const Text('Defaults', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDefaultsTile('Camera', const CameraDefaultsPage()),
            _buildDefaultsTile('Metering', const MeteringDefaultsPage()),
            _buildDefaultsTile('Factors', const FactorsDefaultsPage()),
            _buildDefaultsTile('DOF', const DOFDefaultsPage()),
            _buildDefaultsTile('Exposure', const ExposureDefaultsPage()),
          ],
        ),
      ),
    );
  }
}
