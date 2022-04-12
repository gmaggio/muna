import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _songSelected = ref.watch(songsProvider).songSelected;
        final _audioPlayer = ref.read(songsProvider.notifier).audioPlayer;

        if (_songSelected == null) return Container();

        return DefaultTextStyle.merge(
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
                // IconButton(
                //   icon: const Icon(Icons.play_arrow),
                //   color: Colors.white,
                //   onPressed: () {},
                // ),
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (_, snapshot) {
                    final playerState = snapshot.data;
                    return _playPauseButton(
                      playerState: playerState,
                      audioPlayer: _audioPlayer,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _playPauseButton({
    required PlayerState? playerState,
    required AudioPlayer audioPlayer,
  }) {
    final processingState = playerState?.processingState;

    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(),
      );
    } else if (audioPlayer.playing != true) {
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64.0,
        onPressed: () => audioPlayer.seek(
          Duration.zero,
          index: audioPlayer.effectiveIndices?.first,
        ),
      );
    }
  }
}
