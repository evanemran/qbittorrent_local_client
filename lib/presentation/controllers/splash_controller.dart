import 'package:get/get.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/server_config.dart';
import '../../../domain/usecases/get_server_config.dart';
import '../../../domain/usecases/torrent_usecases.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  SplashController({
    required GetServerConfig getServerConfig,
    required ConnectAndLogin connectAndLogin,
  })  : _getServerConfig = getServerConfig,
        _connectAndLogin = connectAndLogin;

  final GetServerConfig _getServerConfig;
  final ConnectAndLogin _connectAndLogin;

  final RxString statusMessage = 'Connecting...'.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    try {
      final config = await _getServerConfig();
      if (config == null) {
        Get.offAllNamed(AppRoutes.setup);
        return;
      }

      statusMessage.value = 'Logging in to ${config.name}...';
      final version = await _connectAndLogin(config);
      Get.offAllNamed(
        AppRoutes.torrents,
        arguments: SplashArgs(config: config, version: version),
      );
    } on AuthFailure catch (e) {
      Get.snackbar('Login failed', e.message);
      Get.offAllNamed(AppRoutes.setup);
    } on Failure catch (e) {
      Get.snackbar('Connection failed', e.message);
      Get.offAllNamed(AppRoutes.setup);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      Get.offAllNamed(AppRoutes.setup);
    }
  }
}

class SplashArgs {
  SplashArgs({required this.config, required this.version});

  final ServerConfig config;
  final String version;
}

ServerConfig? splashConfigFromArgs(dynamic args) {
  if (args is SplashArgs) return args.config;
  if (args is Map && args['config'] is ServerConfig) {
    return args['config'] as ServerConfig;
  }
  return null;
}

String? splashVersionFromArgs(dynamic args) {
  if (args is SplashArgs) return args.version;
  if (args is Map && args['version'] is String) {
    return args['version'] as String;
  }
  return null;
}
