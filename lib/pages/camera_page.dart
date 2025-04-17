import 'package:flutter/cupertino.dart';
import '../utils/session.dart';

class CameraPage extends StatefulWidget {
  final Session session;

  const CameraPage({super.key, required this.session});

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late TextEditingController _titleController;
  late TextEditingController _holderController;

  final List<String> _films = [
    'Not Set', 'APX DI#13 1+9 Lo', 'D100 DDX 1+9 Lo', 'TMY DDX 1+9 Lo'
  ];

  final List<String> _focalLengths = [
    'Not Set', '90mm', '115mm', '210mm', '300mm'
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.session.exposureTitle);
    _holderController = TextEditingController(text: widget.session.filmHolder);
  }

  void _selectFromList(String title, List<String> items, String current,
      Function(String) onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          CupertinoActionSheet(
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

  void saveToSession() {
    widget.session.exposureTitle = _titleController.text;
    widget.session.filmHolder = _holderController.text;
    widget.session.filmStock = widget.session.filmStock;
    widget.session.focalLength = widget.session.focalLength;
    widget.session.timestamp = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Camera"),
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
              trailing: Text(widget.session.filmStock),
              onTap: () =>
                  _selectFromList(
                    "Film",
                    _films,
                    widget.session.filmStock,
                        (value) =>
                        setState(() => widget.session.filmStock = value),
                  ),
            ),
            CupertinoListTile(
              title: const Text("Focal Length"),
              trailing: Text(widget.session.focalLength?.toString() ?? 'Not Set'),
              onTap: () => _selectFromList(
                "Focal Length",
                _focalLengths,
                widget.session.focalLength?.toString() ?? '', // <-- non-null fallback
                    (value) => setState(() => widget.session.focalLength = double.tryParse(value)),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
