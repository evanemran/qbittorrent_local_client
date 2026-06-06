import '../entities/server_config.dart';
import '../entities/torrent.dart';
import '../entities/torrent_file_entry.dart';
import '../entities/torrent_filter.dart';
import '../entities/torrent_peer.dart';
import '../entities/torrent_properties.dart';
import '../entities/torrent_tracker.dart';
import '../repositories/torrent_repository.dart';

class ConnectAndLogin {
  ConnectAndLogin(this._repository);

  final TorrentRepository _repository;

  Future<String> call(ServerConfig config) async {
    await _repository.connect(config);
    return _repository.login();
  }
}

class GetTorrents {
  GetTorrents(this._repository);

  final TorrentRepository _repository;

  Future<List<Torrent>> call(TorrentFilter filter) =>
      _repository.getTorrents(filter);
}

class AddTorrentFromUrl {
  AddTorrentFromUrl(this._repository);

  final TorrentRepository _repository;

  Future<void> call(String url) => _repository.addTorrentFromUrl(url);
}

class AddTorrentFromFile {
  AddTorrentFromFile(this._repository);

  final TorrentRepository _repository;

  Future<void> call(List<int> bytes, String filename) =>
      _repository.addTorrentFromFile(bytes, filename);
}

class PauseTorrents {
  PauseTorrents(this._repository);

  final TorrentRepository _repository;

  Future<void> call(List<String> hashes) => _repository.pauseTorrents(hashes);
}

class ResumeTorrents {
  ResumeTorrents(this._repository);

  final TorrentRepository _repository;

  Future<void> call(List<String> hashes) => _repository.resumeTorrents(hashes);
}

class DeleteTorrents {
  DeleteTorrents(this._repository);

  final TorrentRepository _repository;

  Future<void> call(List<String> hashes, {bool deleteFiles = false}) =>
      _repository.deleteTorrents(hashes, deleteFiles: deleteFiles);
}

class Logout {
  Logout(this._repository);

  final TorrentRepository _repository;

  Future<void> call() => _repository.logout();
}

class GetTorrentProperties {
  GetTorrentProperties(this._repository);

  final TorrentRepository _repository;

  Future<TorrentProperties> call(String hash) =>
      _repository.getTorrentProperties(hash);
}

class GetTorrentFiles {
  GetTorrentFiles(this._repository);

  final TorrentRepository _repository;

  Future<List<TorrentFileEntry>> call(String hash) =>
      _repository.getTorrentFiles(hash);
}

class GetTorrentTrackers {
  GetTorrentTrackers(this._repository);

  final TorrentRepository _repository;

  Future<List<TorrentTracker>> call(String hash) =>
      _repository.getTorrentTrackers(hash);
}

class GetTorrentPeers {
  GetTorrentPeers(this._repository);

  final TorrentRepository _repository;

  Future<List<TorrentPeer>> call(String hash) =>
      _repository.getTorrentPeers(hash);
}
