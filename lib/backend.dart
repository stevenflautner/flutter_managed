import 'package:flutter/material.dart';
import 'package:flutter_backend/languages.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dependency.dart';

typedef Future<Iterable<Object>> Initializer();
typedef Iterable<Object> _ServiceInitializer(Dependency dependency);
typedef Iterable<SingleChildCloneableWidget> _ProviderInitializer(Dependency dependency);

void run({
  @required String title,
  Initializer initializer,
  Iterable<Object> repositories,
  _ServiceInitializer services,
  _ServiceInitializer lazyServices,
  _ProviderInitializer providers,
  @required Widget startScreen,
}) async {
  final dependency = Dependency(initializer != null ? await initializer() : null);

  initialize(
    repositories,
    [
      Languages(),
      await SharedPreferences.getInstance(),
      ...services(dependency)
    ],
    lazyServices(dependency),
  );

  runApp(App(
    providers: providers(dependency),
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
    final localizator = widget.dependency.of<Localizator>();

    return MaterialApp(
      home: widget.startScreen,
      supportedLocales: localizator?.supportedLocales,
      localizationsDelegates: localizator != null ? [
        localizator,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ] : null,
    );
  }

  void rebuild() {
    setState(() {});
  }
}