import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../controllers/torrent_details_controller.dart';

class TorrentFilesTab extends GetView<TorrentDetailsController> {
  const TorrentFilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.files.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.files.isEmpty) {
        return _EmptyView(
          icon: Icons.insert_drive_file_outlined,
          message: 'No files found for this torrent',
        );
      }

      final theme = Theme.of(context);

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.files.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final file = controller.files[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (file.name.contains('/'))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          file.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: file.progress.clamp(0, 1),
                        minHeight: 5,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(Formatters.formatProgress(file.progress)),
                        const Spacer(),
                        Text(
                          Formatters.formatBytes(file.size),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Priority: ${file.priorityLabel}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}
