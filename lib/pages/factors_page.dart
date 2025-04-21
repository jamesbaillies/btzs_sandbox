import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';

class FactorsPage extends StatefulWidget {
  final Session session;

  const FactorsPage({
    super.key,
    required this.session,
  });

  @override
  State<FactorsPage> createState() => _FactorsPageState();
}

class _FactorsPageState extends State<FactorsPage> {
  late TextEditingController _filterController;
  late TextEditingController _bellowsController;
  late TextEditingController _totalFactorController;

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController(text: widget.session.filter ?? '');
    _bellowsController = TextEditingController(
        text: widget.session.bellowsValue?.toString() ?? '');
    _totalFactorController = TextEditingController(
        text: widget.session.totalExposureFactor?.toString() ?? '');
  }

  @override
  void dispose() {
    _filterController.dispose();
    _bellowsController.dispose();
    _totalFactorController.dispose();
    super.dispose();
  }

  void _updateSession() {
    setState(() {
      widget.session.filter = _filterController.text;
      widget.session.bellowsValue = double.tryParse(_bellowsController.text);
      widget.session.totalExposureFactor = double.tryParse(_totalFactorController.text);
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
              const Text('Filter Used'),
              CupertinoTextField(
                controller: _filterController,
                placeholder: 'e.g. Yellow 8',
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('Bellows Factor'),
              CupertinoTextField(
                controller: _bellowsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
              const SizedBox(height: 16),
              const Text('Total Exposure Factor'),
              CupertinoTextField(
                controller: _totalFactorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateSession(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
