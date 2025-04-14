import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/pages/preferences/camera_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/metering_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/factors_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/dof_defaults_page.dart';
import 'package:btzs_sandbox/pages/preferences/exposure_defaults_page.dart';

class DefaultsPage extends StatelessWidget {
  const DefaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme
        .of(context)
        .textTheme
        .textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Default Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            _buildNavTile(
                context, 'Camera Defaults', const CameraDefaultsPage(),
                textStyle),
            _buildNavTile(
                context, 'Metering Defaults', const MeteringDefaultsPage(),
                textStyle),
            _buildNavTile(
                context, 'Factors Defaults', const FactorsDefaultsPage(),
                textStyle),
            _buildNavTile(
                context, 'DOF Defaults', const DofDefaultsPage(), textStyle),
            _buildNavTile(
                context, 'Exposure Defaults', const ExposureDefaultsPage(),
                textStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile(BuildContext context, String title, Widget page,
      TextStyle textStyle) {
    return CupertinoListTile(
      title: Text(title, style: textStyle),
      trailing: const Icon(CupertinoIcons.forward),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => page));
      },
    );
  }
}
