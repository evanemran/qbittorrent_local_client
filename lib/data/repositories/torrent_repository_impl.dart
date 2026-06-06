import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/entities/torrent.dart';
import '../../domain/entities/torrent_file_entry.dart';
import '../../domain/entities/torrent_filter.dart';
import '../../domain/entities/torrent_peer.dart';
import '../../domain/entities/torrent_properties.dart';
import '../../domain/entities/torrent_tracker.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../../domain/repositories/torrent_repository.dart';
import '../datasources/remote/qbittorrent_remote_datasource.dart';

class TorrentRepositoryImpl implements TorrentRepository {
  TorrentRepositoryImpl(
    this._remoteDataSource,
    this._serverConfigRepository,
  );

  final QbittorrentRemoteDataSource _remoteDataSource;
  final ServerConfigRepository _serverConfigRepository;
  ServerConfig? _activeConfig;

  ServerConfig? get activeConfig => _activeConfig ?? _remoteDataSource.config;

  @override
  Future<void> connect(ServerConfig config) async {
    _activeConfig = config;
    await _remoteDataSource.configure(config);
  }

  @override
  Future<String> login() async {
    final config = await _ensureSession();
    try {
      return await _remoteDataSource.login(config.username, config.password);
    } on ServerException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } finally {
      _activeConfig = null;
    }
  }

  @override
  Future<List<Torrent>> getTorrents(TorrentFilter filter) async {
    await _ensureSession();
    try {
      final models =
          await _remoteDataSource.getTorrents(filter: filter.apiValue);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> addTorrentFromUrl(String url) async {
    await _ensureSession();
    try {
      await _remoteDataSource.addTorrentFromUrl(url);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> addTorrentFromFile(List<int> bytes, String filename) async {
    await _ensureSession();
    try {
      await _remoteDataSource.addTorrentFromFile(bytes, filename);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> pauseTorrents(List<String> hashes) async {
    await _ensureSession();
    try {
      await _remoteDataSource.pauseTorrents(hashes);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> resumeTorrents(List<String> hashes) async {
    await _ensureSession();
    try {
      await _remoteDataSource.resumeTorrents(hashes);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) async {
    await _ensureSession();
    try {
      await _remoteDataSource.deleteTorrents(
        hashes,
        deleteFiles: deleteFiles,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<TorrentProperties> getTorrentProperties(String hash) async {
    await _ensureSession();
    try {
      final model = await _remoteDataSource.getTorrentProperties(hash);
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<TorrentFileEntry>> getTorrentFiles(String hash) async {
    await _ensureSession();
    try {
      final models = await _remoteDataSource.getTorrentFiles(hash);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<TorrentTracker>> getTorrentTrackers(String hash) async {
    await _ensureSession();
    try {
      final models = await _remoteDataSource.getTorrentTrackers(hash);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<TorrentPeer>> getTorrentPeers(String hash) async {
    await _ensureSession();
    try {
      final models = await _remoteDataSource.getTorrentPeers(hash);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  Future<ServerConfig> _ensureSession() async {
    final cached = _activeConfig ?? _remoteDataSource.config;
    if (cached != null) {
      _activeConfig ??= cached;
      return cached;
    }

    final saved = await _serverConfigRepository.getConfig();
    if (saved == null) {
      throw const ServerFailure('No server connection configured');
    }

    await connect(saved);
    try {
      await _remoteDataSource.login(saved.username, saved.password);
    } on ServerException catch (e) {
      throw AuthFailure(e.message);
    }

    return saved;
  }
}
