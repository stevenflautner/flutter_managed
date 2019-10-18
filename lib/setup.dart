import 'package:flutter_backend/locator.dart';

Future<void> registerDefault() async {
  get.registerSingleton(await SharedPreferences.getInstance());
}