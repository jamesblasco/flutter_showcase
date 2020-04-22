import 'dart:math';

import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_showcase/flutter_showcase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleTemplate extends Template {
  final bool reverse;

  SimpleTemplate({this.reverse});

  @override
  Widget builder({BuildContext context, TemplateData data, Widget app}) {
    final shouldDisplayTemplate = MediaQuery.of(context).size.width > 600;
    Widget content =
        isScreenshot ? _ScreenshotContent(data: data) : _Content(data: data);
    if (!shouldDisplayTemplate) {
      return AppWithDrawer(
        child: app,
        drawer: content,
        theme: data.theme,
      );
    } else {
      final sizedChild = Center(child: SizedBox(height: 896, child: content));
      final children = reverse == true
          ? [
              Flexible(
                  flex: 2,
                  key: Key('Preview'),
                  child: Align(alignment: Alignment.centerRight, child: app)),
              SizedBox(width: 80),
              Flexible(flex: 1, child: sizedChild),
            ]
          : [
              Expanded(flex: 2, child: sizedChild),
              SizedBox(width: 80),
              Flexible(flex: 1, key: Key('Preview'), child: app),
            ];
      return Scaffold(
        backgroundColor: data.theme.backgroundColor,
        body: FluidLayout(
          child: Fluid(
            child: Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _Content extends StatelessWidget {
  final TemplateData data;

  const _Content({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TemplateThemeData theme = data.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DefaultTextStyle(
          style: theme.titleTextStyle,
          child: Text(
            data.title,
            maxLines: 3,
            overflow: TextOverflow.clip,
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: DefaultTextStyle(
              style: theme.descriptionTextStyle,
              child: Text(
                data.description,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
        if (data.links != null)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              ...(data.links.map(
                (e) => _Link(
                  data: e,
                  theme: theme,
                ),
              ))
            ],
          ),
        SizedBox(height: 40),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () => launch('https://flutter.dev'),
              child: Image(
                  image: (theme.flutterLogoColor ?? FlutterLogoColor.original)
                      .image(),
                  height: 40),
            ),
            if (data.logoLink != null)
              Flexible(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: 40,
                  margin: EdgeInsets.only(left: 32),
                  child: _LogoLink(data: data.logoLink),
                ),
              ),
          ],
        ),
        SizedBox(height: 4),
      ],
    );
  }
}

class _ScreenshotContent extends StatelessWidget {
  final TemplateData data;

  const _ScreenshotContent({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TemplateThemeData theme = data.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DefaultTextStyle(
          style: theme.titleTextStyle,
          child: Text(
            data.title,
            maxLines: 3,
            textScaleFactor: 1.5,
            overflow: TextOverflow.clip,
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          child: DefaultTextStyle(
            style: theme.descriptionTextStyle,
            child: Text(
              data.description,
              textScaleFactor: 1.5,
              softWrap: true,
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () => launch('https://flutter.dev'),
              child: Image(
                  image: (theme.flutterLogoColor ?? FlutterLogoColor.original)
                      .image(),
                  height: 80),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class _Link extends StatelessWidget {
  final LinkData data;
  final TemplateThemeData theme;

  const _Link({Key key, this.data, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: ButtonTheme.fromButtonThemeData(
        data: theme.buttonTheme,
        child: RaisedButton(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          onPressed: () => {launch(data.url)},
          child: IconTheme(
            data: theme.buttonIconTheme.merge(IconThemeData(size: 20)),
            child: Row(
              children: [
                if (data.icon != null)
                  Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(right: 12),
                      child: data.icon),
                Text(
                  data.title,
                  style: theme.buttonTextStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoLink extends StatelessWidget {
  final LinkData data;

  const _LogoLink({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {launch(data.url)},
      child: data.icon,
    );
  }
}

class AppWithDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  final TemplateThemeData theme;

  const AppWithDrawer({Key key, this.child, this.drawer, this.theme})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppWithDrawerState();
}

class _AppWithDrawerState extends State<AppWithDrawer>
    with TickerProviderStateMixin {
  bool showInfoButton = true;

  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    super.initState();
  }

  _toggle() {
    if (animationController.value == 0) {
      animationController.forward();
    } else {
      animationController.animateBack(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final size = MediaQuery.of(context).size;

    final app = GestureDetector(
        onTap: () => setState(() => showInfoButton = !showInfoButton),
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                right: showInfoButton ? 0 : -60,
                bottom: 60,
                width: 60,
                height: 60,
                child: InkWell(
                  onTap: () => _toggle(),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(color: theme.titleTextStyle.color),
                            top: BorderSide(color: theme.titleTextStyle.color),
                            bottom:
                                BorderSide(color: theme.titleTextStyle.color)),
                        color: theme.backgroundColor,
                        boxShadow: []),
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      FontAwesomeIcons.info,
                      color: theme.titleTextStyle.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));

    return Container(
      color: theme.backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => _toggle(),
            child: Container(
              color: theme.backgroundColor,
              child: widget.drawer,
              padding:
                  EdgeInsets.only(left: 80, top: 40, right: 20, bottom: 40),
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              final t = animationController.value;
              final scale = 1 - 0.2 * t;
              Matrix4 matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-pi / 10 * t)
                ..scale(scale, scale, scale)
                ..translate(-size.width * t, 0, 0);

              return Transform(
                transform: matrix,
                origin: size.center(Offset.zero),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.black45, blurRadius: 12)
                  ]),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(24.7 * animationController.value),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),
                ),
              );
            },
            child: app,
          )
        ],
      ),
    );
    /* return InnerDrawer(
      key: _innerDrawerKey,
      scale: IDOffset.horizontal(0.8),
      borderRadius: 27,
      onTapClose: true,
      offset: IDOffset.only(right: 0.9),
      backgroundColor: theme.backgroundColor,
      rightChild:
      scaffold
      :,
    );*/
  }
}
