import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:flutter_backend/setup.dart';
import 'package:provider/provider.dart';

import 'dependency.dart';

typedef Future<List<Object>> Initializer();
typedef List<Object> _ServiceInitializer(Dependency dependency);
typedef List<SingleChildCloneableWidget> _ProviderInitializer(Dependency dependency);

void run({
  Initializer initializer,
  List<Object> repositories,
  _ServiceInitializer services,
  _ServiceInitializer lazyServices,
  _ProviderInitializer providers,
  @required Function(BuildContext, Dependency) builder,
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
    builder: builder,
    dependency: dependency,
  ));
}

class App extends StatefulWidget {

  final Dependency dependency;
  final Function(BuildContext, Dependency) builder;
  final List<SingleChildCloneableWidget> providers;

  const App({Key key, @required this.providers, @required this.builder, @required this.dependency }) : super(key: key);

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
        child: widget.builder(context, widget.dependency),
      );
    else
      return widget.builder(context, widget.dependency);
  }

  void rebuild() {
    setState(() {});
  }
}