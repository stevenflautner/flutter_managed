import 'package:flutter/material.dart';
import 'package:flutter_backend/lang.dart';
import 'package:flutter_backend/locator.dart';
import 'package:flutter_backend/setup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dependency.dart';

typedef Future<List<Object>> Initializer();
typedef List<Object> _ServiceInitializer(Dependency dependency);
typedef List<SingleChildCloneableWidget> _ProviderInitializer(Dependency dependency);

void run({
  @required String title,
  Initializer initializer,
  List<Object> repositories,
  _ServiceInitializer services,
  _ServiceInitializer lazyServices,
  _ProviderInitializer providers,
  @required Widget startScreen,
}) async {
  await registerDefault();

  final dependency = Dependency(initializer != null ? await initializer() : null);

  register(
    repositories,
    services(dependency),
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

  const App({Key key, @required this.providers, @required this.dependency, @required this.startScreen }) : super(key: key);

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
    final localization = widget.dependency.of<AppLocalizationsDelegate>();
    return MaterialApp(
      home: widget.startScreen,
      supportedLocales: localization?.supportedLocales,
      localizationsDelegates: localization != null ? [
        localization,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ] : null,
    );
  }

  void rebuild() {
    setState(() {});
  }
}