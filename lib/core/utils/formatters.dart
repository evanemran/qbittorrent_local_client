class Formatters {
  Formatters._();

  static String bytesPerSecond(int bytesPerSecond) {
    return '${formatBytes(bytesPerSecond)}/s';
  }

  static String formatBytes(int bytes) {
    if (bytes < 0) return '∞';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static String formatProgress(double progress) {
    return '${(progress * 100).clamp(0, 100).toStringAsFixed(1)}%';
  }

  static String formatEta(int etaSeconds) {
    if (etaSeconds < 0 || etaSeconds >= 8640000) return '∞';
    if (etaSeconds == 0) return 'Done';
    if (etaSeconds < 60) return '${etaSeconds}s';
    if (etaSeconds < 3600) {
      final minutes = etaSeconds ~/ 60;
      final seconds = etaSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
    final hours = etaSeconds ~/ 3600;
    final minutes = (etaSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  static String formatRatio(double ratio) {
    if (ratio < 0) return '∞';
    return ratio.toStringAsFixed(2);
  }

  static String formatDuration(int seconds) {
    if (seconds < 0) return '—';
    if (seconds == 0) return '0s';
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    }
    if (seconds < 86400) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    return hours > 0 ? '${days}d ${hours}h' : '${days}d';
  }

  static String formatTimestamp(int unixSeconds) {
    if (unixSeconds <= 0) return '—';
    final date = DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
