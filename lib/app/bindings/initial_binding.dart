import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/qbittorrent_api_client.dart';
import '../../core/services/download_notification_service.dart';
import '../../data/datasources/local/server_config_local_datasource.dart';
import '../../data/datasources/remote/qbittorrent_remote_datasource.dart';
import '../../data/repositories/server_config_repository_impl.dart';
import '../../data/repositories/torrent_repository_impl.dart';
import '../../domain/repositories/server_config_repository.dart';
import '../../domain/repositories/torrent_repository.dart';
import '../../domain/usecases/clear_server_config.dart';
import '../../domain/usecases/get_server_config.dart';
import '../../domain/usecases/save_server_config.dart';
import '../../domain/usecases/torrent_usecases.dart';
import '../../presentation/controllers/add_torrent_controller.dart';
import '../../presentation/controllers/setup_controller.dart';
import '../../presentation/controllers/splash_controller.dart';
import '../../presentation/controllers/torrents_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Session-critical services stay alive for the whole app lifecycle.
    Get.put(QbittorrentApiClient(), permanent: true);

    Get.put<ServerConfigLocalDataSource>(
      ServerConfigLocalDataSource(Get.find<SharedPreferences>()),
      permanent: true,
    );

    Get.put<QbittorrentRemoteDataSource>(
      QbittorrentRemoteDataSource(Get.find<QbittorrentApiClient>()),
      permanent: true,
    );

    Get.put<ServerConfigRepository>(
      ServerConfigRepositoryImpl(Get.find<ServerConfigLocalDataSource>()),
      permanent: true,
    );

    Get.put<TorrentRepository>(
      TorrentRepositoryImpl(
        Get.find<QbittorrentRemoteDataSource>(),
        Get.find<ServerConfigRepository>(),
      ),
      permanent: true,
    );

    Get.lazyPut(
      () => GetServerConfig(Get.find<ServerConfigRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SaveServerConfig(Get.find<ServerConfigRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ClearServerConfig(Get.find<ServerConfigRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => ConnectAndLogin(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => GetTorrents(Get.find<TorrentRepository>()), fenix: true);
    Get.lazyPut(
      () => AddTorrentFromUrl(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => AddTorrentFromFile(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => PauseTorrents(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ResumeTorrents(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DeleteTorrents(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => Logout(Get.find<TorrentRepository>()), fenix: true);
    Get.lazyPut(
      () => GetTorrentProperties(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetTorrentFiles(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetTorrentTrackers(Get.find<TorrentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetTorrentPeers(Get.find<TorrentRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => SplashController(
        getServerConfig: Get.find<GetServerConfig>(),
        connectAndLogin: Get.find<ConnectAndLogin>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => SetupController(
        getServerConfig: Get.find<GetServerConfig>(),
        saveServerConfig: Get.find<SaveServerConfig>(),
        connectAndLogin: Get.find<ConnectAndLogin>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => TorrentsController(
        getServerConfig: Get.find<GetServerConfig>(),
        getTorrents: Get.find<GetTorrents>(),
        pauseTorrents: Get.find<PauseTorrents>(),
        resumeTorrents: Get.find<ResumeTorrents>(),
        deleteTorrents: Get.find<DeleteTorrents>(),
        logout: Get.find<Logout>(),
        clearServerConfig: Get.find<ClearServerConfig>(),
        downloadNotificationService: Get.find<DownloadNotificationService>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => AddTorrentController(
        addTorrentFromUrl: Get.find<AddTorrentFromUrl>(),
        addTorrentFromFile: Get.find<AddTorrentFromFile>(),
      ),
      fenix: true,
    );
  }
}
