import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muna/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  // Search Keywords
  const _artistOneSearch = 'michael jackson';
  const _artistTwoSearch = 'mariah';
  const _artistNotFoundSearch = 'zzzzzzzz';

  // Data
  const _artistOneTrackId1 = 1440912105;
  const _artistOneTrackId2 = 159294478;

  // Keys
  const _startIndicatorKey = Key('start-indicator');
  const _notFoundIndicator = Key('not-found-indicator');
  const _musicPlayer = Key('music-player');
  const _dataFetchingIndicator = Key('data-fetching-indicator');
  const _songPlayingIndicator = Key('song-playing-indicator');
  const _musicFetchingIndicator = Key('music-fetching-indicator');
  const _musicControlPlay = Key('music-control-play');
  const _musicControlPause = Key('music-control-pause');
  const _musicControlReplay = Key('music-control-replay');

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

          await tester.enterText(_textField, _artistOneSearch);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pump();

          expect(
            find.byKey(_dataFetchingIndicator),
            findsOneWidget,
            reason: 'A page loader should be displayed',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            tester.widgetList(find.byType(ListTile)).length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          await tester.tap(find.byIcon(Icons.close));
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
            find.byKey(_notFoundIndicator),
            findsOneWidget,
            reason:
                'A message should be displayed indicating no result was found',
          );
        },
      );

      testWidgets(
        'Test the music selection process',
        (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(
            find.byKey(_startIndicatorKey),
            findsOneWidget,
            reason: 'The initial view should be displayed',
          );

          await tester.enterText(find.byType(TextField), _artistOneSearch);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          var _songsFound = tester.widgetList(find.byType(ListTile));

          expect(
            _songsFound.length,
            greaterThan(0),
            reason: 'A list of results should be found',
          );

          var _firstSong = _songsFound.first;

          await tester.tap(find.byWidget(_firstSong));
          await tester.pump();

          expect(
            find.descendant(
              of: find.byKey(_firstSong.key!),
              matching: find.byKey(_songPlayingIndicator),
            ),
            findsOneWidget,
            reason:
                'An icon should be displayed in the selected music indicating the currently active song',
          );

          expect(
            find.byKey(_musicPlayer),
            findsOneWidget,
            reason: 'The music player in the footer should be visible',
          );

          await tester.pump();

          expect(
            find.descendant(
              of: find.byKey(_musicPlayer),
              matching: find.byKey(_musicFetchingIndicator),
            ),
            findsOneWidget,
            reason: 'A music loader should be displayed in the music player',
          );

          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(
            find.descendant(
              of: find.byKey(_musicPlayer),
              matching: find.byKey(_musicControlPause),
            ),
            findsOneWidget,
            reason:
                'A pause button should be displayed in the music player indicating a music is playing',
          );
        },
      );
    },
  );
}
