import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/data/song_state.dart';
import 'package:muna/screens/songs_list/services/songs_service.dart';

final songsProvider = StateNotifierProvider<SongNotifier, SongState>((ref) {
  return SongNotifier();
});

class SongNotifier extends StateNotifier<SongState> {
  SongNotifier() : super(SongState());

  final _songsService = SongsService();

  searchSongsByArtist(String keywords) async {
    state = state.copyWith(
      isLoading: true,
    );

    final _keywords = keywords.replaceAll(RegExp(' '), '+');
    final _songs = await _songsService.fetchSongs(_keywords);

    if (_songs == null) {
      state = state.copyWith(
        songs: _songs,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(
      songs: _songs,
      isLoading: false,
    );
  }

  playSong(SongData song) async {
    state = state.copyWith(
      songSelected: song,
    );
  }
}
