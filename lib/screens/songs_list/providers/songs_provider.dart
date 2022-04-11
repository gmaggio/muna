import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/data/song_data.dart';

class SongState {
  final int page;
  final List<SongData> songs;
  final SongData? songSelected;
  final bool isLoading;
  final bool isLoadMoreError;
  final bool isLoadMoreDone;

  SongState({
    this.page = 0,
    this.songs = const [],
    this.songSelected,
    this.isLoading = false,
    this.isLoadMoreError = false,
    this.isLoadMoreDone = false,
  });
}

final songsProvider = StateNotifierProvider<SongNotifier, SongState>((ref) {
  return SongNotifier();
});

class SongNotifier extends StateNotifier<SongState> {
  SongNotifier() : super(SongState());
}
