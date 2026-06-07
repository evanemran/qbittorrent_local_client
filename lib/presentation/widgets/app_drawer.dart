import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/torrents_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.controller});

  final TorrentsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final name = controller.serverName.value ?? 'qBittorrent';
            final host = controller.serverHost.value ?? '';
            final user = controller.username.value ?? '';
            final version = controller.serverVersion.value;
            final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.85),
            );
            final versionStyle = theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.7),
            );

            final topPadding = MediaQuery.paddingOf(context).top;

            return Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                height: 208 + topPadding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primaryFixedDim, colorScheme.primaryFixedDim],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                        child: Icon(
                          Icons.dns,
                          size: 32,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (host.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          host,
                          style: subtitleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (user.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          user,
                          style: subtitleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (version != null && version.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'qBittorrent $version',
                          style: versionStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          ListTile(
            leading: const Icon(Icons.home_max),
            title: const Text('Torrents'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
              controller.goHome();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              controller.goToSettings();
            },
          ),
          const Spacer(),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text('Logout', style: TextStyle(color: colorScheme.error)),
            onTap: () {
              Navigator.pop(context);
              controller.disconnect();
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
