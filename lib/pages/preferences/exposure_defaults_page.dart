import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class ExposureDefaultsPage extends StatefulWidget {
  const ExposureDefaultsPage({super.key});

  @override
  State<ExposureDefaultsPage> createState() => _ExposureDefaultsPageState();
}

class _ExposureDefaultsPageState extends State<ExposureDefaultsPage> {
  String _exposureMode = 'Aperture'; // default

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _exposureMode = prefs['exposureMode'] ?? 'Aperture';
    });
  }

  Future<void> _selectExposureMode(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Exposure mode'),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: _exposureMode == 'Aperture',
            onPressed: () async {
              Navigator.pop(context);
              await PrefsService.saveSetting('exposureMode', 'Aperture');
              setState(() => _exposureMode = 'Aperture');
            },
            child: const Text('Aperture'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: _exposureMode == 'Speed',
            onPressed: () async {
              Navigator.pop(context);
              await PrefsService.saveSetting('exposureMode', 'Speed');
              setState(() => _exposureMode = 'Speed');
            },
            child: const Text('Speed'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exposure Defaults'),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile(
              title: const Text('Exposure mode'),
              trailing: Text(_exposureMode, style: textStyle),
              onTap: () => _selectExposureMode(context),
            ),
          ],
        ),
      ),
    );
  }
}
