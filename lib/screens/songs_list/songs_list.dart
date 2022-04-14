import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/music_player.dart';
import 'components/search_bar.dart';
import 'components/songs.dart';

/// Displays the app main screen which consists of a list of songs, a searchbar,
/// and a music player.
class SongsList extends StatefulHookConsumerWidget {
  static const routeName = '/';

  const SongsList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongsListState();
}

class _SongsListState extends ConsumerState<SongsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SearchBar(),
                  Expanded(
                    child: Songs(),
                  ),
                ],
              ),

              // Footer
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MusicPlayer(),
              ),
            ],
          );
        },
      ),
    );
  }
}
