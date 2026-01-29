import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {
  static const Duration defaultCacheDuration = Duration(hours: 1);

  static Future<void> cacheData(String key, dynamic data, {Duration? duration}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryTime = DateTime.now().add(duration ?? defaultCacheDuration);
      
      final cacheData = {
        'data': data,
        'expiry': expiryTime.toIso8601String(),
      };
      
      await prefs.setString(key, jsonEncode(cacheData));
    } catch (e) {
      // Silent fail - caching is optional
    }
  }

  static Future<dynamic> getCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(key);
      
      if (cachedString == null) return null;
      
      final cacheData = jsonDecode(cachedString);
      final expiryTime = DateTime.parse(cacheData['expiry']);
      
      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired
        await prefs.remove(key);
        return null;
      }
      
      return cacheData['data'];
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      // Silent fail
    }
  }

  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (!key.startsWith('token') && !key.startsWith('user')) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      // Silent fail
    }
  }
}
