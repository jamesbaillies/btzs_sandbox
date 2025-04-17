// camera_page.dart
import 'package:flutter/cupertino.dart';
import '../utils/session.dart';
import '../utils/styles.dart';


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

  final List<double> _focalLengths = [90, 115, 210, 300];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.session.exposureTitle);
    _holderController = TextEditingController(text: widget.session.filmHolder);
  }

  void _selectFromList<T>(String title, List<T> items, T current, Function(T) onSelected) {
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
            child: Text(item.toString()),
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
    widget.session.timestamp = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
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
              onTap: () => _selectFromList<String>(
                "Film",
                _films,
                widget.session.filmStock,
                    (value) => setState(() => widget.session.filmStock = value),
              ),
            ),
            CupertinoListTile(
              title: const Text("Focal Length"),
              trailing: Text(widget.session.focalLength != null
                  ? "${widget.session.focalLength!.toStringAsFixed(0)} mm"
                  : "Not Set"),
              onTap: () => _selectFromList<double>(
                "Focal Length",
                _focalLengths,
                widget.session.focalLength ?? 210,
                    (value) => setState(() => widget.session.focalLength = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}