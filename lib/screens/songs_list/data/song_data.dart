import 'dart:convert';

class SongData {
  final String artworkUrl;
  final String trackName;
  final String artistName;
  final String collectionName;
  final String previewUrl;

  SongData({
    this.artworkUrl = '',
    this.trackName = '',
    this.artistName = '',
    this.collectionName = '',
    this.previewUrl = '',
  });

  @override
  String toString() {
    return 'SongData(artworkUrl: $artworkUrl, trackName: $trackName, artistName: $artistName, collectionName: $collectionName, previewUrl: $previewUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'artworkUrl': artworkUrl,
      'trackName': trackName,
      'artistName': artistName,
      'collectionName': collectionName,
      'previewUrl': previewUrl,
    };
  }

  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      artworkUrl: map['artworkUrl100'] ?? '',
      trackName: map['trackName'] ?? '',
      artistName: map['artistName'] ?? '',
      collectionName: map['collectionName'] ?? '',
      previewUrl: map['previewUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongData.fromJson(dynamic source) =>
      SongData.fromMap(json.decode(source));
}
