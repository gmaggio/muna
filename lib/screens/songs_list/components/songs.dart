import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

import 'song_item.dart';

class Songs extends StatelessWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _isLoading = ref.watch(songsProvider).isLoading;
        final _songs = ref.watch(songsProvider).songs;

        final _screenVerticalHeight = MediaQuery.of(context).size.height;

        // Pre-data handling
        if (_isLoading == true) {
          return const _Loading();
        } else if (_songs == null) {
          return Center(
            child: Icon(
              Icons.arrow_circle_up,
              key: const Key('start_icon_indicator'),
              size: 100,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(.5),
            ),
          );
        } else if (_songs.isEmpty) {
          return const Center(
            child: Text('Music not found'),
          );
        }
        return ListView.builder(
          restorationId: 'SongsList',
          padding: const EdgeInsets.all(
            MunaStyles.distanceScreenMargin,
          ).copyWith(
            top: MunaStyles.distancePrimary,
            bottom: _screenVerticalHeight * (20 / 100),
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

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
