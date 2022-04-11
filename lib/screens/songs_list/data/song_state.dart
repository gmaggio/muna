import 'song_data.dart';

class SongState {
  final List<SongData> songs;
  final SongData? songSelected;
  final bool isLoading;

  SongState({
    this.songs = const [],
    this.songSelected,
    this.isLoading = false,
  });

  SongState copyWith({
    List<SongData>? songs,
    SongData? songSelected,
    bool? isLoading,
  }) {
    return SongState(
      songs: songs ?? this.songs,
      songSelected: songSelected ?? this.songSelected,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
