import '../entities/server_config.dart';
import '../repositories/server_config_repository.dart';

class SaveServerConfig {
  SaveServerConfig(this._repository);

  final ServerConfigRepository _repository;

  Future<void> call(ServerConfig config) => _repository.saveConfig(config);
}
