import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';
import 'camera_page.dart';
import 'metering_page.dart';
import 'factors_page.dart';
import 'dof_page.dart';
import 'exposure_page.dart';
import 'exposure_summary_page.dart';

class ExposureFlowPage extends StatefulWidget {
  final Session session;

  const ExposureFlowPage({
    super.key,
    required this.session,
  });

  @override
  State<ExposureFlowPage> createState() => ExposureFlowPageState();
}

class ExposureFlowPageState extends State<ExposureFlowPage> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _goToSummary() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ExposureSummaryPage(
          session: widget.session,
        ),
      ),
    );
  }

  void _handleCancel() {
    Navigator.of(context).pop(); // Return to Exposure List Page
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Exposure Flow'),
        leading: GestureDetector(
          onTap: _handleCancel,
          child: const Text('Cancel'),
        ),
        trailing: GestureDetector(
          onTap: _goToSummary,
          child: const Text('Summary'),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CameraPage(session: widget.session),
                MeteringPage(session: widget.session),
                FactorsPage(session: widget.session),
                DOFPage(session: widget.session),
                ExposurePage(session: widget.session),
              ],
            ),
          ),
          CupertinoTabBar(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.camera),
                label: 'Camera',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.lightbulb),
                label: 'Metering',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings),
                label: 'Factors',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.viewfinder),
                label: 'DOF',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.timer),
                label: 'Exposure',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
