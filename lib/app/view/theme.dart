import 'package:flutter/material.dart';

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

class ExtendedColor {
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
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;

  final ColorFamily darkMediumContrast;
}

/// Generated theme from https://material-foundation.github.io/material-theme-builder/
/// I've used this tool for over a year and it has gone from wrong to broken to
/// pretty great with some minor quirks. Internal Google politics seem to have
/// made the Flutter theme tooling ecosystem a bit chaotic, I've done themes
/// roughly 4-5 different ways in as many years.
class MaterialTheme {
  const MaterialTheme(this.textTheme);

  final TextTheme textTheme;

  List<ExtendedColor> get extendedColors => [];

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
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

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece7),
      surfaceTint: Color(0xffffb59e),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaf97),
      onPrimaryContainer: Color(0xff1e0300),
      secondary: Color(0xffffece7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe3b9ad),
      onSecondaryContainer: Color(0xff190602),
      tertiary: Color(0xffffefc2),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd3c289),
      onTertiaryContainer: Color(0xff0f0b00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a110f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece7),
      outlineVariant: Color(0xffd4beb8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfda),
      inversePrimary: Color(0xff743623),
      primaryFixed: Color(0xffffdbd0),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb59e),
      onPrimaryFixedVariant: Color(0xff280500),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe7bdb1),
      onSecondaryFixedVariant: Color(0xff200b06),
      tertiaryFixed: Color(0xfff5e2a7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd8c68d),
      onTertiaryFixedVariant: Color(0xff161100),
      surfaceDim: Color(0xff1a110f),
      surfaceBright: Color(0xff5a4d4a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff271d1b),
      surfaceContainer: Color(0xff392e2b),
      surfaceContainerHigh: Color(0xff443936),
      surfaceContainerHighest: Color(0xff504441),
    );
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd3c6),
      surfaceTint: Color(0xffffb59e),
      onPrimary: Color(0xff471505),
      primaryContainer: Color(0xffcb7c64),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffed3c6),
      onSecondary: Color(0xff381f18),
      secondaryContainer: Color(0xffae887d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeedba1),
      onTertiary: Color(0xff2e2500),
      tertiaryContainer: Color(0xffa0905c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a110f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffeed7d1),
      outline: Color(0xffc2ada8),
      outlineVariant: Color(0xffa08c87),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfda),
      inversePrimary: Color(0xff743623),
      primaryFixed: Color(0xffffdbd0),
      onPrimaryFixed: Color(0xff280500),
      primaryFixedDim: Color(0xffffb59e),
      onPrimaryFixedVariant: Color(0xff5d2513),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff200b06),
      secondaryFixedDim: Color(0xffe7bdb1),
      onSecondaryFixedVariant: Color(0xff4b2f27),
      tertiaryFixed: Color(0xfff5e2a7),
      onTertiaryFixed: Color(0xff161100),
      tertiaryFixedDim: Color(0xffd8c68d),
      onTertiaryFixedVariant: Color(0xff40350a),
      surfaceDim: Color(0xff1a110f),
      surfaceBright: Color(0xff4e423f),
      surfaceContainerLowest: Color(0xff0d0604),
      surfaceContainerLow: Color(0xff251b19),
      surfaceContainer: Color(0xff302623),
      surfaceContainerHigh: Color(0xff3b302d),
      surfaceContainerHighest: Color(0xff463b38),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb59e),
      surfaceTint: Color(0xffffb59e),
      onPrimary: Color(0xff561f0e),
      primaryContainer: Color(0xff723521),
      onPrimaryContainer: Color(0xffffdbd0),
      secondary: Color(0xffe7bdb1),
      onSecondary: Color(0xff442a22),
      secondaryContainer: Color(0xff5d4037),
      onSecondaryContainer: Color(0xffffdbd0),
      tertiary: Color(0xffd8c68d),
      onTertiary: Color(0xff3a3005),
      tertiaryContainer: Color(0xff52461a),
      onTertiaryContainer: Color(0xfff5e2a7),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a110f),
      onSurface: Color(0xfff1dfda),
      onSurfaceVariant: Color(0xffd8c2bc),
      outline: Color(0xffa08c87),
      outlineVariant: Color(0xff53433f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfda),
      inversePrimary: Color(0xff8f4c37),
      primaryFixed: Color(0xffffdbd0),
      onPrimaryFixed: Color(0xff3a0b00),
      primaryFixedDim: Color(0xffffb59e),
      onPrimaryFixedVariant: Color(0xff723521),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff2c150e),
      secondaryFixedDim: Color(0xffe7bdb1),
      onSecondaryFixedVariant: Color(0xff5d4037),
      tertiaryFixed: Color(0xfff5e2a7),
      onTertiaryFixed: Color(0xff231b00),
      tertiaryFixedDim: Color(0xffd8c68d),
      onTertiaryFixedVariant: Color(0xff52461a),
      surfaceDim: Color(0xff1a110f),
      surfaceBright: Color(0xff423734),
      surfaceContainerLowest: Color(0xff140c0a),
      surfaceContainerLow: Color(0xff231917),
      surfaceContainer: Color(0xff271d1b),
      surfaceContainerHigh: Color(0xff322825),
      surfaceContainerHighest: Color(0xff3d322f),
    );
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff501b0a),
      surfaceTint: Color(0xff8f4c37),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff753724),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3f261e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff604239),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff362b02),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff54481c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff372925),
      outlineVariant: Color(0xff554641),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2b),
      inversePrimary: Color(0xffffb59e),
      primaryFixed: Color(0xff753724),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff582210),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff604239),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff472c24),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff54481c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3d3207),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6b5b1),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede8),
      surfaceContainer: Color(0xfff1dfda),
      surfaceContainerHigh: Color(0xffe2d1cc),
      surfaceContainerHighest: Color(0xffd4c3be),
    );
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d2513),
      surfaceTint: Color(0xff8f4c37),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa15a44),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4b2f27),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff87655b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff40350a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7a6c3c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff180f0d),
      onSurfaceVariant: Color(0xff41332f),
      outline: Color(0xff5f4f4a),
      outlineVariant: Color(0xff7b6964),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2b),
      inversePrimary: Color(0xffffb59e),
      primaryFixed: Color(0xffa15a44),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff83422e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff87655b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6d4d44),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7a6c3c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff615426),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd4c3be),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ed),
      surfaceContainer: Color(0xfff7e4df),
      surfaceContainerHigh: Color(0xffebd9d4),
      surfaceContainerHighest: Color(0xffdfcec9),
    );
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8f4c37),
      surfaceTint: Color(0xff8f4c37),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdbd0),
      onPrimaryContainer: Color(0xff723521),
      secondary: Color(0xff77574d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdbd0),
      onSecondaryContainer: Color(0xff5d4037),
      tertiary: Color(0xff6b5e2f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff5e2a7),
      onTertiaryContainer: Color(0xff52461a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff231917),
      onSurfaceVariant: Color(0xff53433f),
      outline: Color(0xff85736e),
      outlineVariant: Color(0xffd8c2bc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2b),
      inversePrimary: Color(0xffffb59e),
      primaryFixed: Color(0xffffdbd0),
      onPrimaryFixed: Color(0xff3a0b00),
      primaryFixedDim: Color(0xffffb59e),
      onPrimaryFixedVariant: Color(0xff723521),
      secondaryFixed: Color(0xffffdbd0),
      onSecondaryFixed: Color(0xff2c150e),
      secondaryFixedDim: Color(0xffe7bdb1),
      onSecondaryFixedVariant: Color(0xff5d4037),
      tertiaryFixed: Color(0xfff5e2a7),
      onTertiaryFixed: Color(0xff231b00),
      tertiaryFixedDim: Color(0xffd8c68d),
      onTertiaryFixedVariant: Color(0xff52461a),
      surfaceDim: Color(0xffe8d6d1),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ed),
      surfaceContainer: Color(0xfffceae5),
      surfaceContainerHigh: Color(0xfff7e4df),
      surfaceContainerHighest: Color(0xfff1dfda),
    );
  }
}
