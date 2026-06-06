class TorrentTracker {
  const TorrentTracker({
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

  String get statusLabel {
    switch (status) {
      case 0:
        return 'Disabled';
      case 1:
        return 'Not contacted';
      case 2:
        return 'Working';
      case 3:
        return 'Updating';
      case 4:
        return 'Not working';
      default:
        return 'Unknown';
    }
  }
}
