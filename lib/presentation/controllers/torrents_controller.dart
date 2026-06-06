import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/torrent.dart';
import '../../../domain/entities/torrent_filter.dart';
import '../../../domain/usecases/clear_server_config.dart';
import '../../../domain/usecases/get_server_config.dart';
import '../../../domain/usecases/torrent_usecases.dart';
import '../../app/routes/app_routes.dart';
import 'splash_controller.dart';

class TorrentsController extends GetxController {
  TorrentsController({
    required GetServerConfig getServerConfig,
    required GetTorrents getTorrents,
    required PauseTorrents pauseTorrents,
    required ResumeTorrents resumeTorrents,
    required DeleteTorrents deleteTorrents,
    required Logout logout,
    required ClearServerConfig clearServerConfig,
  })  : _getServerConfig = getServerConfig,
        _getTorrents = getTorrents,
        _pauseTorrents = pauseTorrents,
        _resumeTorrents = resumeTorrents,
        _deleteTorrents = deleteTorrents,
        _logout = logout,
        _clearServerConfig = clearServerConfig;

  final GetServerConfig _getServerConfig;
  final GetTorrents _getTorrents;
  final PauseTorrents _pauseTorrents;
  final ResumeTorrents _resumeTorrents;
  final DeleteTorrents _deleteTorrents;
  final Logout _logout;
  final ClearServerConfig _clearServerConfig;

  final RxList<Torrent> torrents = <Torrent>[].obs;
  final Rx<TorrentFilter> selectedFilter = TorrentFilter.all.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString searchQuery = ''.obs;
  final RxnString errorMessage = RxnString();
  final RxnString serverName = RxnString();
  final RxnString serverHost = RxnString();
  final RxnString username = RxnString();
  final RxnString serverVersion = RxnString();

  Timer? _pollTimer;

  List<Torrent> get filteredTorrents {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return torrents;
    return torrents
        .where((t) => t.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadServerInfo();
    _startPolling();
    refreshTorrents(showLoader: true);
  }

  Future<void> _loadServerInfo() async {
    final args = Get.arguments;
    final config = splashConfigFromArgs(args) ?? await _getServerConfig();
    if (config != null) {
      serverName.value = config.name;
      serverHost.value = '${config.host}:${config.port}';
      username.value = config.username;
    }
    final versionFromArgs = splashVersionFromArgs(args);
    if (versionFromArgs != null) {
      serverVersion.value = versionFromArgs;
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isLoading.value) {
        refreshTorrents();
      }
    });
  }

  Future<void> refreshTorrents({bool showLoader = false}) async {
    if (showLoader) isLoading.value = true;
    isRefreshing.value = !showLoader;

    try {
      final result = await _getTorrents(selectedFilter.value);
      torrents.assignAll(result);
      errorMessage.value = null;
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> changeFilter(TorrentFilter filter) async {
    selectedFilter.value = filter;
    await refreshTorrents(showLoader: true);
  }

  Future<void> togglePause(Torrent torrent) async {
    try {
      if (torrent.isPaused) {
        await _resumeTorrents([torrent.hash]);
      } else {
        await _pauseTorrents([torrent.hash]);
      }
      await refreshTorrents();
    } on Failure catch (e) {
      Get.snackbar('Action failed', e.message);
    }
  }

  Future<void> deleteTorrent(Torrent torrent) async {
    final deleteFiles = await Get.dialog<bool?>(
      AlertDialog(
        title: const Text('Remove torrent'),
        content: Text('Remove "${torrent.name}" from qBittorrent?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove torrent only'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Remove with files'),
          ),
        ],
      ),
    );

    if (deleteFiles == false) return;

    try {
      await _deleteTorrents(
        [torrent.hash],
        deleteFiles: deleteFiles == null,
      );
      await refreshTorrents();
    } on Failure catch (e) {
      Get.snackbar('Delete failed', e.message);
    }
  }

  void goHome() {
    selectedFilter.value = TorrentFilter.all;
    searchQuery.value = '';
    refreshTorrents(showLoader: true);
  }

  Future<void> goToSettings() async {
    await Get.toNamed(AppRoutes.setup);
    await _loadServerInfo();
  }

  Future<void> disconnect() async {
    await _logout();
    await _clearServerConfig();
    Get.offAllNamed(AppRoutes.setup);
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
