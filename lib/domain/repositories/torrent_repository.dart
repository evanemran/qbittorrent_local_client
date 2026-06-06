import '../entities/server_config.dart';
import '../entities/torrent.dart';
import '../entities/torrent_file_entry.dart';
import '../entities/torrent_filter.dart';
import '../entities/torrent_peer.dart';
import '../entities/torrent_properties.dart';
import '../entities/torrent_tracker.dart';

abstract class TorrentRepository {
  Future<void> connect(ServerConfig config);
  Future<String> login();
  Future<void> logout();
  Future<List<Torrent>> getTorrents(TorrentFilter filter);
  Future<void> addTorrentFromUrl(String url);
  Future<void> addTorrentFromFile(List<int> bytes, String filename);
  Future<void> pauseTorrents(List<String> hashes);
  Future<void> resumeTorrents(List<String> hashes);
  Future<void> deleteTorrents(List<String> hashes, {bool deleteFiles = false});
  Future<TorrentProperties> getTorrentProperties(String hash);
  Future<List<TorrentFileEntry>> getTorrentFiles(String hash);
  Future<List<TorrentTracker>> getTorrentTrackers(String hash);
  Future<List<TorrentPeer>> getTorrentPeers(String hash);
}
