class Torrent {
  const Torrent({
    required this.hash,
    required this.name,
    required this.size,
    required this.progress,
    required this.state,
    required this.dlspeed,
    required this.upspeed,
    required this.eta,
    required this.ratio,
    required this.category,
    required this.numSeeds,
    required this.numLeechs,
    required this.addedOn,
  });

  final String hash;
  final String name;
  final int size;
  final double progress;
  final String state;
  final int dlspeed;
  final int upspeed;
  final int eta;
  final double ratio;
  final String category;
  final int numSeeds;
  final int numLeechs;
  final int addedOn;

  bool get isPaused =>
      state == 'pausedDL' ||
      state == 'pausedUP' ||
      state == 'stoppedDL' ||
      state == 'stoppedUP';

  bool get isSeeding =>
      state == 'uploading' ||
      state == 'stalledUP' ||
      state == 'queuedUP' ||
      state == 'forcedUP' ||
      state == 'checkingUP' ||
      state == 'pausedUP';

  bool get isDownloading =>
      state == 'downloading' ||
      state == 'metaDL' ||
      state == 'stalledDL' ||
      state == 'queuedDL' ||
      state == 'forcedDL' ||
      state == 'checkingDL' ||
      state == 'pausedDL';

  bool get hasError => state == 'error' || state == 'missingFiles';

  String get stateLabel {
    switch (state) {
      case 'downloading':
        return 'Downloading';
      case 'uploading':
        return 'Seeding';
      case 'stalledDL':
        return 'Stalled (DL)';
      case 'stalledUP':
        return 'Stalled (UL)';
      case 'pausedDL':
      case 'stoppedDL':
        return 'Paused (DL)';
      case 'pausedUP':
      case 'stoppedUP':
        return 'Paused (UL)';
      case 'queuedDL':
        return 'Queued (DL)';
      case 'queuedUP':
        return 'Queued (UL)';
      case 'metaDL':
        return 'Fetching metadata';
      case 'checkingDL':
      case 'checkingUP':
        return 'Checking';
      case 'forcedDL':
        return 'Forced DL';
      case 'forcedUP':
        return 'Forced UL';
      case 'error':
        return 'Error';
      case 'missingFiles':
        return 'Missing files';
      case 'allocating':
        return 'Allocating';
      case 'moving':
        return 'Moving';
      default:
        return state;
    }
  }

}
