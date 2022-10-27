import 'package:flutter/material.dart';
import 'package:done/application/application.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
export 'dark_theme.dart';
export 'light_theme.dart';
export 'bloc/theme_bloc.dart';

abstract class AppTheme {
  late ThemeData themeData;

  final Color supportSeparator;
  final Color supportOverlay;

  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color labelDisable;

  final Color lightGrey;

  final Color backPrimary;
  final Color backSecondary;
  final Color backElevated;

  AppTheme({
    required this.supportSeparator,
    required this.supportOverlay,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelDisable,
    required this.lightGrey,
    required this.backPrimary,
    required this.backSecondary,
    required this.backElevated,
  }) {
    themeData = ThemeData(
      scaffoldBackgroundColor: backPrimary,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: black,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(supportSeparator),
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        color: backPrimary,
        titleTextStyle: const TextTheme().largeTitle.copyWith(
              color: labelPrimary,
            ),
      ),
      colorScheme: ColorScheme.light(
        primary: backPrimary,
        secondary: black,
        onPrimary: labelPrimary,
      ),
      buttonTheme: ButtonThemeData(
        disabledColor: labelDisable,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(const TextTheme().button),
          foregroundColor: MaterialStateProperty.all(black),
        ),
      ),
      dividerTheme: DividerThemeData(color: supportSeparator),
    );
  }

  Color get importanceColor => getIt.get<RemoteConfigService>().importanceColor;

  final red = const Color(0xFFFF6666);
  final green = const Color(0xFF6CE590);
  final black = const Color(0xFF1A1A1A);
  final grey = const Color(0xFF8E8E93);

  final white = const Color(0xFFFFFFFF);
}

extension CustomTextTheme on TextTheme {
  TextStyle get largeTitle => GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        height: 38 / 32,
      );

  TextStyle get title => GoogleFonts.raleway(
        fontSize: 20,
        height: 32 / 20,
        fontWeight: FontWeight.w500,
      );

  TextStyle get button => GoogleFonts.raleway(
        fontSize: 14,
        height: 24 / 14,
      );

  TextStyle get body => GoogleFonts.raleway(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get subhead => GoogleFonts.raleway(
        fontSize: 14,
        height: 20 / 14,
      );
}
