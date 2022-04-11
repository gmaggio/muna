import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muna/screens/songs_list/data/song_data.dart';
import 'package:muna/screens/songs_list/providers/songs_provider.dart';
import 'package:muna/src/settings/settings_controller.dart';
import 'package:muna/src/settings/settings_service.dart';

import 'app.dart';

final searchKeywordProvider = StateProvider<String>((ref) {
  return '';
});

final songsSearchProvider = StateProvider<List<SongData>>((ref) {
  final songsState = ref.watch(songsProvider);
  final searchKeyword = ref.watch(searchKeywordProvider);

  return songsState.songs
      .where((element) => element.artist.contains(searchKeyword))
      .toList();
});

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
