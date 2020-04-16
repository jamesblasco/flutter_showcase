import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showcase/flutter_showcase.dart';
import 'package:flutter_showcase/src/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TemplateData {
  final String title;
  final String description;
  final List<LinkData> links;
  final TemplateThemeData theme;
  final LinkData logoLink;

  TemplateData( {
    this.theme,
    this.title,
    this.logoLink,
    this.description,
    this.links,
  });
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

class LinkData {
  final Widget icon;
  final String url;
  final String title;

  LinkData({this.icon, this.url, this.title});

  factory LinkData.github(String url) {
    return LinkData(
      url: url,
      title: 'Github',
      icon: Icon(
        FontAwesomeIcons.github
      ),
    );
  }

  factory LinkData.codePen(String url) {
    return LinkData(
      url: url,
      title: 'CodePen',
      icon: Icon(
          FontAwesomeIcons.codepen
      ),
    );
  }

  factory LinkData.pub(String url) {
    return LinkData(
      url: url,
      title: 'Pub.dev',
      icon: Image.asset('assets/dart.png', package: 'flutter_showcase'),
    );
  }
}

abstract class Template {
  Widget builder({
    BuildContext context,
    TemplateData data,
    Widget app,
  });
}

abstract class TemplateBuilder extends StatelessWidget {
  final String title;
  final Widget description;
  final TemplateThemeData theme;
  final List<Widget> links;
  final Widget app;

  const TemplateBuilder({
    Key key,
    this.title,
    this.description,
    this.theme,
    this.links,
    this.app,
  }) : super(key: key);

/*  static WidgetBuilder builder<T extends Template>({
    String title,
    Widget description,
    ShowcaseTheme theme,
    List<Widget> links,
    Widget app,
  }) {
    return (BuildContext context) => T(
      title: title,
      description: description,
      theme: theme,
     links: links,
      app: app,
    );
  }*/
}
