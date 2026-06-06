import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../controllers/torrent_details_controller.dart';

class TorrentPeersTab extends GetView<TorrentDetailsController> {
  const TorrentPeersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.peers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.peers.isEmpty) {
        return const Center(child: Text('No peers connected'));
      }

      final theme = Theme.of(context);

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.peers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final peer = controller.peers[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            peer.address,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (peer.country.isNotEmpty)
                          Text(
                            peer.country,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      peer.client,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (peer.flagsDescription.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        peer.flagsDescription,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: peer.progress.clamp(0, 1),
                        minHeight: 5,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _PeerStat(
                          icon: Icons.arrow_downward,
                          label: Formatters.bytesPerSecond(peer.dlSpeed),
                        ),
                        _PeerStat(
                          icon: Icons.arrow_upward,
                          label: Formatters.bytesPerSecond(peer.upSpeed),
                        ),
                        _PeerStat(
                          icon: Icons.pie_chart_outline,
                          label: Formatters.formatProgress(peer.progress),
                        ),
                        if (peer.connection.isNotEmpty)
                          _PeerStat(
                            icon: Icons.swap_horiz,
                            label: peer.connection,
                          ),
                      ],
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

class _PeerStat extends StatelessWidget {
  const _PeerStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
