import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';
import 'package:btzs_sandbox/utils/session.dart';

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
    setState(() {
      _sessions = loaded;
    });
  }

  void _addNewSession() {
    final newSession = Session(exposureTitle: "New Session");
    setState(() => _sessions.add(newSession));
    PrefsService.saveSessions(_sessions);
  }

  Widget _buildSessionTile(Session session) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Navigate to ExposureFlowPage
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: CupertinoColors.systemGrey6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.exposureTitle ?? 'Untitled',
                        style: const TextStyle(
                            fontSize: 16, color: CupertinoColors.black)),
                    Text(session.filmStock ?? 'No film selected',
                        style: const TextStyle(
                            fontSize: 13, color: CupertinoColors.systemGrey)),
                  ],
                ),
                const Icon(CupertinoIcons.forward),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: CupertinoColors.separator,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exposure List'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  return _buildSessionTile(_sessions[index]);
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Add New Exposure'),
              onPressed: _addNewSession,
            ),
          ],
        ),
      ),
    );
  }
}
