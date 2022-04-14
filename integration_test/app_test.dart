import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:muna/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  // Search Keywords
  const _artistSearch1 = 'michael jackson';
  const _artistSearch2 = 'mariah';
  const _artistNotFoundSearch = 'zzzzzzzz';

  // Keys
  const _startIndicatorKey = Key('start-indicator');
  const _notFoundIndicatorKey = Key('not-found-indicator');
  const _searchFieldClearKey = Key('search-field-clear');
  const _dataFetchingIndicatorKey = Key('data-fetching-indicator');
  const _songTitleKey = Key('song-title');
  const _songActiveIndicatorKey = Key('song-active-indicator');
  const _musicPlayerKey = Key('music-player');
  const _musicDetailTitleKey = Key('music-detail-title');
  const _musicFetchingIndicator = Key('music-fetching-indicator');
  const _musicControlPlayKey = Key('music-control-play');
  const _musicControlPauseKey = Key('music-control-pause');
  const _musicControlReplayKey = Key('music-control-replay');

  group(
    'Muna App Test',
    () {
      testWidgets(
        'Test the music search bar\'s functionality and searchability',
        (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(
            find.byKey(_startIndicatorKey),
            findsOneWidget,
            reason: 'The initial view should be displayed',
          );

          var _textField = find.byType(TextField);
          var _textFieldController =
              (_textField.evaluate().first.widget as TextField).controller;

          await tester.enterText(_textField, _artistSearch1);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pump();

          expect(
            find.byKey(_dataFetchingIndicatorKey),
            findsOneWidget,
            reason: 'A page loader should be displayed',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            tester.widgetList(find.byType(ListTile)).length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          await tester.tap(find.byKey(_searchFieldClearKey));
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          expect(
            _textFieldController!.text.length,
            isZero,
            reason: 'The search bar should be cleared',
          );

          await tester.enterText(_textField, _artistNotFoundSearch);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.byKey(_notFoundIndicatorKey),
            findsOneWidget,
            reason:
                'A message should be displayed indicating no result was found',
          );
        },
      );

      testWidgets(
        'Test the music selection process and the music player',
        (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(
            find.byKey(_startIndicatorKey),
            findsOneWidget,
            reason: 'The initial view should be displayed',
          );

          await tester.enterText(find.byType(TextField), _artistSearch1);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          var _songsFound = tester.widgetList(find.byType(ListTile));

          expect(
            _songsFound.length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          var _firstSong = _songsFound.first;
          var _firstSongKey = _firstSong.key;
          var _firstSongWidget = find.byKey(_firstSongKey!);
          var _firstSongTitleWidget = find.descendant(
            of: _firstSongWidget,
            matching: find.byKey(_songTitleKey),
          );
          var _firstSongTitle =
              (_firstSongTitleWidget.evaluate().single.widget as Text).data;

          await tester.tap(find.byWidget(_firstSong));
          await tester.pump();

          expect(
            find.descendant(
              of: _firstSongWidget,
              matching: find.byKey(_songActiveIndicatorKey),
            ),
            findsOneWidget,
            reason:
                'An icon should be displayed in the selected music indicating '
                'the currently active song',
          );

          var _musicPlayer = find.byKey(_musicPlayerKey);
          var _musicDetailTitleWidget = find.descendant(
            of: _musicPlayer,
            matching: find.byKey(_musicDetailTitleKey),
          );
          var _musicDetailTitle =
              (_musicDetailTitleWidget.evaluate().single.widget as Text).data;

          expect(
            _musicPlayer,
            findsOneWidget,
            reason: 'The music player in the footer should be visible',
          );

          expect(
            _musicDetailTitle,
            _firstSongTitle,
            reason:
                'The title in the music player should be the same as the title '
                'in the selected music',
          );

          await tester.pump();

          expect(
            find.descendant(
              of: _musicPlayer,
              matching: find.byKey(_musicFetchingIndicator),
            ),
            findsOneWidget,
            reason: 'A music loader should be displayed in the music player',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.descendant(
              of: _musicPlayer,
              matching: find.byKey(_musicControlPauseKey),
            ),
            findsOneWidget,
            reason:
                'A pause button should be displayed in the music player indicating '
                'a music is playing',
          );

          await tester.pumpAndSettle(const Duration(seconds: 15));
          await tester.tap(find.byKey(_musicControlPauseKey));
          await tester.pump();

          expect(
            find.byKey(_musicControlPlayKey),
            findsOneWidget,
            reason:
                'A play button should be displayed in the music player indicating '
                'a music is paused',
          );

          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          await tester.tap(find.byKey(_musicControlPlayKey));
          await tester.pumpAndSettle(const Duration(seconds: 15));

          expect(
            find.byKey(_musicControlReplayKey),
            findsOneWidget,
            reason:
                'A replay button should be displayed in the music player indicating '
                'the music has reached the end',
          );

          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          await tester.tap(find.byKey(_musicControlReplayKey));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            find.byKey(_musicControlPauseKey),
            findsOneWidget,
            reason:
                'A pause button should be displayed in the music player indicating '
                'a music is playing again from the start',
          );

          var _textField = find.byType(TextField);

          await tester.tap(find.byKey(_searchFieldClearKey));
          await tester.enterText(_textField, _artistSearch2);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            _firstSongWidget,
            findsNothing,
            reason:
                'The music from the previous search should not be available',
          );

          expect(
            tester.widgetList(find.byType(ListTile)).length,
            greaterThan(0),
            reason: 'A list of new results should be found',
          );

          expect(
            _musicPlayer,
            findsOneWidget,
            reason: 'The music player in the footer should still be visible',
          );

          expect(
            _musicDetailTitle,
            _firstSongTitle,
            reason:
                'The title in the music player should still be the same as the title '
                'in the previous selected music',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));
        },
      );
    },
  );
}
