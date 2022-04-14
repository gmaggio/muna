import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/utilities/styles.dart';

class SearchBar extends StatefulHookConsumerWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  late TextEditingController _searchFieldController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _searchFieldController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _searchKeyword = ref.watch(songsProvider).searchKeyword;

    final _screenTopPadding = MediaQuery.of(context).padding.top;
    final _theme = Theme.of(context);

    final _defaultContentColor = _theme.colorScheme.onPrimary;

    return DefaultTextStyle.merge(
      style: TextStyle(
        color: _defaultContentColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(MunaStyles.distanceScreenMargin).copyWith(
          top: 20 + _screenTopPadding,
        ),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(MunaStyles.borderRadiusSizePrimary),
            bottomRight: Radius.circular(MunaStyles.borderRadiusSizePrimary),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Builder(
          builder: (context) {
            final _fieldBorder = UnderlineInputBorder(
              borderSide: BorderSide(
                color: _defaultContentColor.withOpacity(.7),
              ),
            );

            return TextField(
              focusNode: _focusNode,
              controller: _searchFieldController,
              style: _theme.textTheme.bodyText1?.copyWith(
                color: _defaultContentColor,
              ),
              cursorColor: _defaultContentColor,
              decoration: InputDecoration(
                border: _fieldBorder,
                focusedBorder: _fieldBorder,
                hintStyle: TextStyle(
                  color: _defaultContentColor.withOpacity(.7),
                ),
                hintText: 'Search artist . . .',
                suffixIconColor: _defaultContentColor,
                suffixIcon: IconButton(
                  icon: _searchKeyword.isEmpty
                      ? Icon(
                          Icons.search,
                          color: _defaultContentColor.withOpacity(.7),
                        )
                      : Icon(
                          Icons.close,
                          color: _defaultContentColor,
                        ),
                  onPressed: () {
                    if (_searchKeyword.isNotEmpty) {
                      _searchFieldController.clear();
                      FocusScope.of(context).requestFocus(_focusNode);
                      ref.read(songsProvider.notifier).updateSearchKeyword('');
                    }
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                ref.read(songsProvider.notifier).updateSearchKeyword(text);
              },
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
        ),
      ),
    );
  }
}
