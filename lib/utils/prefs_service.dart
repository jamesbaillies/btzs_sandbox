import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';

class PrefsService {
  // Keys
  static const _sessionKey = 'btzs_sessions';
  static const _meteringKey = 'metering_defaults';
  static const _globalSettingsKey = 'global_settings';
  static const _factorsKey = 'factors_defaults';

  // 🟢 EXPOSURE SESSIONS

  static Future<List<Session>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_sessionKey);
    if (jsonString == null) return [];

    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((e) => Session.fromJson(e)).toList();
  }

  static Future<void> saveSessions(List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(sessions.map((e) => e.toJson()).toList());
    await prefs.setString(_sessionKey, encoded);
  }

  static Future<void> saveSession(Session session) async {
    final sessions = await loadSessions();
    sessions.add(session);
    await saveSessions(sessions);
  }

  static Future<void> clearSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  // 🟡 METERING DEFAULTS

  static Future<Map<String, dynamic>> loadMeteringDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_meteringKey);
    if (jsonString == null) return {};
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> saveMeteringDefaults(Map<String, dynamic> values) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(values);
    await prefs.setString(_meteringKey, encoded);
  }

  // ⚙️ GLOBAL SETTINGS

  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_globalSettingsKey);
    if (jsonString == null) return {};
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadSettings();
    current[key] = value;
    final encoded = json.encode(current);
    await prefs.setString(_globalSettingsKey, encoded);
  }

  // 📐 FACTORS DEFAULTS

  static Future<Map<String, dynamic>> loadFactorsDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_factorsKey);
    if (jsonString == null) return {};
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> saveFactorsDefaults(Map<String, dynamic> values) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(values);
    await prefs.setString(_factorsKey, encoded);
  }
  static const _filterListKey = 'filter_list';

  static Future<List<String>> loadFilterList() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_filterListKey);
    return list ?? [];
  }

  static Future<void> saveFilterList(List<String> filters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_filterListKey, filters);
  }

}
