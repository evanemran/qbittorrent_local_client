import '../../domain/entities/torrent_file_entry.dart';
import '../../domain/entities/torrent_peer.dart';
import '../../domain/entities/torrent_properties.dart';
import '../../domain/entities/torrent_tracker.dart';

class TorrentPropertiesModel {
  TorrentPropertiesModel({
    required this.savePath,
    required this.totalSize,
    required this.timeElapsed,
    required this.seedingTime,
    required this.dlSpeed,
    required this.upSpeed,
    required this.dlSpeedAvg,
    required this.upSpeedAvg,
    required this.eta,
    required this.seeds,
    required this.seedsTotal,
    required this.peers,
    required this.peersTotal,
    required this.shareRatio,
    required this.totalDownloaded,
    required this.totalUploaded,
    required this.totalDownloadedSession,
    required this.totalUploadedSession,
    required this.nbConnections,
    required this.nbConnectionsLimit,
    required this.additionDate,
    required this.completionDate,
    required this.piecesHave,
    required this.piecesNum,
  });

  final String savePath;
  final int totalSize;
  final int timeElapsed;
  final int seedingTime;
  final int dlSpeed;
  final int upSpeed;
  final int dlSpeedAvg;
  final int upSpeedAvg;
  final int eta;
  final int seeds;
  final int seedsTotal;
  final int peers;
  final int peersTotal;
  final double shareRatio;
  final int totalDownloaded;
  final int totalUploaded;
  final int totalDownloadedSession;
  final int totalUploadedSession;
  final int nbConnections;
  final int nbConnectionsLimit;
  final int additionDate;
  final int completionDate;
  final int piecesHave;
  final int piecesNum;

  factory TorrentPropertiesModel.fromJson(Map<String, dynamic> json) {
    int readInt(String key) => (json[key] as num?)?.toInt() ?? -1;

    return TorrentPropertiesModel(
      savePath: json['save_path'] as String? ?? '',
      totalSize: readInt('total_size'),
      timeElapsed: readInt('time_elapsed'),
      seedingTime: readInt('seeding_time'),
      dlSpeed: readInt('dl_speed'),
      upSpeed: readInt('up_speed'),
      dlSpeedAvg: readInt('dl_speed_avg'),
      upSpeedAvg: readInt('up_speed_avg'),
      eta: readInt('eta'),
      seeds: readInt('seeds'),
      seedsTotal: readInt('seeds_total'),
      peers: readInt('peers'),
      peersTotal: readInt('peers_total'),
      shareRatio: (json['share_ratio'] as num?)?.toDouble() ?? 0,
      totalDownloaded: readInt('total_downloaded'),
      totalUploaded: readInt('total_uploaded'),
      totalDownloadedSession: readInt('total_downloaded_session'),
      totalUploadedSession: readInt('total_uploaded_session'),
      nbConnections: readInt('nb_connections'),
      nbConnectionsLimit: readInt('nb_connections_limit'),
      additionDate: readInt('addition_date'),
      completionDate: readInt('completion_date'),
      piecesHave: readInt('pieces_have'),
      piecesNum: readInt('pieces_num'),
    );
  }

  TorrentProperties toEntity() {
    return TorrentProperties(
      savePath: savePath,
      totalSize: totalSize,
      timeElapsed: timeElapsed,
      seedingTime: seedingTime,
      dlSpeed: dlSpeed,
      upSpeed: upSpeed,
      dlSpeedAvg: dlSpeedAvg,
      upSpeedAvg: upSpeedAvg,
      eta: eta,
      seeds: seeds,
      seedsTotal: seedsTotal,
      peers: peers,
      peersTotal: peersTotal,
      shareRatio: shareRatio,
      totalDownloaded: totalDownloaded,
      totalUploaded: totalUploaded,
      totalDownloadedSession: totalDownloadedSession,
      totalUploadedSession: totalUploadedSession,
      nbConnections: nbConnections,
      nbConnectionsLimit: nbConnectionsLimit,
      additionDate: additionDate,
      completionDate: completionDate,
      piecesHave: piecesHave,
      piecesNum: piecesNum,
    );
  }
}

