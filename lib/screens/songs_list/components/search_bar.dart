import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';

final _searchFieldController = TextEditingController();

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return TextField(
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
        );
      },
    );
  }
}
