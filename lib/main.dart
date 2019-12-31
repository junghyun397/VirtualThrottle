import 'package:flutter/material.dart';

import 'page/controller/page_main_controller.dart';
import 'page/layout/builder/page_layout_builder.dart';
import 'page/layout/list/page_layout_list.dart';
import 'page/layout/store/page_layout_store.dart';
import 'page/network/page_network.dart';
import 'page/settings/page_settings.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class VirtualThrottleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VirtualThrottle",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),

      // TODO: i8n initialize
      // localizationsDelegates: [S.delegate],
      // supportedLocales: S.delegate.supportedLocales,
      // localeResolutionCallback: S.delegate.resolution(fallback: Locale('en')),

      initialRoute: "/",
      routes: {
        "/": (context) => PageMainController(),
        "/layout": (context) => PageLayoutList(),
        "/layout/builder": (context) => PageLayoutBuilder(),
        "/layout/store": (context) => PageLayoutStore(),
        "/network": (context) => PageNetwork(),
        "/settings": (context) => PageSettings(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

void main() => runApp(VirtualThrottleApp());