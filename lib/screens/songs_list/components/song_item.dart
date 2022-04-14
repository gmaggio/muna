import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

/// Creates the container for the song items which consists of the song title,
/// the artist, the album, and the album's artwork.
class SongItem extends StatelessWidget {
  static const _defaultIconSize = MunaStyles.avatarSizePrimary;

  /// The necessary data for the songs.
  final SongData songData;

  const SongItem({
    Key? key,
    required this.songData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _songSelected = ref.watch(songsProvider).songSelected;
        final _isSelected =
            _songSelected != null && _songSelected.trackId == songData.trackId;

        final _theme = Theme.of(context);

        return ListTile(
          key: Key('song-${songData.trackId}'),
          contentPadding: EdgeInsets.zero,

          // The Album Cover
          leading: Container(
            width: _defaultIconSize,
            height: _defaultIconSize,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MunaStyles.borderRadiusSizeSmall),
              border: _isSelected
                  ? Border.all(
                      color: _theme.colorScheme.primary,
                      width: 3,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MunaStyles.borderRadiusSizeSmall / 2,
              ),
              child: Image.network(
                songData.artworkUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          minVerticalPadding: MunaStyles.distancePrimary,
          horizontalTitleGap: MunaStyles.distancePrimary,

          // The Song's Title
          title: Text(
            songData.trackName,
            key: const Key('song-title'),
            style: _theme.textTheme.bodyText2?.copyWith(
              color: _isSelected ? _theme.colorScheme.primaryContainer : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: MunaStyles.distanceShort),

              // The artist
              Text(
                songData.artistName,
                style: _theme.textTheme.subtitle1?.copyWith(
                  color: _isSelected ? _theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: MunaStyles.distanceShorter),

              // The Album Title
              Text(
                songData.collectionName,
                style: _theme.textTheme.caption?.copyWith(
                  color: _isSelected ? _theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // The Song's Active Indicator
          trailing: _isSelected
              ? SizedBox(
                  key: const Key('song-active-indicator'),
                  width: _defaultIconSize,
                  height: _defaultIconSize,
                  child: Icon(
                    Icons.music_note,
                    size: _defaultIconSize,
                    color: _theme.colorScheme.primary,
                  ),
                )
              : null,
          onTap: () {
            _onTapItem(ref);
          },
        );
      },
    );
  }

  // ACTIONS

  /// A callback that calls [selectSong] from [songsProvider] given the [ref].
  ///
  /// When called, it makes sure to unfocus any focused text fields.
  void _onTapItem(WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(songsProvider.notifier).selectSong(songData);
  }
}
