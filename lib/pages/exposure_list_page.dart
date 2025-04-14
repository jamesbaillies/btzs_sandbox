import 'package:flutter/cupertino.dart';
import 'camera_page.dart';
import 'package:btzs_sandbox/settings_page.dart';
import 'package:btzs_sandbox/utils/session.dart';



class ExposureListPage extends StatelessWidget {
  const ExposureListPage({super.key});

  void _openCameraPage(BuildContext context) {
    final newSession = Session(); // ✅ Create a new session to pass in
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => CameraPage(session: newSession),
      ),
    );
  }

  void _openPreferencesPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const SettingsPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Exposures'),
        trailing: GestureDetector(
          onTap: () => _openCameraPage(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(child: Text('No exposures yet')),
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(bottom: 16),
              onPressed: () => _openPreferencesPage(context),
              child: const Icon(CupertinoIcons.gear),
            ),
          ],
        ),
      ),
    );
  }
}
