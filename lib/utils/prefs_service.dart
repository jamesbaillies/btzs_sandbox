import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  /// Save a single key-value setting
  static Future<void> saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Load all relevant settings at once
  static Future<Map<String, String>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'units': prefs.getString('units') ?? 'Metric',
      'evSteps': prefs.getString('evSteps') ?? '1/10 EV',
      'showSummary': prefs.getString('showSummary') ?? 'true',
      'numberedHolders': prefs.getString('numberedHolders') ?? 'true',
      'title': prefs.getString('title') ?? '',
      'holder': prefs.getString('holder') ?? '',
      'film': prefs.getString('film') ?? 'HP5+',
      'lens': prefs.getString('lens') ?? '',
      'meteringMethod': prefs.getString('meteringMethod') ?? 'Incident',
      'loZone': prefs.getString('loZone') ?? '3.0',
      'hiZone': prefs.getString('hiZone') ?? '7.0',
      'selectedFilter': prefs.getString('selectedFilter') ?? 'None',
      'exposureAdjustment': prefs.getString('exposureAdjustment') ?? 'none',
    };
  }

  /// Save a list of filters to preferences
  static Future<void> saveFilterList(List<String> filters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('filterList', filters);
  }

  /// Load the list of filters from preferences
  static Future<List<String>> getFilterList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('filterList') ?? ['None'];
  }

  /// Optionally clear all saved preferences (for reset/debug)
  static Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}