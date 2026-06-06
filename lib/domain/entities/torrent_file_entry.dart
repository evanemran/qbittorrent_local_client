class TorrentFileEntry {
  const TorrentFileEntry({
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

  String get fileName {
    final parts = name.split('/');
    return parts.isNotEmpty ? parts.last : name;
  }

  String get priorityLabel {
    switch (priority) {
      case 0:
        return 'Skip';
      case 6:
        return 'High';
      case 7:
        return 'Maximum';
      default:
        return 'Normal';
    }
  }
}
