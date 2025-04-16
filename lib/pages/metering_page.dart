import 'package:flutter/cupertino.dart';
import '../utils/session.dart';

class MeteringPage extends StatefulWidget {
  final Session session;

  const MeteringPage({super.key, required this.session});

  @override
  State<MeteringPage> createState() => MeteringPageState();
}

class MeteringPageState extends State<MeteringPage> {
  late FixedExtentScrollController _loEvCtrl;
  late FixedExtentScrollController _hiEvCtrl;
  late FixedExtentScrollController _loZoneCtrl;
  late FixedExtentScrollController _hiZoneCtrl;
  late TextEditingController _notesController;

  final List<double> evValues = List.generate(81, (i) => -10 + i * 0.25);
  final List<double> zoneValues = List.generate(101, (i) => i * 0.1);

  @override
  void initState() {
    super.initState();

    widget.session.meteringMethod ??= 'Incident';
    widget.session.loEv ??= 0.0;
    widget.session.hiEv ??= 0.0;
    widget.session.loZone ??= 3.0;
    widget.session.hiZone ??= 7.0;
    widget.session.meteringNotes ??= '';

    _loEvCtrl = FixedExtentScrollController(initialItem: evValues.indexOf(widget.session.loEv!));
    _hiEvCtrl = FixedExtentScrollController(initialItem: evValues.indexOf(widget.session.hiEv!));
    _loZoneCtrl = FixedExtentScrollController(initialItem: zoneValues.indexOf(widget.session.loZone!));
    _hiZoneCtrl = FixedExtentScrollController(initialItem: zoneValues.indexOf(widget.session.hiZone!));

    _notesController = TextEditingController(text: widget.session.meteringNotes);
  }

  void saveToSession() {
    widget.session.timestamp = DateTime.now();
    widget.session.meteringNotes = _notesController.text;
  }

  String get feedback {
    final loEv = widget.session.loEv!;
    final hiEv = widget.session.hiEv!;
    final sbr = (hiEv - loEv).toStringAsFixed(1);

    if (widget.session.meteringMethod == 'Incident') {
      return "SBR ($sbr) exceeds film's range";
    } else {
      if (widget.session.loZone! >= widget.session.hiZone!) {
        return "Invalid metering choices";
      }
      return "SBR ($sbr)";
    }
  }

  Widget _buildPicker(String label, double currentValue, List<double> values,
      ValueChanged<double> onChanged, FixedExtentScrollController controller) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: CupertinoColors.white)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 32,
            onSelectedItemChanged: (i) => setState(() => onChanged(values[i])),
            children: values.map((v) => Center(child: Text(v.toStringAsFixed(1)))).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final method = widget.session.meteringMethod!;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Metering"),
      ),

      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoSegmentedControl<String>(
              groupValue: method,
              onValueChanged: (val) =>
                  setState(() => widget.session.meteringMethod = val),
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPicker(
                    "Lo EV",
                    widget.session.loEv!,
                    evValues,
                        (v) => widget.session.loEv = v,
                    _loEvCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPicker(
                    "Hi EV",
                    widget.session.hiEv!,
                    evValues,
                        (v) => widget.session.hiEv = v,
                    _hiEvCtrl,
                  ),
                ),
              ],
            ),
            if (method == 'Zone') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPicker(
                      "Lo Zone",
                      widget.session.loZone!,
                      zoneValues,
                          (v) => widget.session.loZone = v,
                      _loZoneCtrl,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPicker(
                      "Hi Zone",
                      widget.session.hiZone!,
                      zoneValues,
                          (v) => widget.session.hiZone = v,
                      _hiZoneCtrl,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                feedback,
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _notesController,
              placeholder: "Metering Notes",
            ),
          ],
        ),
      ),
    );
  }
}
