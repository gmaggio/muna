import 'song_data.dart';

class SongState {
  final String searchKeyword;
  final List<SongData>? songs;
  final SongData? songSelected;
  final bool isLoading;
  final bool isPlaying;

  SongState({
    this.searchKeyword = '',
    this.songs,
    this.songSelected,
    this.isLoading = false,
    this.isPlaying = false,
  });

  SongState copyWith({
    String? searchKeyword,
    List<SongData>? songs,
    SongData? songSelected,
    bool? isLoading,
    bool? isPlaying,
  }) {
    return SongState(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      songs: songs ?? this.songs,
      songSelected: songSelected ?? this.songSelected,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
