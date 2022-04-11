import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

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
  final _audioPlayer = AudioPlayer();

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
      body: Consumer(
        builder: (context, ref, child) {
          final _isLoading = ref.watch(songsProvider).isLoading;
          final _songs = ref.watch(songsProvider).songs;
          final _songSelected = ref.watch(songsProvider).songSelected;

          return Stack(
            children: [
              if (_songs == null)
                const Center(
                  child: Text('Search an artist'),
                )
              else if (_isLoading == true)
                const _Loading()
              else if (_songs.isEmpty)
                const Center(
                  child: Text('error'),
                )
              else
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
                        child: Image.network(
                          _songs[index].artworkUrl,
                          fit: BoxFit.cover,
                        ),
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
                      trailing: SizedBox(
                        width: 50,
                        height: 50,
                        child: Builder(
                          builder: (context) {
                            if (_songSelected != null &&
                                _songSelected.previewUrl ==
                                    _songs[index].previewUrl) {
                              return const Icon(Icons.music_note);
                            }
                            return Container();
                          },
                        ),
                      ),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await ref
                            .read(songsProvider.notifier)
                            .playSong(_songs[index]);
                      },
                    );
                  },
                ),

              // Music Player
              if (_songSelected != null)
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
                              _songSelected.artworkUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(_songSelected.trackName),
                                Text(_songSelected.artistName),
                                Text(_songSelected.collectionName),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Controls
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
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
        },
      ),
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
