import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _titleController = TextEditingController();
  final _holderController = TextEditingController();

  String _selectedFilm = 'Not Set';
  String _selectedFocalLength = 'Not Set';
  double _flareFactor = 0.02;
  double _paperES = 1.05;

  final List<String> _films = [
    'Not Set', 'APX DI#13 1+9 Lo', 'D100 DDX 1+9 Lo', 'TMY DDX 1+9 Lo'
  ];

  final List<String> _focalLengths = [
    'Not Set', '90mm', '115mm', '210mm', '300mm'
  ];

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  Future<void> _loadDefaults() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _selectedFilm = prefs['defaultFilm'] ?? 'Not Set';
      _selectedFocalLength = prefs['defaultFocalLength'] ?? 'Not Set';
    });

    _flareFactor = await PrefsService.loadDouble('defaultFlareFactor', 0.02);
    _paperES = await PrefsService.loadDouble('defaultPaperES', 1.05);
  }

  void _selectFromList(
      String title,
      List<String> items,
      String current,
      Function(String) onSelected,
      ) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(title),
        actions: items.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onSelected(item);
            },
            child: Text(item),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  Widget _buildFlarePicker() {
    final flareOptions = List.generate(31, (i) => (i * 0.01) + 0.01); // 0.01 to 0.31

    return CupertinoActionSheet(
      title: const Text("Select Flare Factor"),
      message: SizedBox(
        height: 150,
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: flareOptions.indexWhere((v) => v.toStringAsFixed(2) == _flareFactor.toStringAsFixed(2)),
          ),
          onSelectedItemChanged: (index) async {
            final newValue = flareOptions[index];
            await PrefsService.saveSetting('defaultPaperES', newValue.toString());
            setState(() => _flareFactor = newValue);
          },
          children: flareOptions.map((f) => Text(f.toStringAsFixed(2))).toList(),
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text("Done"),
      ),
    );
  }

  Widget _buildPaperESPicker() {
    final esOptions = List.generate(41, (i) => 1.00 + i * 0.05); // 1.00 to 3.00

    return CupertinoActionSheet(
      title: const Text("Select Paper ES"),
      message: SizedBox(
        height: 150,
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: esOptions.indexWhere((v) => v.toStringAsFixed(2) == _paperES.toStringAsFixed(2)),
          ),
          onSelectedItemChanged: (index) async {
            final newValue = esOptions[index];
            await PrefsService.saveSetting('defaultPaperES', newValue.toString());
            setState(() => _paperES = newValue);
          },
          children: esOptions.map((es) => Text(es.toStringAsFixed(2))).toList(),
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text("Done"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Camera"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoTextField(
              controller: _titleController,
              placeholder: "Title",
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: _holderController,
              placeholder: "Holder",
            ),
            const SizedBox(height: 12),
            CupertinoListTile(
              title: const Text("Film"),
              trailing: Text(_selectedFilm),
              onTap: () => _selectFromList(
                "Film",
                _films,
                _selectedFilm,
                    (value) => setState(() => _selectedFilm = value),
              ),
            ),
            CupertinoListTile(
              title: const Text("Focal Length"),
              trailing: Text(_selectedFocalLength),
              onTap: () => _selectFromList(
                "Focal Length",
                _focalLengths,
                _selectedFocalLength,
                    (value) => setState(() => _selectedFocalLength = value),
              ),
            ),
            const SizedBox(height: 24),
            CupertinoFormSection.insetGrouped(
              header: const Text("Flare Factor & Paper ES"),
              children: [
                CupertinoListTile(
                  title: const Text("Flare Factor"),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(_flareFactor.toStringAsFixed(2)),
                    onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (_) => _buildFlarePicker(),
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: const Text("Paper ES"),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(_paperES.toStringAsFixed(2)),
                    onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (_) => _buildPaperESPicker(),
                    ),
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
