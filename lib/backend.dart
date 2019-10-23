import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_backend/localization.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dependency.dart';

typedef FutureOr<Iterable<dynamic>> Initializer();
typedef FutureOr<Iterable<SingleChildCloneableWidget>> _Registrator(Dependency dependency);

void run({
  @required String title,
  Initializer initializer,
  _Registrator registrator,
//  _ProviderInitializer providers,
  @required Widget startScreen,
}) async {
  final dependency = Dependency(initializer != null ? await initializer() : null);

  service(await SharedPreferences.getInstance());
  final providers = registrator(dependency);

//  initialize(
//    repositories,
//    [
//      await SharedPreferences.getInstance(),
//      ...services(dependency)
//    ],
//    lazyServices != null ? lazyServices(dependency) : null,
//  );

  runApp(App(
    providers: providers,
    dependency: dependency,
    startScreen: startScreen,
  ));
}

class App extends StatefulWidget {

  final Dependency dependency;
  final Widget startScreen;
  final List<SingleChildCloneableWidget> providers;

  const App({
    Key key,
    @required this.providers,
    @required this.dependency,
    @required this.startScreen
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();

  static _AppState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_AppState>());
  }

}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    if (widget.providers != null)
      return MultiProvider(
        providers: widget.providers,
        child: _buildWidget()
      );
    else
      return _buildWidget();
  }

  Widget _buildWidget() {
    Localizator localizator;
    try {
      localizator = get();
    } on ArgumentError catch(_) {}

    if (localizator != null)
      return MaterialApp(
        home: widget.startScreen,
        locale: Localizator.forcedLocale(),
        supportedLocales: localizator.supportedLocales,
        localizationsDelegates: [
          localizator,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      );

    return MaterialApp(
      home: widget.startScreen,
    );
  }

  void rebuild() {
    setState(() {});
  }
}