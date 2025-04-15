// lib/pages/exposure_flow_page.dart

import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/pages/camera_page.dart';
import 'package:btzs_sandbox/pages/metering_page.dart';
import 'package:btzs_sandbox/pages/factors_page.dart';
import 'package:btzs_sandbox/pages/dof_page.dart';
import 'package:btzs_sandbox/pages/exposure_page.dart';
import 'package:btzs_sandbox/pages/exposure_summary_page.dart';
import 'package:btzs_sandbox/utils/session.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class ExposureFlowPage extends StatefulWidget {
  final Session session;
  final void Function(Session) onComplete;

  const ExposureFlowPage({
    super.key,
    required this.session,
    required this.onComplete,
  });

  @override
  State<ExposureFlowPage> createState() => _ExposureFlowPageState();
}

class _ExposureFlowPageState extends State<ExposureFlowPage> {
  late CupertinoTabController _tabController;
  int _previousIndex = 0;
  bool _showSummary = true;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
    _tabController.addListener(_onTabChanged);
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await PrefsService.loadSettings();
    setState(() {
      _showSummary = prefs['showSummary'] ?? true;
    });
  }

  void _onTabChanged() {
    if (_tabController.index != _previousIndex) {
      _saveCurrentTabSettings(_previousIndex);

      if (_tabController.index == 4 && _showSummary) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tabController.index = _previousIndex;
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => ExposureSummaryPage(session: widget.session),
            ),
          );
        });
      }

      _previousIndex = _tabController.index;
    }
  }

  void _saveCurrentTabSettings(int index) {
    // Optional: Add logic per tab index if needed
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _doneAndSave() {
    widget.session.timestamp = DateTime.now();
    widget.onComplete(widget.session);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _doneAndSave,
          child: const Text('Back'),
        ),
        middle: const Text('Exposure Flow'),
      ),
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Camera'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.lightbulb), label: 'Metering'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.slider_horizontal_3), label: 'Factors'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.viewfinder), label: 'DOF'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.time), label: 'Exposure'),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CameraPage(session: widget.session);
            case 1:
              return MeteringPage(session: widget.session);
            case 2:
              return FactorsPage(session: widget.session);
            case 3:
              return DOFPage(session: widget.session);
            case 4:
              return ExposurePage(session: widget.session);
            default:
              return const Center(child: Text('Unknown Tab'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }
}
