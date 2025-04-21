import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';
import '../../utils/prefs_service.dart';
import 'exposure_flow_page.dart';
import 'exposure_summary_page.dart';

class ExposureListPage extends StatefulWidget {
  const ExposureListPage({super.key});

  @override
  State<ExposureListPage> createState() => _ExposureListPageState();
}

class _ExposureListPageState extends State<ExposureListPage> {
  List<Session> _sessions = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await PrefsService.loadSessions();
    setState(() {
      _sessions = sessions;
    });
  }

  Future<void> _saveSessions() async {
    await PrefsService.saveSessions(_sessions);
  }

  void _createNewSession() async {
    final newSession = Session(); // blank new session

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ExposureFlowPage(session: newSession),
      ),
    );

    if (newSession.title != null && newSession.film != null) {
      // save only if session was filled
      setState(() {
        _sessions.add(newSession);
      });
      _saveSessions();
    }
  }

  void _openSummary(Session session) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ExposureSummaryPage(session: session),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _deleteSession(int index) {
    setState(() {
      _sessions.removeAt(index);
    });
    _saveSessions();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('BTZS Sessions'),
        leading: GestureDetector(
          onTap: _toggleEdit,
          child: Text(_isEditing ? 'Done' : 'Edit'),
        ),
        trailing: GestureDetector(
          onTap: _createNewSession,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: _sessions.length,
          itemBuilder: (context, index) {
            final session = _sessions[index];
            return Dismissible(
              key: ValueKey(session.timestamp ?? index),
              direction: _isEditing ? DismissDirection.endToStart : DismissDirection.none,
              background: Container(color: CupertinoColors.systemRed),
              onDismissed: (_) => _deleteSession(index),
              child: CupertinoListTile(
                title: Text(session.title ?? 'Untitled'),
                subtitle: Text(session.film ?? 'No Film Selected'),
                trailing: const Icon(CupertinoIcons.right_chevron),
                onTap: () => _openSummary(session),
              ),
            );
          },
        ),
      ),
    );
  }
}
