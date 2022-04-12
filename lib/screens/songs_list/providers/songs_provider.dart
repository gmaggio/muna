import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/data/song_state.dart';
import 'package:muna/screens/songs_list/services/songs_service.dart';

final songsProvider = StateNotifierProvider<SongNotifier, SongState>((ref) {
  return SongNotifier();
});

class SongNotifier extends StateNotifier<SongState> {
  SongNotifier() : super(SongState());

  final _songsService = SongsService();
  final _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

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

  selectSong(SongData song) async {
    state = state.copyWith(
      songSelected: song,
      isPlaying: true,
    );
    playSong(song.previewUrl);
  }

  playSong(String previewUrl) async {
    _audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse(previewUrl),
      ),
      preload: true,
    )
        .catchError((error) {
      // catch load errors: 404, invalid url ...
    });

    await _audioPlayer.play();
  }
}
