import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:btzs_sandbox/settings_page.dart';
import 'package:btzs_sandbox/utils/session.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';
import 'package:btzs_sandbox/pages/exposure_flow_page.dart';

class ExposureListPage extends StatefulWidget {
  const ExposureListPage({super.key});

  @override
  State<ExposureListPage> createState() => _ExposureListPageState();
}

class _ExposureListPageState extends State<ExposureListPage> {
  List<Session> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final loaded = await PrefsService.loadSessions();
    setState(() => _sessions = loaded);
  }

  Future<void> _saveSessions() async {
    await PrefsService.saveSessions(_sessions);
  }

  void _addSession(Session session) {
    setState(() {
      _sessions.add(session);
    });
    _saveSessions();
  }

  void _openExposureFlow() {
    final session = Session();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ExposureFlowPage(
          session: session,
          onComplete: (completedSession) {
            _addSession(completedSession);
          },
        ),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat.jm();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Exposures'),
        trailing: GestureDetector(
          onTap: _openExposureFlow,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _sessions.isEmpty
                  ? const Center(child: Text('No exposures yet'))
                  : ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  final date = dateFormat.format(session.timestamp);
                  final time = timeFormat.format(session.timestamp);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.exposureTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Holder: ${session.filmHolder}'),
                        Text('Film: ${session.filmStock}'),
                        Text('Focal Length: ${session.focalLength}'),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('📅 $date'),
                            Text('🕒 $time'),
                          ],
                        ),
                        Container(height: 1, color: CupertinoColors.separator),

                      ],
                    ),
                  );
                },
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(bottom: 16),
              onPressed: _openSettings,
              child: const Icon(CupertinoIcons.gear),
            ),
          ],
        ),
      ),
    );
  }
}
