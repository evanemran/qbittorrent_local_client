enum TorrentFilter {
  all('all', 'All'),
  downloading('downloading', 'Downloading'),
  seeding('seeding', 'Seeding'),
  completed('completed', 'Completed'),
  stalled('stalled', 'Stalled'),
  stalledDownloading('stalled_downloading', 'Stalled DL'),
  stalledUploading('stalled_uploading', 'Stalled UL'),
  active('active', 'Active'),
  inactive('inactive', 'Inactive'),
  errored('errored', 'Errored'),
  paused('stopped', 'Stopped');

  const TorrentFilter(this.apiValue, this.label);

  final String apiValue;
  final String label;
}
