import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muna/utilities/styles.dart';

final ThemeData munaThemeLight = munaTheme(ThemeData.light());

ThemeData munaTheme(ThemeData themeBase) {
  final ThemeData base = themeBase;

  return base.copyWith(
    brightness: Brightness.light,
    colorScheme: _colorScheme(base.colorScheme),
    scaffoldBackgroundColor: MunaStyles.colorBackground,
    textTheme: _textTheme(base.textTheme),
    textSelectionTheme: _textSelectionTheme(base.textSelectionTheme),
  );
}

ColorScheme _colorScheme(ColorScheme base) => base.copyWith(
      primary: MunaStyles.colorPrimary,
      primaryContainer: MunaStyles.colorPrimaryVariant,
      secondary: MunaStyles.colorSecondary,
      secondaryContainer: MunaStyles.colorSecondaryVariant,
      background: MunaStyles.colorBackground,
      surface: MunaStyles.colorCanvas,
      onPrimary: MunaStyles.colorOnPrimary,
      onSecondary: MunaStyles.colorOnSecondary,
      onBackground: MunaStyles.colorOnBackground,
      onSurface: MunaStyles.colorOnCanvas,
    );

TextTheme _textTheme(TextTheme base) {
  final _base = GoogleFonts.montserratTextTheme(base);

  return _base.copyWith(
    bodyText1: _base.bodyText1?.copyWith(
      color: MunaStyles.fontColorPrimary,
      fontSize: MunaStyles.fontSizeLarge,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: _base.bodyText2?.copyWith(
      color: MunaStyles.fontColorPrimary,
      fontSize: MunaStyles.fontSizePrimary,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: _base.caption?.copyWith(
      color: MunaStyles.fontColorSecondary,
      fontSize: MunaStyles.fontSizeSecondary,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: _base.caption?.copyWith(
      color: MunaStyles.fontColorSecondaryVariant,
      fontSize: MunaStyles.fontSizeSecondary,
      fontWeight: FontWeight.bold,
    ),
    caption: _base.caption?.copyWith(
      color: MunaStyles.fontColorSecondary,
      fontSize: MunaStyles.fontSizeSmall,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextSelectionThemeData? _textSelectionTheme(TextSelectionThemeData base) =>
    base.copyWith(
      selectionHandleColor: MunaStyles.colorSecondary.withOpacity(.7),
    );
