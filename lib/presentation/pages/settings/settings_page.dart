import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Server Settings'),
            subtitle: const Text('Manage your qBittorrent connection'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.setup),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme Settings'),
            subtitle: const Text('Choose app appearance'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.themeSettings),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Configure server connection and visual preferences.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
