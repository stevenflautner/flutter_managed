import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';

void run({
  @required List<Object> repositories,
  @required List<Object> services,
  @required List<SingleChildCloneableWidget> providers,
  @required ValueBuilder builder,
}) {
  register(
    repositories: repositories,
    services: services
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
  Widget build(BuildContext context) => MultiProvider(
    providers: providers,
    child: builder(context),
  );
}
