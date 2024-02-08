import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> setItem(String key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      if (kDebugMode) {
        print("Error setting item: $e");
      }
    }
  }

  Future<String?> getItem(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString(key);
      return value;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting item: $e");
      }
      return null;
    }
  }

  Future<void> deleteItem(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting item: $e");
      }
    }
  }
}
