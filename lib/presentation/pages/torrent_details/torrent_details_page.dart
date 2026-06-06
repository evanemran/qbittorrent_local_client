import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/torrent_details_controller.dart';
import 'tabs/torrent_files_tab.dart';
import 'tabs/torrent_info_tab.dart';
import 'tabs/torrent_peers_tab.dart';
import 'tabs/torrent_trackers_tab.dart';

class TorrentDetailsPage extends GetView<TorrentDetailsController> {
  const TorrentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            controller.torrentName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
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
                      onPressed: controller.refresh,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                    ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Files'),
              Tab(text: 'Trackers'),
              Tab(text: 'Peers'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TorrentInfoTab(),
            TorrentFilesTab(),
            TorrentTrackersTab(),
            TorrentPeersTab(),
          ],
        ),
      ),
    );
  }
}
