class TorrentProperties {
  const TorrentProperties({
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
}
