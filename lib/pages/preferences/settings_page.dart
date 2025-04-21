import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/pages/preferences/sub_preferences_page.dart';
import 'package:btzs_sandbox/pages/preferences/camera_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/metering_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/factors_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/dof_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/exposure_defaults_page.dart';
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

  void _openSubPrefsPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const SubPreferencesPage()),
    );
  }

  void _openDefaultsPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => page),
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
          children: [
            const SizedBox(height: 20),
            _buildSegmentedControl(
              title: 'Measurement Units',
              value: _units,
              options: const ['Metric', 'Imperial'],
              onValueChanged: (val) => _updatePref('units', val),
            ),
            _buildSegmentedControl(
              title: 'EV Metering Steps',
              value: _evSteps,
              options: const ['1/10 EV', '1/3 EV'],
              onValueChanged: (val) => _updatePref('evSteps', val),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoButton.filled(
                onPressed: () => _openSubPrefsPage(context),
                child: const Text('More Preferences'),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Defaults', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(height: 8),
            _buildDefaultsTile(context, 'Camera', const CameraDefaultsPage()),
            _buildDefaultsTile(context, 'Metering', const MeteringDefaultsPage()),
            _buildDefaultsTile(context, 'Factors', const FactorsDefaultsPage()),
            _buildDefaultsTile(context, 'DOF', const DofDefaultsPage()),
            _buildDefaultsTile(context, 'Exposure', const ExposureDefaultsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl({
    required String title,
    required String value,
    required List<String> options,
    required void Function(String) onValueChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          CupertinoSlidingSegmentedControl<String>(
            groupValue: value,
            children: {
              for (var option in options) option: Text(option),
            },
            onValueChanged: (val) {
              if (val != null) onValueChanged(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultsTile(BuildContext context, String label, Widget page) {
    return CupertinoListTile(
      title: Text(label),
      trailing: const Icon(CupertinoIcons.right_chevron),
      onTap: () => _openDefaultsPage(context, page),
    );
  }
}
