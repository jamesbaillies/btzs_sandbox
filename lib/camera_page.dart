import 'package:flutter/cupertino.dart';
import '../session.dart';
import 'metering_page.dart';
import 'dof_page.dart';
import 'factors_page.dart';
import 'exposure_page.dart';

class CameraPage extends StatefulWidget {
  final Session session;

  const CameraPage({super.key, required this.session});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _tabIndex = 0;

  final List<BottomNavigationBarItem> _tabs = const [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.camera),
      label: 'Camera',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.lightbulb),
      label: 'Metering',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.scope),
      label: 'DOF',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.slider_horizontal_3),
      label: 'Factors',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.doc_text),
      label: 'Summary',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _tabs,
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildWithNav(
              const Text('Camera Settings Here'),
            );
          case 1:
            return _buildWithNav(
              MeteringPage(session: widget.session),
            );
          case 2:
            return _buildWithNav(
              DOFPage(session: widget.session),
            );
          case 3:
            return _buildWithNav(
              FactorsPage(session: widget.session),
            );
          case 4:
            return _buildWithNav(
              ExposurePage(session: widget.session),
            );
          default:
            return _buildWithNav(
              const Center(child: Text('Unknown')),
            );
        }
      },
    );
  }

  Widget _buildWithNav(Widget child) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Camera'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
