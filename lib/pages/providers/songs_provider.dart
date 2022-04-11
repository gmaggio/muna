import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/pages/data/song_data.dart';

class SongState {
  final int page;
  final List<SongData> songs;
  final bool isLoading;
  final bool isLoadMoreError;
  final bool isLoadMoreDone;

  SongState({
    this.songs = const [],
    this.page = 0,
    this.isLoading = false,
    this.isLoadMoreError = false,
    this.isLoadMoreDone = false,
  });
}

final songsProvider = StateNotifierProvider<SongNotifier, SongState>((ref) {
  return SongNotifier();
});

class SongNotifier extends StateNotifier<SongState> {
  SongNotifier() : super(SongState()) {
    // _initSongs();
  }
}
