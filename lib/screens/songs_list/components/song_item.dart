import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

class SongItem extends StatelessWidget {
  static const _defaultIconSize = MunaStyles.avatarSizePrimary;

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
          title: Text(
            songData.trackName,
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
              Text(
                songData.artistName,
                style: _theme.textTheme.subtitle1?.copyWith(
                  color: _isSelected ? _theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: MunaStyles.distanceShorter),
              Text(
                songData.collectionName,
                style: _theme.textTheme.caption?.copyWith(
                  color: _isSelected ? _theme.colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: _isSelected
              ? SizedBox(
                  key: const Key('song-playing-indicator'),
                  width: _defaultIconSize,
                  height: _defaultIconSize,
                  child: Icon(
                    Icons.music_note,
                    size: _defaultIconSize,
                    color: _theme.colorScheme.primary,
                  ),
                )
              : null,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await ref.read(songsProvider.notifier).selectSong(songData);
          },
        );
      },
    );
  }
}
