import 'package:get_it/get_it.dart';

// Import it for access to all registered globals
final get = GetIt.instance;

// Registers Objects from globals as a singleton
// Register services that need to be alive
// for the entirety of the lifecycle of the app.
// e.g. Api,
// Don't register Listenables here. For that, use
// providers instead.
void registerGlobals(List<Object> globals) {
  globals.forEach((object) => get.registerSingleton(object));
}