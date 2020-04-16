import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_showcase/src/frame/frame.dart';
import 'package:flutter_showcase/src/frame/frame_theme.dart';
import 'package:flutter_showcase/src/showcase_template.dart';
import 'package:flutter_showcase/src/template/templates.dart';
import 'package:flutter_showcase/src/theme.dart';

import '../flutter_showcase.dart';

const isShowcaseActive =
    bool.fromEnvironment('FLUTTER_SHOWCASE', defaultValue: true);

typedef AppBuilder = Widget Function(BuildContext context, Widget app);

class Showcase extends StatelessWidget {
  final Widget app;
  final String title;
  final String description;
  final TemplateThemeData theme;
  final List<LinkData> links;
  final LinkData logoLink;
  final Template template;

  const Showcase({
    Key key,
    this.app,
    this.title,
    this.theme,
    this.description,
    this.links,
    this.template,
    this.logoLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isShowcaseActive) {
      return app;
    }
    final _template = template ?? Templates.simple;
    final _theme = theme ?? TemplateThemeData.light();
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _MediaQueryFromWindow(
          child: DefaultFrameTheme(
            data: _theme.frameTheme,
            child: Builder(builder: (context) {
              return _template.builder(
                context: context,
                app: app,
                data: TemplateData(
                    title: title,
                    links: links,
                    logoLink: logoLink,
                    theme: _theme,
                    description: description),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class CustomShowcase extends StatelessWidget {
  final Widget app;
  final AppBuilder builder;

  const CustomShowcase({Key key, this.app, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _builder = builder;
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _MediaQueryFromWindow(
          child: _builder(context, app),
        ),
      ),
    );
  }
}

/// Builds [MediaQuery] from `window` by listening to [WidgetsBinding].
///
/// It is performed in a standalone widget to rebuild **only** [MediaQuery] and
/// its dependents when `window` changes, instead of rebuilding the entire widget tree.
class _MediaQueryFromWindow extends StatefulWidget {
  const _MediaQueryFromWindow({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _MediaQueryFromWindowsState createState() => _MediaQueryFromWindowsState();
}

class _MediaQueryFromWindowsState extends State<_MediaQueryFromWindow>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // ACCESSIBILITY

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {
      // The properties of window have changed. We use them in our build
      // function, so we need setState(), but we don't cache anything locally.
    });
  }

  // METRICS

  @override
  void didChangeMetrics() {
    setState(() {
      // The properties of window have changed. We use them in our build
      // function, so we need setState(), but we don't cache anything locally.
    });
  }

  @override
  void didChangeTextScaleFactor() {
    setState(() {
      // The textScaleFactor property of window has changed. We reference
      // window in our build function, so we need to call setState(), but
      // we don't need to cache anything locally.
    });
  }

  // RENDERING
  @override
  void didChangePlatformBrightness() {
    setState(() {
      // The platformBrightness property of window has changed. We reference
      // window in our build function, so we need to call setState(), but
      // we don't need to cache anything locally.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
