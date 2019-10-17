import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';

import 'dependency.dart';

typedef Future<List<Object>> _DependencyInitializer();
typedef List<Object> _Initializer(Dependency dependency);

void run({
  _DependencyInitializer dependencies,
  _Initializer repositories,
  _Initializer services,
  List<SingleChildCloneableWidget> providers,
  @required ValueBuilder builder,
}) async {
  final dependency = Dependency(await dependencies());

  register(
    repositories(dependency),
    services(dependency),
  );

  runApp(App(
    providers: providers,
    builder: builder,
  ));
}

class App extends StatelessWidget {

  final ValueBuilder builder;
  final List<SingleChildCloneableWidget> providers;

  const App({Key key, @required this.providers, @required this.builder }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (providers != null)
      return MultiProvider(
        providers: providers,
        child: builder(context),
      );
    else
      return builder(context);
  }
}