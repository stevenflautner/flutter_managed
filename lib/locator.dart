// Import it for access to all registered globals
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final get = GetIt.instance;

// Registers Objects from globals as a singleton
// Register services that need to be alive
// for the entirety of the lifecycle of the app.
// e.g. Api,
// Don't register Listenables here. For that, use
// providers instead.
void register({
  @required List<Object> repositories,
  @required List<Object> services
}) {
  repositories.forEach((object) => get.registerLazySingleton(object));
  services.forEach((object) => get.registerSingleton(object));
}