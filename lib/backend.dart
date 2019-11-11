import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_backend/localizator.dart';
import 'package:flutter_backend/locator.dart';
import 'package:flutter_backend/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dependency.dart';

typedef FutureOr<Iterable<dynamic>> Initializer();
typedef FutureOr<Iterable<SingleChildCloneableWidget>> _Registrator(Dependency dependency);
typedef Widget ParentBuilder(BuildContext context, Widget child);

void run({
  @required String title,
  Initializer initializer,
  _Registrator registrator,
  @required Widget startScreen,
  ParentBuilder parent,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final locator = Locator();
  final dependency = Dependency(initializer != null ? await initializer() : null);

  service(await SharedPreferences.getInstance());

  final providers = await registrator(dependency);

  final overlayStyle = dependency<SystemUiOverlayStyle>();
  if (overlayStyle != null) SystemChrome.setSystemUIOverlayStyle(overlayStyle);

  runApp(App(
    providers: providers,
    dependency: dependency,
    startScreen: startScreen,
  ));
}

class App extends StatefulWidget {

  final Dependency dependency;
  final List<SingleChildCloneableWidget> providers;
  final Widget startScreen;
  final ParentBuilder parentBuilder;

  const App({
    Key key,
    @required this.dependency,
    @required this.providers,
    @required this.startScreen,
    @required this.parentBuilder,
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

    Widget child;

    if (localizator != null) {
      child = MaterialApp(
        home: widget.startScreen,
        locale: Localizator.forcedLocale(),
        theme: widget.dependency<ThemeData>(),
        supportedLocales: localizator.supportedLocales,
        localizationsDelegates: [
          localizator,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        builder: _childBuilder,
      );
    } else {
      child = MaterialApp(
        home: widget.startScreen,
        builder: _childBuilder,
      );
    }

    return widget.parentBuilder(context, child);
  }

  Widget _childBuilder(BuildContext context, Widget child) {
    final ScrollBehavior scrollBehavior = widget.dependency();
    if (scrollBehavior != null) {
      return ScrollConfiguration(
        behavior: scrollBehavior,
        child: child,
      );
    }
    return child;
  }

  void rebuild() {
    setState(() {});
  }
}