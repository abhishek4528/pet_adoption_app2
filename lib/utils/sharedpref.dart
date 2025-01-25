import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _prefHelper;
  static String adoptedPetsIds = "adoptedPetsIds";
  static String isDarkMode = 'isDarkMode';

  static SharedPref? getInstance() {
    _prefHelper ??= SharedPref();
    return _prefHelper;
  }

  static SharedPreferences? prefs;
  static final Map<String, dynamic> _memoryPrefs = <String, dynamic>{};

  static Future<SharedPreferences?> load() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }
  static Future<bool> clearPref() async {
    bool clear = await prefs!.clear();
    if (clear) {
      _memoryPrefs.clear();
    }
    return clear;
  }


  static Future<bool> clearKeyPref(String key) async {
    bool clear = await prefs!.remove(key);
    if (clear) {
      _memoryPrefs.remove(key);
    }
    return clear;
  }
  

  static void setListString(String key, List<String> value) {
    prefs?.setStringList(key, value);
    _memoryPrefs[key] = value;
  }


  static List<String> getListString(String key, {List<String>? def}) {
    List<String>? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= prefs!.getStringList(key);
    val ??= def ?? [];
    _memoryPrefs[key] = val;
    return val;
  }

  static void setBool(String key, bool value) {
    prefs?.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  static bool getBool(String key, {bool? def = false}) {
    bool? val = def;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (prefs == null) {
      return val!;
    }
    val = prefs!.getBool(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val!;
  }
}