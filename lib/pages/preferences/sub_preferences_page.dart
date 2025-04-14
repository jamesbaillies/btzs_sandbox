import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubPreferencesPage extends StatefulWidget {
  const SubPreferencesPage({super.key});

  @override
  State<SubPreferencesPage> createState() => _SubPreferencesPageState();
}

class _SubPreferencesPageState extends State<SubPreferencesPage> {
  bool showSummary = true;
  bool numberedHolders = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showSummary = prefs.getBool('showSummary') ?? true;
      numberedHolders = prefs.getBool('numberedHolders') ?? true;
    });
  }

  Future<void> _updatePrefs(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sub Preferences'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildToggle(
              label: 'Show Summary',
              value: showSummary,
              onChanged: (val) {
                setState(() => showSummary = val);
                _updatePrefs('showSummary', val);
              },
            ),
            const SizedBox(height: 16),
            _buildToggle(
              label: 'Numbered Holders',
              value: numberedHolders,
              onChanged: (val) {
                setState(() => numberedHolders = val);
                _updatePrefs('numberedHolders', val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
        CupertinoSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
