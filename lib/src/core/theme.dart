import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showcase/flutter_showcase.dart';
import 'package:flutter_showcase/src/frame/frame_theme.dart';

/// An immutable theme for showcase projects
///
class TemplateThemeData {
  /// Describes the contrast of the showcase page.
  ///
  final Brightness brightness;

  /// Background color of the showcase page
  ///
  final Color backgroundColor;

  /// Defines the theme of the device frame
  /// that wraps the app
  ///
  final FrameThemeData frameTheme;

  /// Defines Flutter logo appearance
  /// Options: .original, .white, .dark
  ///
  final FlutterLogoColor flutterLogoColor;

  /// Defines text style for the title
  ///
  final TextStyle titleTextStyle;

  /// Defines text style for the description text
  ///
  final TextStyle descriptionTextStyle;

  /// Defines button theme for the clickable share links
  ///
  final ButtonThemeData buttonTheme;
  final TextStyle buttonTextStyle;
  final IconThemeData buttonIconTheme;

  factory TemplateThemeData({
    Brightness brightness,
    FlutterLogoColor flutterLogoColor,
    TextStyle titleTextStyle,
    TextStyle descriptionTextStyle,
    Color backgroundColor,
    ButtonThemeData buttonTheme,
    FrameThemeData frameTheme,
    TextStyle buttonTextStyle,
    IconThemeData buttonIconTheme,
  }) {
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    backgroundColor ??= isDark ? Colors.grey[850] : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black;
    descriptionTextStyle =
        TextStyle(color: textColor, height: 1.8, fontSize: 18).merge(
      descriptionTextStyle ?? TextStyle(),
    );
    titleTextStyle = TextStyle(
            fontSize: 60.0,
            color: textColor,
            fontWeight: FontWeight.w400,
            textBaseline: TextBaseline.alphabetic,
            letterSpacing: -0.5)
        .merge(titleTextStyle ?? TextStyle());
    buttonTheme ??= ButtonThemeData(
      padding: EdgeInsets.all(12),
      buttonColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey),
      ),
    );
    buttonIconTheme ??= IconThemeData();
    buttonTextStyle ??= TextStyle();
    flutterLogoColor ??= FlutterLogoColor.original;
    frameTheme ??= FrameThemeData();

    return TemplateThemeData.raw(
        brightness: brightness,
        flutterLogoColor: flutterLogoColor,
        titleTextStyle: titleTextStyle,
        backgroundColor: backgroundColor,
        descriptionTextStyle: descriptionTextStyle,
        buttonTheme: buttonTheme,
        buttonTextStyle: buttonTextStyle,
        buttonIconTheme: buttonIconTheme,
        frameTheme: frameTheme);
  }

  TemplateThemeData.raw({
    this.flutterLogoColor,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.backgroundColor,
    this.buttonTheme,
    this.brightness,
    this.frameTheme,
    this.buttonTextStyle,
    this.buttonIconTheme,
  })  : assert(flutterLogoColor != null),
        assert(titleTextStyle != null),
        assert(descriptionTextStyle != null),
        assert(backgroundColor != null),
        assert(buttonTheme != null),
        assert(brightness != null),
        assert(buttonTextStyle != null),
        assert(buttonIconTheme != null),
        assert(frameTheme != null);

  static TemplateThemeData light() {
    return TemplateThemeData(
      brightness: Brightness.light,
      titleTextStyle: TextStyle(
          fontSize: 60.0,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: -0.5),
      flutterLogoColor: FlutterLogoColor.original,
      descriptionTextStyle: TextStyle(color: Colors.black),
      backgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey[100],
        padding: EdgeInsets.all(12),
        hoverColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  static TemplateThemeData dark() {
    return TemplateThemeData(
      brightness: Brightness.dark,
      titleTextStyle: TextStyle(
          fontSize: 60.0,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: -0.5),
      descriptionTextStyle: TextStyle(color: Colors.white),
      flutterLogoColor: FlutterLogoColor.white,
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.all(12),
        buttonColor: Colors.grey[900],
        hoverColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  static TemplateThemeData black() {
    return TemplateThemeData(
      brightness: Brightness.dark,
      titleTextStyle: TextStyle(
          fontSize: 60.0,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: -0.5),
      descriptionTextStyle: TextStyle(color: Colors.white),
      flutterLogoColor: FlutterLogoColor.white,
      backgroundColor: Colors.black,
      frameTheme: FrameThemeData(
          frameColor: Colors.white, statusBarBrightness: Brightness.dark),
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.all(12),
        buttonColor: Colors.grey[900],
        hoverColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

enum FlutterLogoColor {
  original,
  white,
  black,
}

extension FlutterLogoColorImage on FlutterLogoColor {
  ImageProvider image() {
    switch (this) {
      case FlutterLogoColor.original:
        return AssetImage(
          'assets/flutter_original.png',
          package: 'flutter_showcase',
        );
      case FlutterLogoColor.white:
        return AssetImage(
          'assets/flutter_white.png',
          package: 'flutter_showcase',
        );
      case FlutterLogoColor.black:
        return AssetImage(
          'assets/flutter_black.png',
          package: 'flutter_showcase',
        );
    }
    return null;
  }
}
