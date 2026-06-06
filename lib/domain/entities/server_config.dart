class ServerConfig {
  const ServerConfig({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    this.useHttps = false,
    this.ignoreCertificateErrors = true,
  });

  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useHttps;
  final bool ignoreCertificateErrors;

  ServerConfig copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? username,
    String? password,
    bool? useHttps,
    bool? ignoreCertificateErrors,
  }) {
    return ServerConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      useHttps: useHttps ?? this.useHttps,
      ignoreCertificateErrors:
          ignoreCertificateErrors ?? this.ignoreCertificateErrors,
    );
  }

}
