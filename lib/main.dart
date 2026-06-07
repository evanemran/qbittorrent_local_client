import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/download_notification_service.dart';
import 'presentation/controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<SharedPreferences>(SharedPreferences.getInstance);
  Get.put(
    ThemeController(sharedPreferences: Get.find<SharedPreferences>()),
    permanent: true,
  );
  final downloadNotificationService = DownloadNotificationService();
  await downloadNotificationService.initialize();
  Get.put(downloadNotificationService, permanent: true);
  runApp(const QbittorrentApp());
}

class QbittorrentApp extends StatelessWidget {
  const QbittorrentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode.value,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
