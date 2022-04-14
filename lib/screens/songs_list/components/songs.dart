import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

import 'song_item.dart';

/// Creates a list of songs presented in [SongItem]s.
class Songs extends StatelessWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _isLoading = ref.watch(songsProvider).isLoading;
        final _songs = ref.watch(songsProvider).songs;
        final _songSelected = ref.watch(songsProvider).songSelected;

        final _screenVerticalHeight = MediaQuery.of(context).size.height;
        final _bottomOffset = _screenVerticalHeight * (20 / 100);

        // Pre-data handling
        if (_isLoading == true) {
          return const _Loading();
        } else if (_songs == null) {
          return Center(
            child: Icon(
              Icons.arrow_circle_up,
              key: const Key('start-indicator'),
              size: 100,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(.5),
            ),
          );
        } else if (_songs.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _songSelected != null ? _bottomOffset : 0,
              ),
              child: const Text(
                'MUSIC NOT FOUND',
                key: Key('not-found-indicator'),
              ),
            ),
          );
        }

        return ListView.builder(
          restorationId: 'SongsList',
          padding: const EdgeInsets.all(
            MunaStyles.distanceScreenMargin,
          ).copyWith(
            top: MunaStyles.distancePrimary,
            bottom: _bottomOffset,
          ),
          itemCount: _songs.length,
          itemBuilder: (BuildContext context, int index) {
            return SongItem(
              songData: _songs[index],
            );
          },
        );
      },
    );
  }
}

// COMPONENTS

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        key: Key('data-fetching-indicator'),
      ),
    );
  }
}
