import 'package:flutter/cupertino.dart';
import '../utils/session.dart';
import '../utils/dof_calculator.dart';
import '../utils/styles.dart';


class DOFPage extends StatefulWidget {
  final Session session;
  const DOFPage({super.key, required this.session});

  @override
  State<DOFPage> createState() => _DOFPageState();
}

class _DOFPageState extends State<DOFPage> {
  late FixedExtentScrollController _apertureCtrl;
  late FixedExtentScrollController _distanceCtrl;
  late FixedExtentScrollController _nearCtrl;
  late FixedExtentScrollController _farCtrl;
  late FixedExtentScrollController _railCtrl;

  final List<double> apertureValues = List.generate(51, (i) => 1.0 + i * 0.5);
  final List<double> distanceValues = List.generate(201, (i) => i * 0.1);
  final List<double> railValues = List.generate(201, (i) => i * 0.1);

  @override
  void initState() {
    super.initState();
    widget.session.dofMode ??= 'None';
    widget.session.aperture ??= 5.6;
    widget.session.distance ??= 5.0;
    widget.session.railTravel ??= 0.0;
    widget.session.nearDistance ??= 1.0;
    widget.session.farDistance ??= 10.0;
    widget.session.favorDOF ??= true;

    _apertureCtrl = FixedExtentScrollController(initialItem: apertureValues.indexOf(widget.session.aperture!));
    _distanceCtrl = FixedExtentScrollController(initialItem: distanceValues.indexOf(widget.session.distance!));
    _nearCtrl = FixedExtentScrollController(initialItem: distanceValues.indexOf(widget.session.nearDistance!));
    _farCtrl = FixedExtentScrollController(initialItem: distanceValues.indexOf(widget.session.farDistance!));
    _railCtrl = FixedExtentScrollController(initialItem: railValues.indexOf(widget.session.railTravel!));
  }

  void saveToSession() {
    widget.session.timestamp = DateTime.now();
  }

  Widget _buildPicker({
    required String label,
    required FixedExtentScrollController controller,
    required List<double> values,
    required void Function(double) onChanged,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 32,
            onSelectedItemChanged: (i) => setState(() => onChanged(values[i])),
            children: values
                .map((v) => Center(child: Text('${v.toStringAsFixed(1)}${suffix ?? ''}')))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    final fl = widget.session.focalLength ?? 0.0;
    final coc = widget.session.circleOfConfusion;
    final f = widget.session.aperture ?? 5.6;
    final dist = widget.session.distance ?? 5.0;
    final near = widget.session.nearDistance ?? 1.0;
    final far = widget.session.farDistance ?? 10.0;

    if (fl <= 0) {
      return const Text(
        '⚠️ Please select a focal length on the Camera page.',
        style: kFeedbackStyle,
      );

    }

    switch (widget.session.dofMode) {
      case 'Check':
        final result = DOFCalculator.calculateFromDistance(
          focalLengthMm: fl,
          cocMm: coc ?? 0.1,
          aperture: f,
          subjectDistanceM: dist,
        );
        return _buildResultCard(result);
      case 'Distance':
        final result = DOFCalculator.calculateFromNearFar(
          focalLengthMm: fl,
          cocMm: coc ?? 0.1,
          aperture: f,
          nearDistanceM: near,
          farDistanceM: far,
        );
        return _buildResultCard(result);
      case 'Focus':
        return const Text('Focus mode not yet implemented.');
      case 'None':
      default:
        return CupertinoListTile(
          title: const Text("Favor DOF when making exposure decisions"),
          trailing: CupertinoSwitch(
            value: widget.session.favorDOF ?? true,
            onChanged: (val) => setState(() => widget.session.favorDOF = val),
          ),
        );
    }
  }

  Widget _buildResultCard(DOFResult r) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Near: ${r.near.toStringAsFixed(2)} m\n'
            'Far: ${r.far.isInfinite ? '∞' : r.far.toStringAsFixed(2)} m\n'
            'DOF: ${r.total.isInfinite ? '∞' : r.total.toStringAsFixed(2)} m\n'
            'Hyperfocal: ${r.hyperfocal.toStringAsFixed(2)} m',
        style: kFeedbackStyle,
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.session.dofMode ?? 'None';

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Depth of Field"),
      ),

      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoSegmentedControl<String>(
              groupValue: mode,
              onValueChanged: (val) => setState(() => widget.session.dofMode = val),
              children: const {
                'None': Text('None'),
                'Check': Text('Check'),
                'Distance': Text('Distance'),
                'Focus': Text('Focus'),
              },
            ),
            const SizedBox(height: 20),
            if (mode == 'Check') ...[
              _buildPicker(
                label: "Aperture",
                controller: _apertureCtrl,
                values: apertureValues,
                onChanged: (val) => widget.session.aperture = val,
              ),
              _buildPicker(
                label: "Subject Distance",
                controller: _distanceCtrl,
                values: distanceValues,
                onChanged: (val) => widget.session.distance = val,
                suffix: ' m',
              ),
            ] else if (mode == 'Distance') ...[
              _buildPicker(
                label: "Near Distance",
                controller: _nearCtrl,
                values: distanceValues,
                onChanged: (val) => widget.session.nearDistance = val,
                suffix: ' m',
              ),
              _buildPicker(
                label: "Far Distance",
                controller: _farCtrl,
                values: distanceValues,
                onChanged: (val) => widget.session.farDistance = val,
                suffix: ' m',
              ),
            ] else if (mode == 'Focus') ...[
              _buildPicker(
                label: "Rail Travel",
                controller: _railCtrl,
                values: railValues,
                onChanged: (val) => widget.session.railTravel = val,
                suffix: ' mm',
              ),
            ],
            _buildFeedback(),
          ],
        ),
      ),
    );
  }
}