import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/error/exceptions.dart';
import '../../models/server_config_model.dart';

class ServerConfigLocalDataSource {
  ServerConfigLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<ServerConfigModel?> getConfig() async {
    final raw = _prefs.getString(StorageKeys.serverConfig);
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ServerConfigModel.fromJson(json);
    } catch (_) {
      throw CacheException('Failed to read saved server configuration');
    }
  }

  Future<void> saveConfig(ServerConfigModel config) async {
    final success = await _prefs.setString(
      StorageKeys.serverConfig,
      jsonEncode(config.toJson()),
    );
    if (!success) {
      throw CacheException('Failed to save server configuration');
    }
  }

  Future<void> clearConfig() async {
    await _prefs.remove(StorageKeys.serverConfig);
  }
}
