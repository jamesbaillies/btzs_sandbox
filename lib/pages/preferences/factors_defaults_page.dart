import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';
import 'filter_manager_page.dart';

class FactorsDefaultsPage extends StatefulWidget {
  const FactorsDefaultsPage({super.key});

  @override
  State<FactorsDefaultsPage> createState() => _FactorsDefaultsPageState();
}

class _FactorsDefaultsPageState extends State<FactorsDefaultsPage> {
  String _selectedFilter = 'None';
  String _exposureAdjustment = 'none';

  final List<String> _adjustments = ['none', '1/3 stop', '2/3 stop', '1 stop'];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _selectedFilter = prefs['selectedFilter'] ?? 'None';
      _exposureAdjustment = prefs['exposureAdjustment'] ?? 'none';
    });
  }

  Future<void> _selectFilter(BuildContext context) async {
    final filters = await PrefsService.getFilterList();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Select Filter"),
        actions: [
          for (final filter in filters)
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await PrefsService.saveSetting('selectedFilter', filter);
                setState(() => _selectedFilter = filter);
              },
              child: Text(filter),
            ),
          CupertinoActionSheetAction(
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const FilterManagerPage()),
              ).then((_) => _loadPrefs());
            },
            child: const Text("Edit Filters"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  Future<void> _selectExposureAdjustment(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _adjustments.indexOf(_exposureAdjustment),
          ),
          onSelectedItemChanged: (index) async {
            final value = _adjustments[index];
            await PrefsService.saveSetting('exposureAdjustment', value);
            setState(() => _exposureAdjustment = value);
          },
          children: _adjustments.map((adj) => Text(adj)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Factors Defaults'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text("Filters"),
              children: [
                CupertinoListTile(
                  title: const Text("Filters"),
                  trailing: Text(_selectedFilter),
                  onTap: () => _selectFilter(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CupertinoListSection.insetGrouped(
              header: const Text("Exposure Adjustment"),
              children: [
                CupertinoListTile(
                  title: const Text("Exposure"),
                  trailing: Text(_exposureAdjustment),
                  onTap: () => _selectExposureAdjustment(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
