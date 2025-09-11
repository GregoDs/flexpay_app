import 'dart:convert';
import 'package:flexpay/utils/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class SharedPreferencesHelper {
  static const String _userModelKey = 'user_model';
  static const String _firstLaunchKey = 'isFirstLaunch';

  // ----------------- First Launch -----------------
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  // ----------------- UserModel Handling -----------------
  static Future<void> saveUserModel(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userModel.toJson());
    await prefs.setString(_userModelKey, jsonString);
    AppLogger.log(
        '[Shared_Pref] Saved User Model is : ${jsonEncode(userModel.toJson())}');
  } 

  static Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userModelKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    } catch (e) {
    AppLogger.log('❌ SharedPreferences: failed to decode user model: $e - clearing corrupt key');
    await prefs.remove(_userModelKey);
    return null;
    }
  }

  static Future<void> clearUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userModelKey);
  }

  // ----------------- Logout -----------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userModelKey);
    print("✅ User successfully logged out");
  }
}
