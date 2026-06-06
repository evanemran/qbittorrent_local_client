import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/server_config.dart';
import '../../../domain/usecases/get_server_config.dart';
import '../../../domain/usecases/save_server_config.dart';
import '../../../domain/usecases/torrent_usecases.dart';
import '../../app/routes/app_routes.dart';
import 'splash_controller.dart';

class SetupController extends GetxController {
  SetupController({
    required GetServerConfig getServerConfig,
    required SaveServerConfig saveServerConfig,
    required ConnectAndLogin connectAndLogin,
  })  : _getServerConfig = getServerConfig,
        _saveServerConfig = saveServerConfig,
        _connectAndLogin = connectAndLogin;

  final GetServerConfig _getServerConfig;
  final SaveServerConfig _saveServerConfig;
  final ConnectAndLogin _connectAndLogin;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final hostController = TextEditingController(text: '192.168.1.100');
  final portController = TextEditingController(text: '8080');
  final usernameController = TextEditingController(text: 'admin');
  final passwordController = TextEditingController();

  final RxBool useHttps = false.obs;
  final RxBool ignoreCertificateErrors = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  String? _existingId;

  @override
  void onInit() {
    super.onInit();
    _loadExistingConfig();
  }

  Future<void> _loadExistingConfig() async {
    final config = await _getServerConfig();
    if (config == null) return;

    _existingId = config.id;
    nameController.text = config.name;
    hostController.text = config.host;
    portController.text = config.port.toString();
    usernameController.text = config.username;
    passwordController.text = config.password;
    useHttps.value = config.useHttps;
    ignoreCertificateErrors.value = config.ignoreCertificateErrors;
  }

  Future<void> saveAndConnect() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final config = ServerConfig(
        id: _existingId ?? const Uuid().v4(),
        name: nameController.text.trim(),
        host: hostController.text.trim(),
        port: int.parse(portController.text.trim()),
        username: usernameController.text.trim(),
        password: passwordController.text,
        useHttps: useHttps.value,
        ignoreCertificateErrors: ignoreCertificateErrors.value,
      );

      await _saveServerConfig(config);
      final version = await _connectAndLogin(config);

      Get.offAllNamed(
        AppRoutes.torrents,
        arguments: SplashArgs(config: config, version: version),
      );
    } on AuthFailure catch (e) {
      Get.snackbar('Login failed', e.message);
    } on Failure catch (e) {
      Get.snackbar('Connection failed', e.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    hostController.dispose();
    portController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
