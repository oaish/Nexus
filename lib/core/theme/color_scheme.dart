import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00696e),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9cf0f6),
      onPrimaryContainer: Color(0xff002022),
      secondary: Color(0xff38608f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd2e4ff),
      onSecondaryContainer: Color(0xff001c37),
      tertiary: Color(0xff006a66),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9df1eb),
      onTertiaryContainer: Color(0xff00201e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3f4949),
      outline: Color(0xff6f7979),
      outlineVariant: Color(0xffbec8c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xff80d4da),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff002022),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001c37),
      secondaryFixedDim: Color(0xffa2c9fe),
      onSecondaryFixedVariant: Color(0xff1d4875),
      tertiaryFixed: Color(0xff9df1eb),
      onTertiaryFixed: Color(0xff00201e),
      tertiaryFixedDim: Color(0xff80d5cf),
      onTertiaryFixedVariant: Color(0xff00504c),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004b4f),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff238086),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff174471),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5077a6),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff004b48),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff25817c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3b4545),
      outline: Color(0xff576161),
      outlineVariant: Color(0xff737d7d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xff80d4da),
      primaryFixed: Color(0xff238086),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00666b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5077a6),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff365e8c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff25817c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006763),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002729),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004b4f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002343),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff174471),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002725),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004b48),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1c2626),
      outline: Color(0xff3b4545),
      outlineVariant: Color(0xff3b4545),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xffa9faff),
      primaryFixed: Color(0xff004b4f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003235),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff174471),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff002e54),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004b48),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003331),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d4da),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff003739),
      primaryContainer: Color(0xff004f53),
      onPrimaryContainer: Color(0xff9cf0f6),
      secondary: Color(0xffa2c9fe),
      onSecondary: Color(0xff00325a),
      secondaryContainer: Color(0xff1d4875),
      onSecondaryContainer: Color(0xffd2e4ff),
      tertiary: Color(0xff80d5cf),
      onTertiary: Color(0xff003734),
      tertiaryContainer: Color(0xff00504c),
      onTertiaryContainer: Color(0xff9df1eb),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111418),
      onSurface: Color(0xffe1e2e8),
      onSurfaceVariant: Color(0xffbec8c9),
      outline: Color(0xff899393),
      outlineVariant: Color(0xff3f4949),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff00696e),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff002022),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001c37),
      secondaryFixedDim: Color(0xffa2c9fe),
      onSecondaryFixedVariant: Color(0xff1d4875),
      tertiaryFixed: Color(0xff9df1eb),
      onTertiaryFixed: Color(0xff00201e),
      tertiaryFixedDim: Color(0xff80d5cf),
      onTertiaryFixedVariant: Color(0xff00504c),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff84d8de),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff001a1c),
      primaryContainer: Color(0xff479da3),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffa9cdff),
      onSecondary: Color(0xff00172f),
      secondaryContainer: Color(0xff6c93c4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff85d9d3),
      onTertiary: Color(0xff001a19),
      tertiaryContainer: Color(0xff489e99),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc3cdcd),
      outline: Color(0xff9ba5a5),
      outlineVariant: Color(0xff7b8585),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff005054),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff001416),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff003d40),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001226),
      secondaryFixedDim: Color(0xffa2c9fe),
      onSecondaryFixedVariant: Color(0xff013764),
      tertiaryFixed: Color(0xff9df1eb),
      onTertiaryFixed: Color(0xff001413),
      tertiaryFixedDim: Color(0xff80d5cf),
      onTertiaryFixedVariant: Color(0xff003d3b),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffedfeff),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff84d8de),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffafaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa9cdff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeafffc),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff85d9d3),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff3fdfd),
      outline: Color(0xffc3cdcd),
      outlineVariant: Color(0xffc3cdcd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff003032),
      primaryFixed: Color(0xffa1f5fa),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff84d8de),
      onPrimaryFixedVariant: Color(0xff001a1c),
      secondaryFixed: Color(0xffdae8ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa9cdff),
      onSecondaryFixedVariant: Color(0xff00172f),
      tertiaryFixed: Color(0xffa1f6ef),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff85d9d3),
      onTertiaryFixedVariant: Color(0xff001a19),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
