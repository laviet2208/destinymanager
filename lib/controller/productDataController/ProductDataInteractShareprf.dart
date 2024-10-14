import 'package:shared_preferences/shared_preferences.dart';

class ProductDataInteractShareprf {
  /// This class was born only contain functions for interact between shared preference with product's data
  /// WriteStringData
  static Future<void> WriteStringData(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  /// GetStringData
  static Future<String> GetStringData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('key');
    return data != null ? data : '';
  }
}