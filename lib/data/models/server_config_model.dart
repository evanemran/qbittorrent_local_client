import '../../domain/entities/server_config.dart';

class ServerConfigModel {
  ServerConfigModel({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.useHttps,
    required this.ignoreCertificateErrors,
  });

  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useHttps;
  final bool ignoreCertificateErrors;

  factory ServerConfigModel.fromEntity(ServerConfig entity) {
    return ServerConfigModel(
      id: entity.id,
      name: entity.name,
      host: entity.host,
      port: entity.port,
      username: entity.username,
      password: entity.password,
      useHttps: entity.useHttps,
      ignoreCertificateErrors: entity.ignoreCertificateErrors,
    );
  }

  factory ServerConfigModel.fromJson(Map<String, dynamic> json) {
    return ServerConfigModel(
      id: json['id'] as String,
      name: json['name'] as String,
      host: json['host'] as String,
      port: json['port'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      useHttps: json['useHttps'] as bool? ?? false,
      ignoreCertificateErrors: json['ignoreCertificateErrors'] as bool? ?? true,
    );
  }

  ServerConfig toEntity() {
    return ServerConfig(
      id: id,
      name: name,
      host: host,
      port: port,
      username: username,
      password: password,
      useHttps: useHttps,
      ignoreCertificateErrors: ignoreCertificateErrors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'useHttps': useHttps,
      'ignoreCertificateErrors': ignoreCertificateErrors,
    };
  }
}
