import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/data/song_state.dart';
import 'package:muna/screens/songs_list/services/songs_service.dart';

final songsProvider = StateNotifierProvider<SongNotifier, SongState>((ref) {
  return SongNotifier();
});

class SongNotifier extends StateNotifier<SongState> {
  SongNotifier() : super(SongState());

  final _songsService = SongsService();

  searchSongsByArtist(String keywords) async {
    final songs = await _songsService.fetchSongs(keywords);

    print('------> songs: $songs');

    if (songs == null) {
      state = state.copyWith(
        songs: songs,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(
      songs: songs,
      isLoading: false,
    );
  }
}
