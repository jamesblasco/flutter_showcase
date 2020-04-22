import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_showcase/flutter_showcase.dart';
import 'package:flutter_showcase/src/frame/frame_theme.dart';

class FrameBuilder extends StatelessWidget {
  final Widget app;
  final TransitionBuilder builder;
  const FrameBuilder({
    this.app,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Frame(
      app: builder(context, app),
    );
  }
}

class Frame extends StatelessWidget {
  final Widget app;

  const Frame({Key key, this.app}) : super(key: key);

  static TransitionBuilder get builder => (context, app) => Frame(app: app);

  @override
  Widget build(BuildContext context) {
    if (!isShowcaseActive) {
      return app;
    }
    final theme = DefaultFrameTheme.of(context).data;
    final shouldDisplayTemplate = MediaQuery.of(context).size.width > 600;
    if (!shouldDisplayTemplate) {
      return app;
    } else {
      final MediaQueryData mediaQuery = MediaQueryData(
        size: Size(414, 896),
        padding: EdgeInsets.only(
          top: 44,
          bottom: 34,
        ),
        devicePixelRatio: 2,
      );
      return FittedBox(
        child: Material(
          color: Colors.transparent,
          child: Builder(builder: (context) {
            final device = MediaQuery(
              data: mediaQuery,
              child: SizedBox.fromSize(
                  size: mediaQuery.size,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      app,
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 44,
                        child: _StatusBar(theme: theme),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          height: 4,
                          width: 140,
                          decoration: BoxDecoration(
                              color: theme.statusBarColor,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      )
                    ],
                  )),
            );

            return Container(
              child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(38.5),
                  child: device),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: theme.frameColor, width: 12)),
            );
          }),
        ),
      );
    }
  }
}

class _StatusBar extends StatelessWidget {
  final FrameThemeData theme;

  const _StatusBar({Key key, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    return Theme(
      data: ThemeData(brightness: theme.statusBarBrightness),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 30, top: 4),
              child: Text(
                '${date.hour}:${date.minute}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: theme.statusBarColor),
              )),
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.signal_cellular_4_bar,
                  size: 14,
                ),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16),
                SizedBox(width: 4),
                Icon(CupertinoIcons.battery_charging, size: 20)
              ],
            ),
          )
        ],
      ),
    );
  }
}
