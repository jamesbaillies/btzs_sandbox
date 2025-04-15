import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';

class PrefsService {
  // ✅ Singleton instance for .instance usage
  static final PrefsService instance = PrefsService._internal();
  PrefsService._internal();

  // ✅ Load all app settings into a Map
  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'units': prefs.getString('units') ?? 'Metric',
      'evSteps': prefs.getString('evSteps') ?? '1/10 EV',
      'showSummary': prefs.getBool('showSummary') ?? true,
      'numberedHolders': prefs.getBool('numberedHolders') ?? true,
      'defaultFilm': prefs.getString('defaultFilm') ?? 'Not Set',
      'defaultFocalLength': prefs.getString('defaultFocalLength') ?? 'Not Set',
      'defaultFlareFactor': prefs.getDouble('defaultFlareFactor') ?? 0.02,
      'defaultPaperES': prefs.getDouble('defaultPaperES') ?? 1.05,
      'meteringMethod': prefs.getString('meteringMethod') ?? 'Incident',
      'loZone': prefs.getDouble('loZone') ?? 3.0,
      'hiZone': prefs.getDouble('hiZone') ?? 7.0,
      'selectedFilter': prefs.getString('selectedFilter') ?? 'None',
      'exposureAdjustment': prefs.getString('exposureAdjustment') ?? 'none',
      'coc': prefs.getDouble('coc') ?? 0.1,
      'favorDOF': prefs.getBool('favorDOF') ?? false,
      'useOptimalAperture': prefs.getBool('useOptimalAperture') ?? false,
      'exposureMode': prefs.getString('exposureMode') ?? 'Aperture',
    };
  }

  // ✅ Save a single string setting
  static Future<void> saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // ✅ Save a single boolean setting
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // ✅ Save a single double setting
  static Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // ✅ Load a double with fallback
  static Future<double> loadDouble(String key, double fallback) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? fallback;
  }

  // ✅ Filter list support
  static Future<void> saveFilterList(List<String> filters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('filters', filters);
  }

  Future<List<String>> getFilterList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('filters') ??
        ['None', 'Light Yellow 3', 'Yellow 8', 'Orange 21']; // Default filters
  }

  // ✅ Session persistence
  static Future<void> saveSessions(List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('sessions', encoded);
  }

  static Future<List<Session>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList('sessions') ?? [];
    return encoded.map((s) => Session.fromJson(jsonDecode(s))).toList();
  }

  // ✅ Optional: wipe everything
  static Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
