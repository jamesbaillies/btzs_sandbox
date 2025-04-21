import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';

class ExposurePage extends StatefulWidget {
  final Session session;

  const ExposurePage({
    super.key,
    required this.session,
  });

  @override
  State<ExposurePage> createState() => _ExposurePageState();
}

class _ExposurePageState extends State<ExposurePage> {
  late TextEditingController _apertureController;
  late TextEditingController _shutterController;

  @override
  void initState() {
    super.initState();
    _apertureController = TextEditingController(
      text: widget.session.aperture?.toString() ?? '',
    );
    _shutterController = TextEditingController(
      text: widget.session.shutterSpeed?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _apertureController.dispose();
    _shutterController.dispose();
    super.dispose();
  }

  void _updateSession() {
    setState(() {
      widget.session.aperture = double.tryParse(_apertureController.text);
      widget.session.shutterSpeed = double.tryParse(_shutterController.text);
    });
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
              const Text('Final Aperture'),
              CupertinoTextField(
                controller: _apertureController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                placeholder: 'e.g. 16',
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('Final Shutter Speed (s)'),
              CupertinoTextField(
                controller: _shutterController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                placeholder: 'e.g. 1.0 or 0.5',
                onChanged: (_) => _updateSession(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
