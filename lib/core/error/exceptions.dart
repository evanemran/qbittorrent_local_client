class ServerException implements Exception {
  ServerException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  CacheException(this.message);

  final String message;

  @override
  String toString() => message;
}
