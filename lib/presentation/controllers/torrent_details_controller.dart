import 'dart:async';

import 'package:get/get.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/torrent.dart';
import '../../../domain/entities/torrent_file_entry.dart';
import '../../../domain/entities/torrent_peer.dart';
import '../../../domain/entities/torrent_properties.dart';
import '../../../domain/entities/torrent_tracker.dart';
import '../../../domain/usecases/torrent_usecases.dart';

class TorrentDetailsArgs {
  TorrentDetailsArgs({required this.torrent});

  final Torrent torrent;
}

Torrent? torrentDetailsFromArgs(dynamic args) {
  if (args is TorrentDetailsArgs) return args.torrent;
  if (args is Torrent) return args;
  return null;
}

class TorrentDetailsController extends GetxController {
  TorrentDetailsController({
    required GetTorrentProperties getTorrentProperties,
    required GetTorrentFiles getTorrentFiles,
    required GetTorrentTrackers getTorrentTrackers,
    required GetTorrentPeers getTorrentPeers,
  })  : _getTorrentProperties = getTorrentProperties,
        _getTorrentFiles = getTorrentFiles,
        _getTorrentTrackers = getTorrentTrackers,
        _getTorrentPeers = getTorrentPeers;

  final GetTorrentProperties _getTorrentProperties;
  final GetTorrentFiles _getTorrentFiles;
  final GetTorrentTrackers _getTorrentTrackers;
  final GetTorrentPeers _getTorrentPeers;

  late Torrent torrent;

  final Rxn<TorrentProperties> properties = Rxn<TorrentProperties>();
  final RxList<TorrentFileEntry> files = <TorrentFileEntry>[].obs;
  final RxList<TorrentTracker> trackers = <TorrentTracker>[].obs;
  final RxList<TorrentPeer> peers = <TorrentPeer>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString errorMessage = RxnString();

  Timer? _pollTimer;

  String get hash => torrent.hash;
  String get torrentName => torrent.name;

  @override
  void onInit() {
    super.onInit();
    final argsTorrent = torrentDetailsFromArgs(Get.arguments);
    if (argsTorrent == null) {
      Get.back();
      return;
    }
    torrent = argsTorrent;
    _loadDetails(showLoader: true);
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isLoading.value) {
        _loadDetails();
      }
    });
  }

  Future<void> _loadDetails({bool showLoader = false}) async {
    if (showLoader) isLoading.value = true;
    isRefreshing.value = !showLoader;

    try {
      final results = await Future.wait([
        _getTorrentProperties(hash),
        _getTorrentFiles(hash),
        _getTorrentTrackers(hash),
        _getTorrentPeers(hash),
      ]);

      properties.value = results[0] as TorrentProperties;
      files.assignAll(results[1] as List<TorrentFileEntry>);
      trackers.assignAll(results[2] as List<TorrentTracker>);
      peers.assignAll(results[3] as List<TorrentPeer>);
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

  @override
  Future<void> refresh() => _loadDetails(showLoader: true);

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
