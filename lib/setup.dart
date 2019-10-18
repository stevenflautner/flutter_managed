import 'package:flutter_backend/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerDefault() async {
  get.registerSingleton(await SharedPreferences.getInstance());
}