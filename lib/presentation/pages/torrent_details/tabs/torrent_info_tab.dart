import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../controllers/torrent_details_controller.dart';
import '../../../widgets/detail_row.dart';

class TorrentInfoTab extends GetView<TorrentDetailsController> {
  const TorrentInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.properties.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value != null &&
          controller.properties.value == null) {
        return _ErrorView(
          message: controller.errorMessage.value!,
          onRetry: controller.refresh,
        );
      }

      final torrent = controller.torrent;
      final props = controller.properties.value;
      final theme = Theme.of(context);
      final progressColor = torrent.hasError
          ? theme.colorScheme.error
          : theme.colorScheme.primary;

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Download progress',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: torrent.progress.clamp(0, 1),
                        minHeight: 8,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        color: progressColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          Formatters.formatProgress(torrent.progress),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatters.formatBytes(torrent.size),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      torrent.stateLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DetailSection(
                  title: 'Transfer',
                  children: [
                    DetailRow(
                      label: 'Download speed',
                      value: Formatters.bytesPerSecond(
                        props?.dlSpeed ?? torrent.dlspeed,
                      ),
                      icon: Icons.arrow_downward,
                    ),
                    DetailRow(
                      label: 'Upload speed',
                      value: Formatters.bytesPerSecond(
                        props?.upSpeed ?? torrent.upspeed,
                      ),
                      icon: Icons.arrow_upward,
                    ),
                    DetailRow(
                      label: 'ETA',
                      value: Formatters.formatEta(
                        props?.eta ?? torrent.eta,
                      ),
                      icon: Icons.schedule,
                    ),
                    DetailRow(
                      label: 'Share ratio',
                      value: Formatters.formatRatio(
                        props?.shareRatio ?? torrent.ratio,
                      ),
                      icon: Icons.share,
                    ),
                    DetailRow(
                      label: 'Downloaded',
                      value: formatOptionalBytes(
                        props?.totalDownloaded ?? -1,
                      ),
                      icon: Icons.download_done,
                    ),
                    DetailRow(
                      label: 'Uploaded',
                      value: formatOptionalBytes(
                        props?.totalUploaded ?? -1,
                      ),
                      icon: Icons.upload,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DetailSection(
                  title: 'Connections',
                  children: [
                    DetailRow(
                      label: 'Seeds',
                      value: props != null
                          ? '${formatCount(props.seeds)} / ${formatCount(props.seedsTotal)}'
                          : '${torrent.numSeeds}',
                      icon: Icons.upload,
                    ),
                    DetailRow(
                      label: 'Peers',
                      value: props != null
                          ? '${formatCount(props.peers)} / ${formatCount(props.peersTotal)}'
                          : '${torrent.numLeechs}',
                      icon: Icons.group,
                    ),
                    DetailRow(
                      label: 'Connections',
                      value: props != null
                          ? '${formatCount(props.nbConnections)} / ${formatCount(props.nbConnectionsLimit)}'
                          : '—',
                      icon: Icons.link,
                    ),
                    DetailRow(
                      label: 'Time active',
                      value: Formatters.formatDuration(
                        props?.timeElapsed ?? -1,
                      ),
                      icon: Icons.timer_outlined,
                    ),
                    if (props != null && props.seedingTime >= 0)
                      DetailRow(
                        label: 'Seeding time',
                        value: Formatters.formatDuration(props.seedingTime),
                        icon: Icons.access_time,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (props != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DetailSection(
                    title: 'Details',
                    children: [
                      DetailRow(
                        label: 'Save path',
                        value: props.savePath,
                        icon: Icons.folder_outlined,
                      ),
                      if (torrent.category.isNotEmpty)
                        DetailRow(
                          label: 'Category',
                          value: torrent.category,
                          icon: Icons.category_outlined,
                        ),
                      DetailRow(
                        label: 'Added on',
                        value: Formatters.formatTimestamp(props.additionDate),
                        icon: Icons.calendar_today,
                      ),
                      if (props.completionDate > 0)
                        DetailRow(
                          label: 'Completed on',
                          value:
                              Formatters.formatTimestamp(props.completionDate),
                          icon: Icons.check_circle_outline,
                        ),
                      if (props.piecesNum > 0)
                        DetailRow(
                          label: 'Pieces',
                          value: '${props.piecesHave} / ${props.piecesNum}',
                          icon: Icons.grid_view,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
