import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';

import 'dependency.dart';

typedef Future<List<Object>> _DependencyInitializer();
typedef List<Object> _ServiceInitializer(Dependency dependency);
typedef List<SingleChildCloneableWidget> _ProviderInitializer(Dependency dependency);

void run({
  _DependencyInitializer dependencies,
  List<Object> repositories,
  _ServiceInitializer services,
  _ProviderInitializer providers,
  @required ValueBuilder builder,
}) async {
  final dependency = Dependency(dependencies != null ? await dependencies() : null);

  register(
    repositories,
    services(dependency),
  );

  runApp(App(
    providers: providers(dependency),
    builder: builder,
  ));
}

class App extends StatefulWidget {

  final Function(BuildContext) builder;
  final List<SingleChildCloneableWidget> providers;

  const App({Key key, @required this.providers, @required this.builder }) : super(key: key);

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
        child: widget.builder(context),
      );
    else
      return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}