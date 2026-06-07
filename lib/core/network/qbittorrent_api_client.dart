import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/server_config.dart';
import '../error/exceptions.dart';

class QbittorrentApiClient {
  QbittorrentApiClient();

  Dio? _dio;
  CookieJar? _cookieJar;
  ServerConfig? _config;

  ServerConfig? get config => _config;

  String get baseUrl {
    final config = _config;
    if (config == null) {
      throw ServerException('Server is not configured');
    }
    final scheme = config.useHttps ? 'https' : 'http';
    return '$scheme://${config.host}:${config.port}';
  }

  Future<void> configure(ServerConfig config) async {
    if (_config?.id == config.id &&
        _config?.host == config.host &&
        _config?.port == config.port &&
        _config?.useHttps == config.useHttps) {
      _config = config;
      return;
    }

    await _disposeClient();
    _config = config;

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (config.ignoreCertificateErrors && config.useHttps) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }

    final appDir = await getApplicationDocumentsDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage('${appDir.path}/.cookies/'),
    );
    dio.interceptors.add(CookieManager(_cookieJar!));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Referer'] = baseUrl;
          options.headers['Origin'] = baseUrl;
          handler.next(options);
        },
      ),
    );

    _dio = dio;
  }

  Future<void> clearSession() async {
    await _cookieJar?.deleteAll();
  }

  Future<void> _disposeClient() async {
    await _cookieJar?.deleteAll();
    _cookieJar = null;
    _dio?.close(force: true);
    _dio = null;
  }

  Dio get _client {
    final dio = _dio;
    if (dio == null) {
      throw ServerException('API client is not configured');
    }
    return dio;
  }

  Future<void> login(String username, String password) async {
    final response = await _client.post(
      '$baseUrl/api/v2/auth/login',
      data: {'username': username, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 403) {
      throw ServerException('Too many failed login attempts. IP is banned.');
    }

    if (response.data?.toString().trim() != 'Ok.') {
      throw ServerException('Invalid username or password');
    }
  }

  Future<void> logout() async {
    try {
      await _client.post('$baseUrl/api/v2/auth/logout');
    } finally {
      await clearSession();
    }
  }

  Future<String> getVersion() async {
    final response = await _client.get('$baseUrl/api/v2/app/version');
    _ensureSuccess(response);
    return response.data.toString();
  }

  Future<List<Map<String, dynamic>>> getTorrents({String filter = 'all'}) async {
    final response = await _client.get(
      '$baseUrl/api/v2/torrents/info',
      queryParameters: {'filter': filter},
    );
    _ensureSuccess(response);

    final data = response.data;
    if (data is! List) {
      throw ServerException('Unexpected torrent list response');
    }

    return data.cast<Map<String, dynamic>>();
  }

  Future<void> addTorrentFromUrl(String url) async {
    final response = await _client.post(
      '$baseUrl/api/v2/torrents/add',
      data: FormData.fromMap({'urls': url}),
    );
    _ensureAddSuccess(response);
  }

  Future<void> addTorrentFromFile(List<int> bytes, String filename) async {
    final response = await _client.post(
      '$baseUrl/api/v2/torrents/add',
      data: FormData.fromMap({
        'torrents': MultipartFile.fromBytes(
          bytes,
          filename: filename,
        ),
      }),
    );
    _ensureAddSuccess(response);
  }

  Future<void> pauseTorrents(List<String> hashes) async {
    if (hashes.isEmpty) return;
    await _postTorrentHashAction(
      v5Action: 'stop',
      v4Action: 'pause',
      hashes: hashes,
    );
  }

  Future<void> resumeTorrents(List<String> hashes) async {
    if (hashes.isEmpty) return;
    await _postTorrentHashAction(
      v5Action: 'start',
      v4Action: 'resume',
      hashes: hashes,
    );
  }

  Future<void> _postTorrentHashAction({
    required String v5Action,
    required String v4Action,
    required List<String> hashes,
  }) async {
    final data = {'hashes': hashes.join('|')};
    final options = Options(contentType: Headers.formUrlEncodedContentType);

    var response = await _client.post(
      '$baseUrl/api/v2/torrents/$v5Action',
      data: data,
      options: options,
    );

    if (response.statusCode == 404) {
      response = await _client.post(
        '$baseUrl/api/v2/torrents/$v4Action',
        data: data,
        options: options,
      );
    }

    _ensureSuccess(response);
  }

  Future<void> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) async {
    if (hashes.isEmpty) return;
    final response = await _client.post(
      '$baseUrl/api/v2/torrents/delete',
      data: {
        'hashes': hashes.join('|'),
        'deleteFiles': deleteFiles.toString(),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    _ensureSuccess(response);
  }

  Future<Map<String, dynamic>> getTorrentProperties(String hash) async {
    final response = await _client.get(
      '$baseUrl/api/v2/torrents/properties',
      queryParameters: {'hash': hash},
    );
    _ensureSuccess(response);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException('Unexpected torrent properties response');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getTorrentFiles(String hash) async {
    final response = await _client.get(
      '$baseUrl/api/v2/torrents/files',
      queryParameters: {'hash': hash},
    );
    _ensureSuccess(response);
    final data = response.data;
    if (data is! List) {
      throw ServerException('Unexpected torrent files response');
    }
    return data.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getTorrentTrackers(String hash) async {
    final response = await _client.get(
      '$baseUrl/api/v2/torrents/trackers',
      queryParameters: {'hash': hash},
    );
    _ensureSuccess(response);
    final data = response.data;
    if (data is! List) {
      throw ServerException('Unexpected torrent trackers response');
    }
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getTorrentPeers(String hash, {int rid = 0}) async {
    final response = await _client.get(
      '$baseUrl/api/v2/sync/torrentPeers',
      queryParameters: {'hash': hash, 'rid': rid},
    );
    _ensureSuccess(response);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw ServerException('Unexpected torrent peers response');
    }
    return data;
  }

  void _ensureSuccess(Response<dynamic> response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw ServerException('Session expired. Please log in again.');
    }
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw ServerException(
        'Request failed (${response.statusCode ?? 'unknown'})',
      );
    }
  }

  void _ensureAddSuccess(Response<dynamic> response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw ServerException('Session expired. Please log in again.');
    }
    final body = response.data?.toString().trim();
    if (response.statusCode != 200 || body == 'Fails.') {
      throw ServerException('Failed to add torrent');
    }
  }
}
