import '../entities/server_config.dart';
import '../repositories/server_config_repository.dart';

class GetServerConfig {
  GetServerConfig(this._repository);

  final ServerConfigRepository _repository;

  Future<ServerConfig?> call() => _repository.getConfig();
}
