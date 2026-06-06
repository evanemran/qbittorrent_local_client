import '../repositories/server_config_repository.dart';

class ClearServerConfig {
  ClearServerConfig(this._repository);

  final ServerConfigRepository _repository;

  Future<void> call() => _repository.clearConfig();
}
