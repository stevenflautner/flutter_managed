import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';

void run({
  @required List<Object> repositories,
  @required List<Object> services,
  @required ValueBuilder builder,
}) {
  register(
      repositories: repositories,
      services: services
  );
  runApp(App());
}

class App extends StatelessWidget {
  final ValueBuilder builder;

  const App({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => builder(context);
}
