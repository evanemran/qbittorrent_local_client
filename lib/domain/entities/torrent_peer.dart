class TorrentPeer {
  const TorrentPeer({
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

  String get address {
    if (i2pDest.isNotEmpty) return i2pDest;
    if (ip.isNotEmpty && port > 0) return '$ip:$port';
    return id;
  }
}
