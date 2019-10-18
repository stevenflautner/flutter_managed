import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final _get = GetIt.instance;

T get<T>() => _get<T>();
T depends<T>(BuildContext context) => Provider.of<T>(context);
T provide<T>(BuildContext context) => Provider.of<T>(context, listen: false);

// Registers Objects from globals as a singleton
// Register services that need to be alive
// for the entirety of the lifecycle of the app.
// e.g. Api,
// Don't register Listenables here. For that, use
// providers instead.
void initialize(
  List<Object> repositories,
  List<Object> services,
  List<Object> lazyServices,
) {
  if (repositories != null)
    repositories.forEach((object) => _get.registerLazySingleton(object));
  if (services != null)
    services.forEach((object) => _get.registerSingleton(object));
  if (lazyServices != null)
    lazyServices.forEach((object) => _get.registerLazySingleton(object));
}