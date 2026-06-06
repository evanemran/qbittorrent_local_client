import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/setup_controller.dart';

class SetupPage extends GetView<SetupController> {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Setup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Connect to your qBittorrent instance',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your Web UI credentials. These are stored locally on this device.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Server name',
                    hintText: 'Home NAS',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a server name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.hostController,
                  decoration: const InputDecoration(
                    labelText: 'Hostname or IP',
                    hintText: '192.168.1.100',
                    prefixIcon: Icon(Icons.dns_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a hostname or IP address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: '8080',
                    prefixIcon: Icon(Icons.settings_ethernet),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a port number';
                    }
                    final port = int.tryParse(value.trim());
                    if (port == null || port < 1 || port > 65535) {
                      return 'Enter a valid port (1-65535)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => controller.obscurePassword.toggle(),
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    obscureText: controller.obscurePassword.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Use HTTPS'),
                    subtitle: const Text('Enable if your Web UI uses SSL/TLS'),
                    value: controller.useHttps.value,
                    onChanged: (value) => controller.useHttps.value = value,
                  ),
                ),
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ignore certificate errors'),
                    subtitle: const Text(
                      'Useful for self-signed certificates on local servers',
                    ),
                    value: controller.ignoreCertificateErrors.value,
                    onChanged: controller.useHttps.value
                        ? (value) =>
                            controller.ignoreCertificateErrors.value = value
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => FilledButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveAndConnect,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.link),
                    label: Text(
                      controller.isLoading.value
                          ? 'Connecting...'
                          : 'Save & Connect',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
