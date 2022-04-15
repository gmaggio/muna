# Muna

Muna is a music search demo app using iTunes search API.

## Features

- Search songs by artists
- Display songs list as the search result
- Music player with song details and audio controller

## Download & Install

First, clone the repository with the 'clone' command, or just download the zip.

```
$ git clone https://github.com/gmaggio/muna.git
```

Then, download either Android Studio or Visual Studio Code, with their respective [Flutter editor plugins](https://flutter.io/get-started/editor/). For more information about Flutter installation procedure, check the [official installation guide](https://flutter.io/get-started/install/).

Install dependencies from pubspec.yaml by running `flutter packages get` from the project root (see [using packages documentation](https://flutter.io/using-packages/#adding-a-package-dependency-to-an-app) for details and how to do this in the editor).

You can now open & edit the project.

## Supported Devices

This app is supported on Android with a minimum version of Android KitKat (4.4) or API level 19 and above.

## Requirements to build the app

* Flutter SDK
* [iTunes Search API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api) to provide the list of songs
* [Riverpod](https://pub.dev/packages/riverpod) to manage the state of the app
* [Just Audio](https://pub.dev/packages/just_audio) to play the song
* [Google Fonts](https://pub.dev/packages/google_fonts) to display the fonts

## How to run the integration test

To run the integration test, on your terminal:
*  type ```flutter test integration_test/app_test.dart``` to run on the emulator
*  type ```flutter drive --driver integration_test/driver.dart --target integration_test/app_test.dart --profile --no-dds``` to run on a device

## How to build the app

To build the app, on your terminal:
* type ```flutter run --target=lib/main.dart``` to build the debug version of the app
* type ```flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols``` to build the release version of the app
