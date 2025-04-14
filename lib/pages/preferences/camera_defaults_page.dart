import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraDefaultsPage extends StatefulWidget {
  const CameraDefaultsPage({super.key});

  @override
  State<CameraDefaultsPage> createState() => _CameraDefaultsPageState();
}

class _CameraDefaultsPageState extends State<CameraDefaultsPage> {
  final List<String> filmStocks = ['HP5+', 'Tri-X', 'FP4+', 'T-Max 100'];
  final List<double> focalLengths = [90, 135, 150, 180, 210, 240, 300, 360];
  final List<double> flareFactors = [
    0.01,
    0.02,
    0.03,
    0.04,
    0.05,
    0.06,
    0.07,
    0.08,
    0.09,
    0.10
  ];

  int selectedFilmIndex = 0;
  int selectedFocalIndex = 4;
  int selectedFlareIndex = 1;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  Future<void> _loadDefaults() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedFilmIndex = prefs.getInt('default_film_index') ?? 0;
      selectedFocalIndex = prefs.getInt('default_focal_index') ?? 4;
      selectedFlareIndex = prefs.getInt('default_flare_index') ?? 1;
    });
  }

  Future<void> _saveDefaults() async {
    await prefs.setInt('default_film_index', selectedFilmIndex);
    await prefs.setInt('default_focal_index', selectedFocalIndex);
    await prefs.setInt('default_flare_index', selectedFlareIndex);
  }

  Widget _buildPickerTile(
      String label, String value, VoidCallback onTap, BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoListTile(
      title: Text(label, style: textStyle),
      trailing: Text(value, style: textStyle),
      onTap: onTap,
    );
  }

  Future<void> _showPickerDialog(
      BuildContext context, String title, List<dynamic> items, int selectedIndex, Function(int) onSelected) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Cancel'),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done', style: TextStyle(color: CupertinoColors.activeBlue)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                itemExtent: 32.0,
                onSelectedItemChanged: onSelected,
                children: items.map((item) => Center(child: Text('$item'))).toList(),
              ),
            ),
          ],
        ),
      ),
    );

    await _saveDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Camera Defaults'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            _buildPickerTile(
              'Film Stock',
              filmStocks[selectedFilmIndex],
                  () => _showPickerDialog(
                context,
                'Film Stock',
                filmStocks,
                selectedFilmIndex,
                    (index) => setState(() => selectedFilmIndex = index),
              ),
              context,
            ),
            _buildPickerTile(
              'Focal Length',
              '${focalLengths[selectedFocalIndex].toInt()}mm',
                  () => _showPickerDialog(
                context,
                'Focal Length',
                focalLengths,
                selectedFocalIndex,
                    (index) => setState(() => selectedFocalIndex = index),
              ),
              context,
            ),
            _buildPickerTile(
              'Flare Factor',
              flareFactors[selectedFlareIndex].toStringAsFixed(2),
                  () => _showPickerDialog(
                context,
                'Flare Factor',
                flareFactors,
                selectedFlareIndex,
                    (index) => setState(() => selectedFlareIndex = index),
              ),
              context,
            ),
          ],
        ),
      ),
    );
  }
}
