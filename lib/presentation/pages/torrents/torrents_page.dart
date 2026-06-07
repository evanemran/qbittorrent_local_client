import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../domain/entities/torrent.dart';
import '../../../domain/entities/torrent_filter.dart';
import '../../controllers/torrents_controller.dart';
import '../../widgets/app_drawer.dart';
import '../../controllers/torrent_details_controller.dart';
import '../../widgets/torrent_list_item.dart';

class TorrentsPage extends GetView<TorrentsController> {
  const TorrentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(controller: controller),
      appBar: AppBar(
        title: Obx(() {
          final name = controller.serverName.value ?? 'Torrents';
          final version = controller.serverVersion.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18)),
              if (version != null)
                Text(
                  'qBittorrent $version',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          );
        }),
        actions: [
          Obx(
            () => controller.isRefreshing.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: () =>
                        controller.refreshTorrents(showLoader: true),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
          ),
          IconButton(
            onPressed: controller.resumeAllTorrents,
            icon: const Icon(Icons.playlist_play),
            tooltip: 'Resume all torrents',
          ),
          IconButton(
            onPressed: controller.pauseAllTorrents,
            icon: const Icon(Icons.pause_circle_outline),
            tooltip: 'Pause all torrents',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search torrents...',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: _FilterBar(controller: controller),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.torrents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null &&
            controller.torrents.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value!,
            onRetry: () => controller.refreshTorrents(showLoader: true),
          );
        }

        final items = controller.filteredTorrents;
        if (items.isEmpty) {
          return _EmptyState(filter: controller.selectedFilter.value);
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshTorrents(showLoader: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final torrent = items[index];
              return TorrentListItem(
                torrent: torrent,
                onTap: () => Get.toNamed(
                  AppRoutes.torrentDetails,
                  arguments: TorrentDetailsArgs(torrent: torrent),
                ),
                onTogglePause: () => controller.togglePause(torrent),
                onDelete: () => controller.deleteTorrent(torrent),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Get.toNamed(AppRoutes.addTorrent);
          if (added == true) {
            await controller.refreshTorrents(showLoader: true);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add torrent'),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});

  final TorrentsController controller;

  static const _visibleFilters = [
    TorrentFilter.all,
    TorrentFilter.downloading,
    TorrentFilter.seeding,
    TorrentFilter.stalled,
    TorrentFilter.completed,
    TorrentFilter.errored,
    TorrentFilter.paused,
  ];

  int _countForFilter(List<Torrent> torrents, TorrentFilter filter) {
    if (filter == TorrentFilter.all) return torrents.length;
    return torrents.where((torrent) => _matchesFilter(torrent, filter)).length;
  }

  bool _matchesFilter(Torrent torrent, TorrentFilter filter) {
    switch (filter) {
      case TorrentFilter.all:
        return true;
      case TorrentFilter.downloading:
        return torrent.isDownloading;
      case TorrentFilter.seeding:
        return torrent.isSeeding;
      case TorrentFilter.stalled:
        return torrent.state == 'stalledDL' || torrent.state == 'stalledUP';
      case TorrentFilter.completed:
        return torrent.progress >= 0.9999;
      case TorrentFilter.errored:
        return torrent.hasError;
      case TorrentFilter.paused:
        return torrent.state == 'pausedDL' ||
            torrent.state == 'pausedUP' ||
            torrent.state == 'stoppedDL' ||
            torrent.state == 'stoppedUP';
      case TorrentFilter.stalledDownloading:
      case TorrentFilter.stalledUploading:
      case TorrentFilter.active:
      case TorrentFilter.inactive:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Obx(() {
        final selectedFilter = controller.selectedFilter.value;
        final torrents = controller.torrents;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: _visibleFilters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _visibleFilters[index];
            final selected = selectedFilter == filter;
            final count = _countForFilter(torrents, filter);
            return FilterChip(
              label: Text('${filter.label}($count)'),
              selected: selected,
              onSelected: (_) => controller.changeFilter(filter),
            );
          },
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final TorrentFilter filter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${filter.label.toLowerCase()} torrents',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a magnet link or torrent file',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load torrents',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
