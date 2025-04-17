import 'package:flutter/cupertino.dart';
import 'camera_page.dart';
import 'metering_page.dart';
import 'factors_page.dart';
import 'dof_page.dart';
import 'exposure_page.dart';
import 'exposure_summary_page.dart';
import '../utils/session.dart';
import '../utils/prefs_service.dart';

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

  // Define keys to access state
  final cameraKey = GlobalKey<CameraPageState>();
  final meteringKey = GlobalKey<MeteringPageState>();
  final factorsKey = GlobalKey<FactorsPageState>();
  final dofKey = GlobalKey(); // Placeholder for future DOFPageState
  final exposureKey = GlobalKey(); // Placeholder

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
      _saveTab(_previousIndex);

      // Show summary
      if (_tabController.index == 4 && _showSummary) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tabController.index = _previousIndex;
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => ExposureSummaryPage(
                session: widget.session,
                onDone: _doneAndSave, // ✅ Add this
              ),
            ),
          );

        });
      }

      _previousIndex = _tabController.index;
    }
  }

  void _saveTab(int index) {
    switch (index) {
      case 0:
        cameraKey.currentState?.saveToSession();
        break;
      case 1:
        meteringKey.currentState?.saveToSession();
        break;
      case 2:
        factorsKey.currentState?.saveToSession();
        break;
    // Add more cases if needed
    }
  }

  void _doneAndSave() {
    _saveTab(_tabController.index);
    widget.session.timestamp = DateTime.now();
    widget.onComplete(widget.session);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: _tabController.index == 0
            ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _doneAndSave,
          child: const Text('Back'),
        )
            : null,
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
              return CameraPage(key: cameraKey, session: widget.session);
            case 1:
              return MeteringPage(key: meteringKey, session: widget.session);
            case 2:
              return FactorsPage(key: factorsKey, session: widget.session);
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
