import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';

class CameraPage extends StatefulWidget {
  final Session session;

  const CameraPage({super.key, required this.session});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late TextEditingController _titleController;
  late TextEditingController _holderController;
  late TextEditingController _flareController;
  late TextEditingController _paperESController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.session.title ?? 'New Session');
    _holderController = TextEditingController(text: widget.session.holder ?? '');
    _flareController = TextEditingController(text: widget.session.flareFactor?.toString() ?? '1');
    _paperESController = TextEditingController(text: widget.session.paperES?.toString() ?? '1');
  }

  void _showFilmPicker() {
    // Implement your film picker modal here
  }

  void _showFocalLengthPicker() {
    // Implement your focal length picker modal here
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inline Title Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(width: 80, child: Text('Title:')),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _titleController,
                        placeholder: 'New Session',
                        onChanged: (value) => widget.session.title = value,
                      ),
                    ),
                  ],
                ),
              ),

              // Inline Holder Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(width: 80, child: Text('Holder:')),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _holderController,
                        placeholder: 'Enter holder name/number',
                        onChanged: (value) => widget.session.holder = value,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text('Film Stock'),
              GestureDetector(
                onTap: _showFilmPicker,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Select Film',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text('Focal Length'),
              GestureDetector(
                onTap: _showFocalLengthPicker,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Select Focal Length',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text('Flare Factor'),
              CupertinoTextField(
                controller: _flareController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => widget.session.flareFactor = double.tryParse(value) ?? 1.0,
              ),

              const SizedBox(height: 16),
              const Text('Paper ES'),
              CupertinoTextField(
                controller: _paperESController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => widget.session.paperES = double.tryParse(value) ?? 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
