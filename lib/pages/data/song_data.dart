import 'dart:convert';

class SongData {
  final String albumCover;
  final String songTitle;
  final String artist;
  final String albumTitle;
  final String songPreview;

  SongData({
    this.albumCover = '',
    this.songTitle = '',
    this.artist = '',
    this.albumTitle = '',
    this.songPreview = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'albumCover': albumCover,
      'songTitle': songTitle,
      'artist': artist,
      'albumTitle': albumTitle,
      'songPreview': songPreview,
    };
  }

  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      albumCover: map['albumCover'] ?? '',
      songTitle: map['songTitle'] ?? '',
      artist: map['artist'] ?? '',
      albumTitle: map['albumTitle'] ?? '',
      songPreview: map['songPreview'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongData.fromJson(String source) =>
      SongData.fromMap(json.decode(source));
}
