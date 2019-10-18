import 'package:get_it/get_it.dart';

final get = GetIt.instance
  ..allowReassignment = true;

// Registers Objects from globals as a singleton
// Register services that need to be alive
// for the entirety of the lifecycle of the app.
// e.g. Api,
// Don't register Listenables here. For that, use
// providers instead.
void register(List<Object> repositories, List<Object> services, List<Object> lazyServices) {
  if (repositories != null)
    repositories.forEach((object) => get.registerLazySingleton(object));
  if (services != null)
    services.forEach((object) => get.registerSingleton(object));
  if (lazyServices != null)
    lazyServices.forEach((object) => get.registerLazySingleton(object));
}