class TorrentFileEntryModel {
  TorrentFileEntryModel({
    required this.index,
    required this.name,
    required this.size,
    required this.progress,
    required this.priority,
    required this.isSeed,
    required this.availability,
  });

  final int index;
  final String name;
  final int size;
  final double progress;
  final int priority;
  final bool isSeed;
  final double availability;

  factory TorrentFileEntryModel.fromJson(Map<String, dynamic> json) {
    return TorrentFileEntryModel(
      index: (json['index'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      isSeed: json['is_seed'] as bool? ?? false,
      availability: (json['availability'] as num?)?.toDouble() ?? 0,
    );
  }

  TorrentFileEntry toEntity() {
    return TorrentFileEntry(
      index: index,
      name: name,
      size: size,
      progress: progress,
      priority: priority,
      isSeed: isSeed,
      availability: availability,
    );
  }
}

class TorrentTrackerModel {
  TorrentTrackerModel({
    required this.url,
    required this.status,
    required this.tier,
    required this.numPeers,
    required this.numSeeds,
    required this.numLeeches,
    required this.msg,
  });

  final String url;
  final int status;
  final int tier;
  final int numPeers;
  final int numSeeds;
  final int numLeeches;
  final String msg;

  factory TorrentTrackerModel.fromJson(Map<String, dynamic> json) {
    return TorrentTrackerModel(
      url: json['url'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 0,
      tier: (json['tier'] as num?)?.toInt() ?? -1,
      numPeers: (json['num_peers'] as num?)?.toInt() ?? 0,
      numSeeds: (json['num_seeds'] as num?)?.toInt() ?? 0,
      numLeeches: (json['num_leeches'] as num?)?.toInt() ?? 0,
      msg: json['msg'] as String? ?? '',
    );
  }

  TorrentTracker toEntity() {
    return TorrentTracker(
      url: url,
      status: status,
      tier: tier,
      numPeers: numPeers,
      numSeeds: numSeeds,
      numLeeches: numLeeches,
      msg: msg,
    );
  }
}

class TorrentPeerModel {
  TorrentPeerModel({
    required this.id,
    required this.client,
    required this.ip,
    required this.port,
    required this.i2pDest,
    required this.progress,
    required this.dlSpeed,
    required this.upSpeed,
    required this.downloaded,
    required this.uploaded,
    required this.flags,
    required this.flagsDescription,
    required this.country,
    required this.connection,
  });

  final String id;
  final String client;
  final String ip;
  final int port;
  final String i2pDest;
  final double progress;
  final int dlSpeed;
  final int upSpeed;
  final int downloaded;
  final int uploaded;
  final String flags;
  final String flagsDescription;
  final String country;
  final String connection;

  factory TorrentPeerModel.fromMap(String id, Map<String, dynamic> json) {
    return TorrentPeerModel(
      id: id,
      client: json['client'] as String? ?? 'Unknown',
      ip: json['ip'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      i2pDest: json['i2p_dest'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      dlSpeed: (json['dl_speed'] as num?)?.toInt() ?? 0,
      upSpeed: (json['up_speed'] as num?)?.toInt() ?? 0,
      downloaded: (json['downloaded'] as num?)?.toInt() ?? 0,
      uploaded: (json['uploaded'] as num?)?.toInt() ?? 0,
      flags: json['flags'] as String? ?? '',
      flagsDescription: json['flags_desc'] as String? ?? '',
      country: json['country'] as String? ?? '',
      connection: json['connection'] as String? ?? '',
    );
  }

  TorrentPeer toEntity() {
    return TorrentPeer(
      id: id,
      client: client,
      ip: ip,
      port: port,
      i2pDest: i2pDest,
      progress: progress,
      dlSpeed: dlSpeed,
      upSpeed: upSpeed,
      downloaded: downloaded,
      uploaded: uploaded,
      flags: flags,
      flagsDescription: flagsDescription,
      country: country,
      connection: connection,
    );
  }
}
