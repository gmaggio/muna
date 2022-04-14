import 'song_data.dart';

class SongState {
  /// Stores the search keywords from the searchbar.
  final String searchKeyword;

  /// The list of song data.
  final List<SongData>? songs;

  /// The currently active song.
  final SongData? songSelected;

  /// Detects the status of the data being loaded.
  final bool isLoading;

  /// Detects the status of the [songSelected] being payed.
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
