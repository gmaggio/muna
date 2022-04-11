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
  final _addTodoKey = UniqueKey();
  final _newTodoController = TextEditingController();
  final ScrollController _controller = ScrollController();

  int _songsLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Search Bar
        title: TextField(
          key: _addTodoKey,
          controller: _newTodoController,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search artist',
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: null,
            ),
          ),
          onChanged: (value) {
            ref.read(searchKeywordProvider.notifier).state = value;
          },
          onSubmitted: (value) {},
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        final _isLoadMoreError = ref.watch(songsProvider).isLoadMoreError;
        final _isLoadMoreDone = ref.watch(songsProvider).isLoadMoreDone;
        final _isLoading = ref.watch(songsProvider).isLoading;
        final _songs = ref.watch(songsSearchProvider.notifier).state;

        // Update songs counter
        _songsLength = _songs.length;

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
                    child: Image.network(_songs[index].albumCover),
                  ),
                  title: Text(_songs[index].songTitle),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(_songs[index].artist),
                      Text(_songs[index].albumTitle),
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
