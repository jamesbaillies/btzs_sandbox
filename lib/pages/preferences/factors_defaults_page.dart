import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class FactorsDefaultsPage extends StatefulWidget {
  const FactorsDefaultsPage({super.key});

  @override
  State<FactorsDefaultsPage> createState() => _FactorsDefaultsPageState();
}

class _FactorsDefaultsPageState extends State<FactorsDefaultsPage> {
  late TextEditingController _filterController;
  late TextEditingController _bellowsController;
  late TextEditingController _totalFactorController;

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
    _bellowsController = TextEditingController();
    _totalFactorController = TextEditingController();
    _loadDefaults();
  }

  @override
  void dispose() {
    _filterController.dispose();
    _bellowsController.dispose();
    _totalFactorController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaults() async {
    final defaults = await PrefsService.loadFactorsDefaults();
    if (!mounted) return;
    setState(() {
      _filterController.text = defaults['filter'] ?? '';
      _bellowsController.text = (defaults['bellowsFactor'] ?? '').toString();
      _totalFactorController.text = (defaults['totalFactor'] ?? '').toString();
    });
  }

  Future<void> _saveDefaults() async {
    await PrefsService.saveFactorsDefaults({
      'filter': _filterController.text,
      'bellowsFactor': double.tryParse(_bellowsController.text) ?? 1.0,
      'totalFactor': double.tryParse(_totalFactorController.text) ?? 1.0,
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        CupertinoTextField(
          controller: controller,
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          onChanged: (_) => _saveDefaults(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Factors Defaults'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Filter Used", _filterController),
              _buildTextField("Bellows Factor", _bellowsController, isNumeric: true),
              _buildTextField("Total Exposure Factor", _totalFactorController, isNumeric: true),
            ],
          ),
        ),
      ),
    );
  }
}
