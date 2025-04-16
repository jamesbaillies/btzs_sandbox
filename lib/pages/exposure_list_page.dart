import 'package:flutter/cupertino.dart';
import '../utils/session.dart';
import '../utils/prefs_service.dart';
import '/settings_page.dart'; // Ensure this import path is correct
import 'exposure_flow_page.dart';

class ExposureListPage extends StatefulWidget {
  const ExposureListPage({super.key});

  @override
  State<ExposureListPage> createState() => _ExposureListPageState();
}

class _ExposureListPageState extends State<ExposureListPage> {
  List<Session> _sessions = [];
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await PrefsService.loadSessions();
    setState(() => _sessions = prefs);
  }

  Future<void> _saveSessions() async {
    await PrefsService.saveSessions(_sessions);
  }

  void _toggleEdit() {
    setState(() => _editMode = !_editMode);
  }

  void _deleteSession(int index) {
    setState(() => _sessions.removeAt(index));
    _saveSessions();
  }

  void _addNewSession() {
    final newSession = Session(exposureTitle: "New Session");
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ExposureFlowPage(
          session: newSession,
          onComplete: (updated) {
            setState(() => _sessions.add(updated));
            _saveSessions();
          },
        ),
      ),
    );
  }

  Widget _buildSessionTile(Session session, int index) {
    return Row(
      children: [
        if (_editMode)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.systemRed),
              onPressed: () => _deleteSession(index),
            ),
          ),
        Expanded(
          child: CupertinoListTile(
            title: Text(session.exposureTitle ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Holder: ${session.filmHolder ?? '—'}"),
                Text("Develop: ${session.filmStock ?? ''} @ 70.00F for 4m 30s"), // Sample dev string
              ],
            ),
            trailing: Text(session.timestamp?.toString().split(' ').first ?? ''),
            onTap: () {
              if (!_editMode) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ExposureFlowPage(
                      session: session,
                      onComplete: (updated) {
                        setState(() => _sessions[index] = updated);
                        _saveSessions();
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Exposures'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(_editMode ? 'Done' : 'Edit'),
          onPressed: _toggleEdit,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: _addNewSession,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: _sessions.length,
              itemBuilder: (context, index) =>
                  _buildSessionTile(_sessions[index], index),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Icon(CupertinoIcons.gear),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
                  CupertinoButton(
                    child: const Icon(CupertinoIcons.info),
                    onPressed: () {
                      // Info action (optional)
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
