import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/music_player.dart';
import 'components/search_bar.dart';
import 'components/songs.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Search Bar
        title: const SearchBar(),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Stack(
            children: const [
              Songs(),

              // Footer
              Positioned(
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
