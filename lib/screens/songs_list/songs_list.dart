import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/main.dart';

import 'providers/songs_provider.dart';

class SongsList extends StatefulHookConsumerWidget {
  static const routeName = '/';

  const SongsList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongsListState();
}

class _SongsListState extends ConsumerState<SongsList> {
  final _searchFieldKey = UniqueKey();
  final _searchFieldController = TextEditingController();
  final _scrollController = ScrollController();

  int _songsCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Search Bar
        title: TextField(
          key: _searchFieldKey,
          controller: _searchFieldController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search artist',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchFieldController.clear();
              },
            ),
          ),
          textInputAction: TextInputAction.done,
          onEditingComplete: () async {
            if (_searchFieldController.text.isNotEmpty) {
              final _keywords = _searchFieldController.text;
              await ref
                  .read(songsProvider.notifier)
                  .searchSongsByArtist(_keywords);
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        final _isLoading = ref.watch(songsProvider).isLoading;
        final _songs = ref.watch(songsSearchProvider.notifier).state;

        // Update songs counter
        _songsCount = _songs.length;

        if (_songs.isEmpty) {
          if (_isLoading == false) {
            return const Center(
              child: Text('error'),
            );
          }
          return const _Loading();
        }

        return Stack(
          children: [
            // Music List
            ListView.builder(
              restorationId: 'SongsList',
              itemCount: _songs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(_songs[index].artworkUrl),
                  ),
                  title: Text(_songs[index].trackName),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(_songs[index].artistName),
                      Text(_songs[index].collectionName),
                    ],
                  ),
                  onTap: () {
                    debugPrint('----> Handle play song');
                  },
                );
              },
            ),

            // Music Player
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Song Details
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          'https://via.placeholder.com/100',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Text('Jack Johnson'), // Artist
                            Text('In Between Dreams'), // Album
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Controls
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
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
