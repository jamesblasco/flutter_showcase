import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Defines the theme of the device frame
/// that wraps the app
///
/// [frameColor] allows to personalize the color of the device frame
/// [statusBarBrightness] sets the status bar to white/black
///
///
class FrameThemeData implements Equatable {
  final Color frameColor;

  final Brightness statusBarBrightness;

  // const FrameThemeData({this.frameColor, this.statusBarBrightness});
  factory FrameThemeData({Color frameColor, Brightness statusBarBrightness}) {
    frameColor ??= Colors.black;
    statusBarBrightness ??= Brightness.light;
    return FrameThemeData.raw(
      frameColor: frameColor,
      statusBarBrightness: statusBarBrightness,
    );
  }

  const FrameThemeData.raw({
    this.frameColor,
    this.statusBarBrightness,
  })  : assert(frameColor != null),
        assert(statusBarBrightness != null);

  @override
  List<Object> get props => [frameColor, statusBarBrightness];

  @override
  bool get stringify => false;

  Color get statusBarColor =>
      statusBarBrightness == Brightness.dark ? Colors.white : Colors.black;
}

class DefaultFrameTheme extends InheritedTheme {
  final FrameThemeData data;

  DefaultFrameTheme({
    Key key,
    this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  static DefaultFrameTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultFrameTheme>() ??
        DefaultFrameTheme.fallback();
  }

  DefaultFrameTheme.fallback() : data = FrameThemeData();

  @override
  bool updateShouldNotify(DefaultFrameTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final DefaultFrameTheme defaultSpacing =
        context.findAncestorWidgetOfExactType<DefaultFrameTheme>();
    return identical(this, defaultSpacing)
        ? child
        : DefaultFrameTheme(
            data: data,
            child: child,
          );
  }

/* @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

  }*/
}
