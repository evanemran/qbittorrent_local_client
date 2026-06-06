import '../../domain/entities/torrent.dart';

class TorrentModel {
  TorrentModel({
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

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      hash: json['hash'] as String,
      name: json['name'] as String? ?? 'Unknown',
      size: (json['size'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      state: json['state'] as String? ?? 'unknown',
      dlspeed: (json['dlspeed'] as num?)?.toInt() ?? 0,
      upspeed: (json['upspeed'] as num?)?.toInt() ?? 0,
      eta: (json['eta'] as num?)?.toInt() ?? -1,
      ratio: (json['ratio'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? '',
      numSeeds: (json['num_seeds'] as num?)?.toInt() ?? 0,
      numLeechs: (json['num_leechs'] as num?)?.toInt() ?? 0,
      addedOn: (json['added_on'] as num?)?.toInt() ?? 0,
    );
  }

  Torrent toEntity() {
    return Torrent(
      hash: hash,
      name: name,
      size: size,
      progress: progress,
      state: state,
      dlspeed: dlspeed,
      upspeed: upspeed,
      eta: eta,
      ratio: ratio,
      category: category,
      numSeeds: numSeeds,
      numLeechs: numLeechs,
      addedOn: addedOn,
    );
  }
}
