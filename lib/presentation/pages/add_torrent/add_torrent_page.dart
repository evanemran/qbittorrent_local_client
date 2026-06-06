import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_torrent_controller.dart';

class AddTorrentPage extends GetView<AddTorrentController> {
  const AddTorrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Torrent'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Magnet / URL', icon: Icon(Icons.link)),
              Tab(text: 'Torrent file', icon: Icon(Icons.upload_file)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MagnetTab(controller: controller),
            _FileTab(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _MagnetTab extends StatelessWidget {
  const _MagnetTab({required this.controller});

  final AddTorrentController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste a magnet link or direct torrent URL',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.magnetController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'magnet:?xt=urn:btih:...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => FilledButton.icon(
              onPressed:
                  controller.isLoading.value ? null : controller.addMagnetLink,
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: const Text('Add torrent'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileTab extends StatelessWidget {
  const _FileTab({required this.controller});

  final AddTorrentController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select a .torrent file from your device to upload to qBittorrent.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          Obx(
            () => OutlinedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.pickAndAddTorrentFile,
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.folder_open),
              label: const Text('Choose .torrent file'),
            ),
          ),
        ],
      ),
    );
  }
}
