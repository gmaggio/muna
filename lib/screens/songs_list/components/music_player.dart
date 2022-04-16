import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

/// Creates a music player that consists of the songs details and the music
/// controller.
class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    Key? key,
  }) : super(key: key);

  static const _defaultIconSize = MunaStyles.avatarSizePrimary;

  @override
  Widget build(BuildContext context) {
    final _screenBottomPadding = MediaQuery.of(context).padding.bottom;
    final _theme = Theme.of(context);

    final _defaultContentColor = _theme.colorScheme.onSecondary;

    return DefaultTextStyle.merge(
      style: TextStyle(
        color: _defaultContentColor,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final _songSelected = ref.watch(songsProvider).songSelected;
          final _audioPlayer = ref.read(songsProvider.notifier).audioPlayer;

          if (_songSelected == null) return Container();

          return Container(
            key: const Key('music-player'),
            decoration: BoxDecoration(
              color: _theme.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MunaStyles.borderRadiusSizePrimary),
                topRight: Radius.circular(MunaStyles.borderRadiusSizePrimary),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(
              horizontal: MunaStyles.distanceScreenMargin,
            ).copyWith(
              top: MunaStyles.distancePrimary,
              bottom: MunaStyles.distancePrimary + _screenBottomPadding,
            ),
            child: Row(
              children: [
                ..._musicDetails(
                  theme: _theme,
                  songSelected: _songSelected,
                ),
                const SizedBox(width: MunaStyles.distancePrimary),

                // Controls
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final _playerState = snapshot.data;

                    return _musicController(
                      context,
                      playerState: _playerState,
                      audioPlayer: _audioPlayer,
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // COMPONENTS

  List<Widget> _musicDetails({
    required ThemeData theme,
    required SongData songSelected,
  }) {
    return [
      Container(
        width: MunaStyles.avatarSizePrimary + 3,
        height: MunaStyles.avatarSizePrimary + 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.onPrimary,
            width: 3,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            songSelected.artworkUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: MunaStyles.distancePrimary),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              songSelected.trackName,
              key: const Key('music-detail-title'),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: MunaStyles.distanceShort),
            Text(
              songSelected.artistName,
              style: theme.textTheme.subtitle2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: MunaStyles.distanceShorter),
            Text(
              songSelected.collectionName,
              style: theme.textTheme.caption?.copyWith(
                color: theme.textTheme.subtitle2?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )
    ];
  }

  Widget _musicController(
    BuildContext context, {
    required PlayerState? playerState,
    required AudioPlayer audioPlayer,
  }) {
    final _processingState = playerState?.processingState;

    if (_processingState == ProcessingState.loading ||
        _processingState == ProcessingState.buffering) {
      return SizedBox(
        key: const Key('music-fetching-indicator'),
        width: _defaultIconSize,
        height: _defaultIconSize,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    } else if (_processingState == ProcessingState.idle ||
        _processingState == ProcessingState.completed) {
      return _musicControllerButton(
        context,
        key: 'replay',
        icon: Icons.replay,
        onPressed: () => _onReplay(audioPlayer),
      );
    } else {
      if (audioPlayer.playing != true) {
        return _musicControllerButton(
          context,
          key: 'play',
          icon: Icons.play_arrow,
          onPressed: audioPlayer.play,
        );
      } else {
        return _musicControllerButton(
          context,
          key: 'pause',
          icon: Icons.pause,
          onPressed: audioPlayer.pause,
        );
      }
    }
  }

  Widget _musicControllerButton(
    BuildContext context, {
    required String key,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      key: Key('music-control-$key'),
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      padding: EdgeInsets.zero,
      iconSize: _defaultIconSize,
      onPressed: onPressed,
    );
  }

  // ACTIONS

  void _onReplay(AudioPlayer audioPlayer) {
    if (audioPlayer.processingState == ProcessingState.idle) {
      if (audioPlayer.playing) audioPlayer.pause();
      audioPlayer.play();
    } else {
      audioPlayer.seek(
        Duration.zero,
        index: audioPlayer.effectiveIndices?.first,
      );
    }
  }
}
