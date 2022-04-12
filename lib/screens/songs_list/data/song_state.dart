import 'song_data.dart';

class SongState {
  final List<SongData>? songs;
  final SongData? songSelected;
  final bool isLoading;
  final bool isPlaying;

  SongState({
    this.songs,
    this.songSelected,
    this.isLoading = false,
    this.isPlaying = false,
  });

  SongState copyWith({
    List<SongData>? songs,
    SongData? songSelected,
    bool? isLoading,
    bool? isPlaying,
  }) {
    return SongState(
      songs: songs ?? this.songs,
      songSelected: songSelected ?? this.songSelected,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
