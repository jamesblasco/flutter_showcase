import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showcase/flutter_showcase.dart';
import 'package:flutter_showcase/src/frame/frame_theme.dart';

class TemplateThemeData {
  final FlutterLogoColor flutterLogoColor;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final Color backgroundColor;
  final ButtonThemeData buttonTheme;
  final Brightness brightness;
  final FrameThemeData frameTheme;
  final TextStyle buttonTextStyle;
  final IconThemeData buttonIconTheme;

  factory TemplateThemeData(
      {Brightness brightness,
      FlutterLogoColor flutterLogoColor,
      TextStyle titleTextStyle,
      TextStyle descriptionTextStyle,
      Color backgroundColor,
      ButtonThemeData buttonTheme,
      FrameThemeData frameTheme,
        TextStyle buttonTextStyle,
        IconThemeData buttonIconTheme,}) {
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    backgroundColor ??= isDark ? Colors.grey[850] : Colors.grey[50];
    descriptionTextStyle =
        TextStyle(color: Colors.black, height: 2, fontSize: 18)
            .merge(descriptionTextStyle ?? TextStyle());
    titleTextStyle = TextStyle(
            fontSize: 60.0,
            color: Colors.black,
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
        buttonTextStyle:buttonTextStyle,
        buttonIconTheme:buttonIconTheme,
        frameTheme: frameTheme);
  }

  TemplateThemeData.raw( {
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
