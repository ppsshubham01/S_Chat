import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// 🔹 This class handles all Hive DB operations dynamically.
/// It can store any type of data (Map, String, int, bool, etc.)
/// and can easily be extended for new features.
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelperDB {
  static bool _isInitialized = false;
  static const String userBox = 'userBox';

  static Future<void> init() async {
    if (_isInitialized) return;
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _isInitialized = true;
    Get.log('✅ Hive initialized at: ${dir.path}');
  }

  static Future<Box> openBox(String boxName) async {
    await init();
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  static Future<void> saveData(String boxName, String key, dynamic value) async {
    try {
      var box = await openBox(boxName);
      await box.put(key, value);
      Get.log('💾 Hive: Saved $key in $boxName');
    } catch (e) {
      Get.log('❌ Hive saveData error: $e');
    }
  }

  static Future<dynamic> getData(String boxName, String key) async {
    try {
      var box = await openBox(boxName);
      return box.get(key);
    } catch (e) {
      Get.log('❌ Hive getData error: $e');
      return null;
    }
  }

  static Future<void> deleteData(String boxName, String key) async {
    try {
      var box = await openBox(boxName);
      await box.delete(key);
    } catch (e) {
      Get.log('❌ Hive deleteData error: $e');
    }
  }

  static Future<void> clearBox(String boxName) async {
    try {
      var box = await openBox(boxName);
      await box.clear();
    } catch (e) {
      Get.log('❌ Hive clearBox error: $e');
    }
  }

  static Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    } catch (e) {
      Get.log('❌ Hive closeBox error: $e');
    }
  }

  /// 🔹 User Data helpers
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await saveData(userBox, 'userData', userData);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    var data = await getData(userBox, 'userData');
    if (data != null && data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  static Future<void> clearUserData() async {
    await deleteData(userBox, 'userData');
  }
}
