import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';

class Songs extends StatelessWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _isLoading = ref.watch(songsProvider).isLoading;
        final _songs = ref.watch(songsProvider).songs;
        final _songSelected = ref.watch(songsProvider).songSelected;

        // Pre-data handling
        if (_isLoading == true) {
          return const _Loading();
        } else if (_songs == null) {
          return const Center(
            child: Text('Search music'),
          );
        } else if (_songs.isEmpty) {
          return const Center(
            child: Text('Music not found'),
          );
        }
        return ListView.builder(
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
                        _songSelected.previewUrl == _songs[index].previewUrl) {
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
                    .selectSong(_songs[index]);
              },
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
