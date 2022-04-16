import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muna/screens/songs_list/data/song_data.dart';

class SongsRequestException implements Exception {}

class SongsService {
  static const _baseUrl = 'itunes.apple.com';

  final _client = http.Client();

  SongsService();

  Future<List<SongData>?> fetchSongs(String searchKeywords) async {
    try {
      final _songRequest = Uri.https(
        _baseUrl,
        'search',
        <String, String>{
          'term': searchKeywords,
          'entity': 'musicTrack',
          'attribute': 'artistTerm',
        },
      );

      final _response = await _client.get(_songRequest);

      if (_response.statusCode != 200) {
        throw SongsRequestException();
      }

      final _songsJson = json.decode(_response.body);
      final List<dynamic> _results = _songsJson['results'];

      return _results.map((json) => SongData.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Service Exception: $e');
      rethrow;
    }
  }
}
