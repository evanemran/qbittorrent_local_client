import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';

class ThemeController extends GetxController {
  ThemeController({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    final storedMode = _sharedPreferences.getString(StorageKeys.themeMode);
    themeMode.value = _parseThemeMode(storedMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _sharedPreferences.setString(StorageKeys.themeMode, mode.name);
    Get.changeThemeMode(mode);
  }

  Future<void> setDarkMode(bool enable) async {
    final mode = enable ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(mode);
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
