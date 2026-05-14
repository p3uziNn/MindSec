import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppSelectionService {

  static const String key =
      "selected_monitored_apps";

  static Future<void> saveSelectedApps(
    List<String> packageNames,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      key,
      jsonEncode(packageNames),
    );
  }

  static Future<List<String>>
      getSelectedApps() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) return [];

    final List<dynamic> decoded =
        jsonDecode(data);

    return decoded.cast<String>();
  }
}