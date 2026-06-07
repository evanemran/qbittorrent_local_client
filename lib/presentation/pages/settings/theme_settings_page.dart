import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    Widget buildThemeTile({
      required ThemeMode mode,
      required String title,
      required String subtitle,
      required ThemeMode selectedMode,
    }) {
      final selected = selectedMode == mode;
      return ListTile(
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        selected: selected,
        onTap: () => themeController.setThemeMode(mode),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: Obx(() {
        final selectedMode = themeController.themeMode.value;
        return ListView(
          children: [
            buildThemeTile(
              mode: ThemeMode.system,
              title: 'System',
              subtitle: 'Follow device theme',
              selectedMode: selectedMode,
            ),
            buildThemeTile(
              mode: ThemeMode.light,
              title: 'Light',
              subtitle: 'Always use light theme',
              selectedMode: selectedMode,
            ),
            buildThemeTile(
              mode: ThemeMode.dark,
              title: 'Dark',
              subtitle: 'Always use dark theme',
              selectedMode: selectedMode,
            ),
          ],
        );
      }),
    );
  }
}
