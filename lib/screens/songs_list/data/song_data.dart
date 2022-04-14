import 'dart:convert';

class SongData {
  final int? trackId;
  final String trackName;
  final String artworkUrl;
  final String artistName;
  final String collectionName;
  final String previewUrl;

  SongData({
    this.trackId,
    this.artworkUrl = '',
    this.trackName = '',
    this.artistName = '',
    this.collectionName = '',
    this.previewUrl = '',
  });

  @override
  String toString() {
    return 'SongData(trackId: $trackId, trackName: $trackName, artworkUrl: $artworkUrl, artistName: $artistName, collectionName: $collectionName, previewUrl: $previewUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'trackName': trackName,
      'artworkUrl': artworkUrl,
      'artistName': artistName,
      'collectionName': collectionName,
      'previewUrl': previewUrl,
    };
  }

  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      trackId: map['trackId'] ?? '',
      trackName: map['trackName'] ?? '',
      artworkUrl: map['artworkUrl100'] ?? '',
      artistName: map['artistName'] ?? '',
      collectionName: map['collectionName'] ?? '',
      previewUrl: map['previewUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongData.fromJson(dynamic source) =>
      SongData.fromMap(json.decode(source));
}
