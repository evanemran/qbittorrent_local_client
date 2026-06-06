import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../datasources/local/server_config_local_datasource.dart';
import '../models/server_config_model.dart';

class ServerConfigRepositoryImpl implements ServerConfigRepository {
  ServerConfigRepositoryImpl(this._localDataSource);

  final ServerConfigLocalDataSource _localDataSource;

  @override
  Future<ServerConfig?> getConfig() async {
    try {
      final model = await _localDataSource.getConfig();
      return model?.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> saveConfig(ServerConfig config) async {
    try {
      await _localDataSource.saveConfig(ServerConfigModel.fromEntity(config));
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> clearConfig() async {
    try {
      await _localDataSource.clearConfig();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
