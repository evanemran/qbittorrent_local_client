import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../domain/entities/torrent.dart';

class TorrentListItem extends StatelessWidget {
  const TorrentListItem({
    super.key,
    required this.torrent,
    required this.onTap,
    required this.onTogglePause,
    required this.onDelete,
  });

  final Torrent torrent;
  final VoidCallback onTap;
  final VoidCallback onTogglePause;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(colorScheme, torrent);
    final progressColor = _progressColor(torrent);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: () => _showActions(context),
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
                      torrent.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: torrent.stateLabel,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: torrent.progress.clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: progressColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    Formatters.formatProgress(torrent.progress),
                    style: theme.textTheme.labelLarge,
                  ),
                  const Spacer(),
                  Text(
                    Formatters.formatBytes(torrent.size),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _InfoChip(
                    icon: Icons.arrow_downward,
                    label: Formatters.bytesPerSecond(torrent.dlspeed),
                  ),
                  _InfoChip(
                    icon: Icons.arrow_upward,
                    label: Formatters.bytesPerSecond(torrent.upspeed),
                  ),
                  if (torrent.isDownloading)
                    _InfoChip(
                      icon: Icons.schedule,
                      label: 'ETA ${Formatters.formatEta(torrent.eta)}',
                    ),
                  if (torrent.isSeeding)
                    _InfoChip(
                      icon: Icons.share,
                      label: 'Ratio ${Formatters.formatRatio(torrent.ratio)}',
                    ),
                  _InfoChip(
                    icon: Icons.group,
                    label: '${torrent.numSeeds}↑ ${torrent.numLeechs}↓',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _progressColor(Torrent torrent) {
    switch (torrent.state) {
      case 'pausedDL':
      case 'pausedUP':
        return Colors.blue.shade600;
      case 'error':
      case 'missingFiles':
      case 'stoppedDL':
      case 'stoppedUP':
        return Colors.red.shade600;
      case 'uploading':
      case 'stalledUP':
      case 'queuedUP':
      case 'forcedUP':
      case 'checkingUP':
        return Colors.amber.shade700;
      case 'downloading':
      case 'metaDL':
      case 'stalledDL':
      case 'queuedDL':
      case 'forcedDL':
      case 'checkingDL':
      case 'allocating':
      case 'moving':
        return Colors.green.shade600;
      default:
        return Colors.green.shade600;
    }
  }

  Color _statusColor(ColorScheme colorScheme, Torrent torrent) {
    if (torrent.hasError) return colorScheme.error;
    if (torrent.isSeeding) return Colors.green.shade600;
    if (torrent.state.startsWith('stalled')) return Colors.orange.shade700;
    if (torrent.isPaused) return colorScheme.outline;
    return colorScheme.primary;
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                torrent.isPaused ? Icons.play_arrow : Icons.pause,
              ),
              title: Text(torrent.isPaused ? 'Resume' : 'Pause'),
              onTap: () {
                Navigator.pop(context);
                onTogglePause();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

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
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
