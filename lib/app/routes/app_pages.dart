import 'package:get/get.dart';

import '../../presentation/controllers/torrent_details_controller.dart';
import '../../domain/usecases/torrent_usecases.dart';
import '../../presentation/pages/add_torrent/add_torrent_page.dart';
import '../../presentation/pages/setup/setup_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/torrent_details/torrent_details_page.dart';
import '../../presentation/pages/torrents/torrents_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.setup,
      page: () => const SetupPage(),
    ),
    GetPage(
      name: AppRoutes.torrents,
      page: () => const TorrentsPage(),
    ),
    GetPage(
      name: AppRoutes.addTorrent,
      page: () => const AddTorrentPage(),
    ),
    GetPage(
      name: AppRoutes.torrentDetails,
      page: () => const TorrentDetailsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
          () => TorrentDetailsController(
            getTorrentProperties: Get.find<GetTorrentProperties>(),
            getTorrentFiles: Get.find<GetTorrentFiles>(),
            getTorrentTrackers: Get.find<GetTorrentTrackers>(),
            getTorrentPeers: Get.find<GetTorrentPeers>(),
          ),
        );
      }),
    ),
  ];
}
