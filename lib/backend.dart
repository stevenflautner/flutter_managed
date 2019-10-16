import 'package:flutter/material.dart';
import 'package:flutter_backend/locator.dart';
import 'package:provider/provider.dart';

void run({
  List<Object> repositories,
  List<Object> services,
  List<SingleChildCloneableWidget> providers,
  @required ValueBuilder builder,
}) {
  register(repositories, services);
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
