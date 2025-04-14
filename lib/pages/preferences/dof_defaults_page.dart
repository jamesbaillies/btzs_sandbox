import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class DofDefaultsPage extends StatefulWidget {
  const DofDefaultsPage({super.key});

  @override
  State<DofDefaultsPage> createState() => _DofDefaultsPageState();
}

class _DofDefaultsPageState extends State<DofDefaultsPage> {
  double _coc = 0.1;
  bool _favorDOF = false;
  bool _useOptimalAperture = false;

  final Map<String, double> cocOptions = {
    "Small formats (0.025mm)": 0.025,
    "Medium formats (0.05mm)": 0.05,
    "4x5 (0.10mm)": 0.1,
    "5x7 (0.145mm)": 0.145,
    "8x10 (0.20mm)": 0.2,
    "Contact (0.10mm)": 0.1,
  };

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _coc = double.tryParse(prefs['coc'] ?? '') ?? 0.1;
      _favorDOF = (prefs['favorDOF'] ?? 'false') == 'true';
      _useOptimalAperture = (prefs['useOptimalAperture'] ?? 'false') == 'true';
    });
  }


  Future<void> _updatePref(String key, dynamic value) async {
    await PrefsService.saveSetting(key, value);
    setState(() {
      if (key == 'coc') _coc = value;
      if (key == 'favorDOF') _favorDOF = value;
      if (key == 'useOptimalAperture') _useOptimalAperture = value;
    });
  }

  void _showCoCSelector(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Film size (CoC)"),
        actions: cocOptions.entries.map((entry) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updatePref('coc', entry.value);
            },
            isDefaultAction: _coc == entry.value,
            child: Text(entry.key),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  String _getCoCLabel() {
    return cocOptions.entries.firstWhere((e) => e.value == _coc,
        orElse: () => const MapEntry("Custom", 0.0))
        .key;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('DOF Defaults'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text("Film size (CoC)"),
              children: [
                CupertinoListTile(
                  title: const Text("Film size (CoC)"),
                  trailing: Text(_getCoCLabel()),
                  onTap: () => _showCoCSelector(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CupertinoFormSection(
              header: const Text("Depth of Field Settings"),
              children: [
                CupertinoFormRow(
                  prefix: const Text("Favor DOF"),
                  child: CupertinoSwitch(
                    value: _favorDOF,
                    onChanged: (value) => _updatePref('favorDOF', value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "When turned on, ExpoDev always favors Depth of Field when adjusting exposures",
                    style: textStyle.copyWith(fontSize: 13, color: CupertinoColors.systemGrey),
                  ),
                ),
                CupertinoFormRow(
                  prefix: const Text("Use Optimal Aperture"),
                  child: CupertinoSwitch(
                    value: _useOptimalAperture,
                    onChanged: (value) => _updatePref('useOptimalAperture', value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "When turned on, ExpoDev will use the Optimal Aperture when setting DOF apertures (unless the Optimal is less than the Minimum, then the Minimum will still be used)",
                    style: textStyle.copyWith(fontSize: 13, color: CupertinoColors.systemGrey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
