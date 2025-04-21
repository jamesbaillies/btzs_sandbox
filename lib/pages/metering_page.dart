import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';

class MeteringPage extends StatefulWidget {
  final Session session;

  const MeteringPage({
    super.key,
    required this.session,
  });

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  late TextEditingController _loEvController;
  late TextEditingController _hiEvController;
  late TextEditingController _loZoneController;
  late TextEditingController _hiZoneController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _loEvController = TextEditingController(text: widget.session.loEv?.toString() ?? '');
    _hiEvController = TextEditingController(text: widget.session.hiEv?.toString() ?? '');
    _loZoneController = TextEditingController(text: widget.session.loZone?.toString() ?? '');
    _hiZoneController = TextEditingController(text: widget.session.hiZone?.toString() ?? '');
    _notesController = TextEditingController(text: widget.session.meteringNotes ?? '');
  }

  @override
  void dispose() {
    _loEvController.dispose();
    _hiEvController.dispose();
    _loZoneController.dispose();
    _hiZoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateSession() {
    setState(() {
      widget.session.loEv = double.tryParse(_loEvController.text);
      widget.session.hiEv = double.tryParse(_hiEvController.text);
      widget.session.loZone = double.tryParse(_loZoneController.text);
      widget.session.hiZone = double.tryParse(_hiZoneController.text);
      widget.session.meteringNotes = _notesController.text;
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
              const Text('Low EV'),
              CupertinoTextField(
                controller: _loEvController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('High EV'),
              CupertinoTextField(
                controller: _hiEvController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('Low Zone'),
              CupertinoTextField(
                controller: _loZoneController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('High Zone'),
              CupertinoTextField(
                controller: _hiZoneController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('Metering Notes'),
              CupertinoTextField(
                controller: _notesController,
                maxLines: 4,
                onChanged: (_) => _updateSession(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
