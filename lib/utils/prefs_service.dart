
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // Load all settings as a map
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

  // Save a string setting
  static Future<void> saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Save a boolean setting
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Save a double setting
  static Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Load a double setting with fallback
  static Future<double> loadDouble(String key, double fallback) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? fallback;
  }

  // Save a list of filters
  static Future<void> saveFilterList(List<String> filters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('filters', filters);
  }

  // Load the list of filters
  static Future<List<String>> getFilterList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('filters') ?? ['None'];
  }

  // Optional: clear all settings
  static Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
