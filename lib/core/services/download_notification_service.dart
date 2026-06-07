import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/entities/torrent.dart';
import '../constants/app_constants.dart';

class DownloadNotificationService {
  static const String _channelId = 'torrent_downloads';
  static const String _channelName = 'Torrent downloads';
  static const String _channelDescription =
      'Shows active torrent download progress';
  static const int _progressMax = 100;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Set<String> _activeDownloadHashes = <String>{};

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);
    await _requestPermissions();
  }

  Future<void> syncDownloadNotifications(List<Torrent> torrents) async {
    final activeNow = <String>{};

    for (final torrent in torrents) {
      if (!_isActivelyDownloading(torrent)) continue;

      activeNow.add(torrent.hash);
      await _showOrUpdateDownloadNotification(torrent);
    }

    final completed = _activeDownloadHashes.difference(activeNow);
    for (final hash in completed) {
      await _plugin.cancel(_notificationId(hash));
    }

    _activeDownloadHashes
      ..clear()
      ..addAll(activeNow);
  }

  Future<void> clearAll() async {
    await _plugin.cancelAll();
    _activeDownloadHashes.clear();
  }

  Future<void> _showOrUpdateDownloadNotification(Torrent torrent) async {
    final progress = (torrent.progress * _progressMax).clamp(0, 100).round();
    final title = AppConstants.appName;
    final body = '${torrent.name}\n$progress% downloaded';

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        category: AndroidNotificationCategory.progress,
        channelShowBadge: false,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: _progressMax,
        progress: progress,
        ongoing: true,
        indeterminate: false,
        importance: Importance.low,
        priority: Priority.low,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      ),
    );

    await _plugin.show(_notificationId(torrent.hash), title, body, details);
  }

  bool _isActivelyDownloading(Torrent torrent) {
    if (torrent.progress >= 1.0) return false;
    if (torrent.dlspeed > 0) return true;
    return torrent.state == 'downloading' ||
        torrent.state == 'metaDL' ||
        torrent.state == 'forcedDL';
  }

  int _notificationId(String hash) {
    final head = hash.length >= 8 ? hash.substring(0, 8) : hash;
    final parsed = int.tryParse(head, radix: 16);
    if (parsed != null) return parsed & 0x7fffffff;
    return hash.hashCode & 0x7fffffff;
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      await ios?.requestPermissions(alert: true, badge: true, sound: false);
    }
  }
}
