import '../../../core/error/exceptions.dart';
import '../../../core/network/qbittorrent_api_client.dart';
import '../../../domain/entities/server_config.dart';
import '../../models/torrent_details_models.dart';
import '../../models/torrent_model.dart';

class QbittorrentRemoteDataSource {
  QbittorrentRemoteDataSource(this._apiClient);

  final QbittorrentApiClient _apiClient;

  ServerConfig? get config => _apiClient.config;

  Future<void> configure(ServerConfig config) => _apiClient.configure(config);

  Future<String> login(String username, String password) async {
    try {
      await _apiClient.login(username, password);
      return _apiClient.getVersion();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Could not connect to qBittorrent: $e');
    }
  }

  Future<void> logout() => _apiClient.logout();

  Future<List<TorrentModel>> getTorrents({required String filter}) async {
    try {
      final items = await _apiClient.getTorrents(filter: filter);
      return items.map(TorrentModel.fromJson).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load torrents: $e');
    }
  }

  Future<void> addTorrentFromUrl(String url) => _apiClient.addTorrentFromUrl(url);

  Future<void> addTorrentFromFile(List<int> bytes, String filename) =>
      _apiClient.addTorrentFromFile(bytes, filename);

  Future<void> pauseTorrents(List<String> hashes) =>
      _apiClient.pauseTorrents(hashes);

  Future<void> resumeTorrents(List<String> hashes) =>
      _apiClient.resumeTorrents(hashes);

  Future<void> deleteTorrents(List<String> hashes, {bool deleteFiles = false}) =>
      _apiClient.deleteTorrents(hashes, deleteFiles: deleteFiles);

  Future<TorrentPropertiesModel> getTorrentProperties(String hash) async {
    try {
      final json = await _apiClient.getTorrentProperties(hash);
      return TorrentPropertiesModel.fromJson(json);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load torrent properties: $e');
    }
  }

  Future<List<TorrentFileEntryModel>> getTorrentFiles(String hash) async {
    try {
      final items = await _apiClient.getTorrentFiles(hash);
      return items.map(TorrentFileEntryModel.fromJson).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load torrent files: $e');
    }
  }

  Future<List<TorrentTrackerModel>> getTorrentTrackers(String hash) async {
    try {
      final items = await _apiClient.getTorrentTrackers(hash);
      return items.map(TorrentTrackerModel.fromJson).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load torrent trackers: $e');
    }
  }

  Future<List<TorrentPeerModel>> getTorrentPeers(String hash) async {
    try {
      final json = await _apiClient.getTorrentPeers(hash);
      final peers = json['peers'];
      if (peers is! Map) return [];

      return peers.entries
          .map(
            (entry) => TorrentPeerModel.fromMap(
              entry.key.toString(),
              Map<String, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to load torrent peers: $e');
    }
  }
}
