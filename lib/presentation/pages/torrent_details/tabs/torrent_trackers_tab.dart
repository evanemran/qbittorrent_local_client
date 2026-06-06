import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/torrent_details_controller.dart';

class TorrentTrackersTab extends GetView<TorrentDetailsController> {
  const TorrentTrackersTab({super.key});

  Color _statusColor(BuildContext context, int status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case 2:
        return Colors.green.shade600;
      case 4:
        return scheme.error;
      case 3:
        return Colors.orange.shade700;
      default:
        return scheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.trackers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.trackers.isEmpty) {
        return const Center(child: Text('No trackers found'));
      }

      final theme = Theme.of(context);

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.trackers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final tracker = controller.trackers[index];
            final statusColor = _statusColor(context, tracker.status);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            tracker.url,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            tracker.statusLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _StatChip(
                          label: 'Seeds',
                          value: tracker.numSeeds.toString(),
                        ),
                        _StatChip(
                          label: 'Peers',
                          value: tracker.numPeers.toString(),
                        ),
                        _StatChip(
                          label: 'Leeches',
                          value: tracker.numLeeches.toString(),
                        ),
                        if (tracker.tier >= 0)
                          _StatChip(
                            label: 'Tier',
                            value: tracker.tier.toString(),
                          ),
                      ],
                    ),
                    if (tracker.msg.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        tracker.msg,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Text(
      '$label: $value',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}
